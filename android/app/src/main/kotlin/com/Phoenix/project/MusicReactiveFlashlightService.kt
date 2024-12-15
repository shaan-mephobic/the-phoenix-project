package com.Phoenix.project

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import java.util.concurrent.atomic.AtomicBoolean
import kotlin.math.abs
import kotlin.math.log10
import kotlin.math.max
import kotlin.math.min

class MusicReactiveFlashlightService(private val context: Context) {
    companion object {
        private const val SAMPLE_RATE = 44100
        private const val CHANNEL_CONFIG = AudioFormat.CHANNEL_IN_MONO
        private const val AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT
        private const val AUDIO_SOURCE = MediaRecorder.AudioSource.MIC

        // Drum beat detection parameters
        private const val BUFFER_SIZE_MULTIPLIER = 4
        private const val PEAK_WINDOW_SIZE = 100 // ms
        private const val BEAT_THRESHOLD_MULTIPLIER = 1.5
        private const val MIN_BEAT_INTERVAL_MS = 100 // Minimum time between beats
        private const val MAX_BEAT_INTERVAL_MS = 1000 // Maximum time between beats
        private const val PEAK_HOLD_TIME_MS = 200L
        private const val PEAK_COOLDOWN_TIME_MS = 100L
    }

    private var audioRecord: AudioRecord? = null
    private var audioBuffer: ShortArray? = null
    private var bufferSize: Int = 0

    // Beat detection state
    private val beatDetector = DrumBeatDetector()
    private var lastPeakTime = 0L
    private var lastFlashOnTime = 0L
    private var isFlashCurrentlyOn = false

    private val isRunning = AtomicBoolean(false)
    private var sensitivity: Double = 50.0
    private var cameraManager: CameraManager? = null
    private var cameraId: String? = null

    private val mainHandler = Handler(Looper.getMainLooper())
    private var audioThread: Thread? = null

    // Inner class for more advanced beat detection
    private inner class DrumBeatDetector {
        private val energyBuffer = ArrayDeque<Float>()
        private var lastBeatTime = 0L
        private var beatThreshold = 0f

        fun detectBeat(audioBuffer: ShortArray, bufferSize: Int): Boolean {
            val currentTime = System.currentTimeMillis()

            // Calculate energy of the current audio chunk
            val energy = calculateEnergy(audioBuffer, bufferSize)

            // Manage energy buffer
            energyBuffer.addLast(energy)
            if (energyBuffer.size > PEAK_WINDOW_SIZE) {
                energyBuffer.removeFirst()
            }

            // Calculate dynamic threshold
            updateBeatThreshold()
println(energy)
            // Beat detection
            val isBeat = energy > beatThreshold

            // Beat interval validation
            val beatIntervalValid = (currentTime - lastBeatTime in MIN_BEAT_INTERVAL_MS..MAX_BEAT_INTERVAL_MS)

            return if (isBeat && beatIntervalValid) {
                lastBeatTime = currentTime
                true
            } else {
                false
            }
        }

        private fun calculateEnergy(audioBuffer: ShortArray, bufferSize: Int): Float {
            var sumEnergy = 0.0f
            for (i in 0 until bufferSize) {
                // Convert to float and normalize
                val sample = audioBuffer[i].toFloat() / Short.MAX_VALUE
                sumEnergy += abs(sample)
            }
            return sumEnergy / bufferSize
        }

        private fun updateBeatThreshold() {
            // Calculate moving average of energy
            val avgEnergy = if (energyBuffer.isNotEmpty()) {
                energyBuffer.sum() / energyBuffer.size
            } else 0f

            // Dynamic threshold with sensitivity adjustment
            beatThreshold = (avgEnergy * BEAT_THRESHOLD_MULTIPLIER * (1 + sensitivity / 100)).toFloat()
        }
    }

    init {
        initializeCameraManager()
    }

    @SuppressLint("ServiceCast")
    private fun initializeCameraManager() {
        cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        cameraId = cameraManager?.cameraIdList?.firstOrNull()
    }

    @SuppressLint("MissingPermission")
    fun startMusicReactiveFlashlight() {
        // Stop any existing process
        stopMusicReactiveFlashlight()

        // Check permissions
        if (!hasAudioPermission()) return

        // Initialize audio capture
        bufferSize = AudioRecord.getMinBufferSize(
                SAMPLE_RATE,
                CHANNEL_CONFIG,
                AUDIO_FORMAT
        ) * BUFFER_SIZE_MULTIPLIER

        audioBuffer = ShortArray(bufferSize)

        audioRecord = AudioRecord(
                AUDIO_SOURCE,
                SAMPLE_RATE,
                CHANNEL_CONFIG,
                AUDIO_FORMAT,
                bufferSize
        )

        // Prepare for audio processing
        isRunning.set(true)
        audioThread = Thread {
            audioRecord?.startRecording()
            processAudio()
        }.apply { start() }
    }

    private fun processAudio() {
        while (isRunning.get()) {
            audioRecord?.let { recorder ->
                audioBuffer?.let { buffer ->
                    val readSize = recorder.read(buffer, 0, buffer.size)
                    if (readSize > 0) {
                        val isDrumBeat = beatDetector.detectBeat(buffer, readSize)
                        handleFlashlight(isDrumBeat)
                    }
                }
            }

            // Reduce CPU usage
            try {
                Thread.sleep(50)
            } catch (e: InterruptedException) {
                break
            }
        }
    }

    private fun handleFlashlight(isDrumBeat: Boolean) {
        val currentTime = System.currentTimeMillis()

        mainHandler.post {
            try {
                // Peak detection with hysteresis and timing constraints
                if (isDrumBeat &&
                        (currentTime - lastPeakTime > PEAK_COOLDOWN_TIME_MS) &&
                        !isFlashCurrentlyOn
                ) {
                    // Turn on flashlight
                    cameraId?.let { id ->
                        cameraManager?.setTorchMode(id, true)
                        isFlashCurrentlyOn = true
                        lastFlashOnTime = currentTime
                        lastPeakTime = currentTime
                    }
                }
                // Check if we should turn off the flashlight
                else if (isFlashCurrentlyOn &&
                        (currentTime - lastFlashOnTime > PEAK_HOLD_TIME_MS)
                ) {
                    // Turn off flashlight
                    cameraId?.let { id ->
                        cameraManager?.setTorchMode(id, false)
                        isFlashCurrentlyOn = false
                    }
                }
            } catch (e: Exception) {
                // Handle camera torch mode change error
            }
        }
    }

    fun stopMusicReactiveFlashlight() {
        // Stop audio processing
        isRunning.set(false)

        // Stop and release audio recorder
        audioRecord?.let {
            it.stop()
            it.release()
        }
        audioRecord = null

        // Stop audio thread
        audioThread?.interrupt()
        audioThread = null

        // Turn off flashlight
        mainHandler.post {
            try {
                cameraId?.let { id ->
                    cameraManager?.setTorchMode(id, false)
                }
            } catch (e: Exception) {
                // Handle camera torch mode change error
            }

            // Reset state
            isFlashCurrentlyOn = false
            lastPeakTime = 0L
            lastFlashOnTime = 0L
        }
    }

    fun setSensitivity(newSensitivity: Double) {
        sensitivity = newSensitivity.coerceIn(0.0, 100.0)
    }

    private fun hasAudioPermission(): Boolean {
        return ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }
}
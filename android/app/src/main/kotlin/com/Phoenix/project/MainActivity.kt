package com.Phoenix.project

import android.Manifest
import android.annotation.SuppressLint
import android.app.WallpaperManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.hardware.camera2.CameraManager
import android.media.*
import android.media.audiofx.Visualizer
import android.net.Uri
import android.os.Environment
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat
import com.ryanheise.audioservice.AudioServicePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    private val channel = "com.Phoenix.project/kotlin"
    private var musicReactiveService: MusicReactiveFlashlightService? = null
    private var sensitivity: Double = 50.0

    override fun provideFlutterEngine(context: Context): FlutterEngine {
        return AudioServicePlugin.getFlutterEngine(context)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "KotlinVisualizer" -> {
                    musicReactiveService = MusicReactiveFlashlightService(context)
                    musicReactiveService?.startMusicReactiveFlashlight()
                    result.success("Visualizer started")
                }

                "sensitivityKot" -> {
                    val arguments = call.arguments<Map<Any, Double?>>()
                    if (arguments != null) sensitivity = arguments["valueFromFlutter"]!!
                    musicReactiveService?.setSensitivity(sensitivity)
                    result.success("nice")
                }

                "ResetKot" -> {
                    musicReactiveService?.stopMusicReactiveFlashlight()
                    musicReactiveService = null
                    println("STOPPPPED\n\n\n\\n\n\n\n\n stopped")
                    result.success("nice")
                }

                "homescreen" -> {
                    setHomeScreenWallpaper()
                    result.success("nice")
                }

                "broadcastFileChange" -> {
                    val arguments = call.arguments<Map<Any, String?>>()
                    if (arguments != null) {
                        val pathToUpdate: String = arguments["filePath"]!!
                        broadcastFileUpdate(pathToUpdate)
                    }
                    result.success("nice")
                }

                "returnToOld" -> {
//                resetWallpaper();
                    result.success("nice")
                }

                "wallpaperSupport?" -> {
                    val wallpaperManager = WallpaperManager.getInstance(this)
                    val good: Boolean = wallpaperManager.isWallpaperSupported
                    val prettyGood = wallpaperManager.isSetWallpaperAllowed
                    if (good && prettyGood) goForWallpaper()
                    result.success("nice")
                }

                "setRingtone" -> {
                    val arguments = call.arguments<Map<Any, String>>()
                    if (arguments != null) setRingtone(ringtonePath = arguments["path"]!!)
                    result.success("nice")
                }

                "checkSettingPermission" -> {
                    getSettingsPermission()
                    result.success("nice")
                }

                "externalStorage" -> {
                    result.success(getExternalStorageDirectories())
                }



                "deleteFileUsingPath" -> {
                    val arguments = call.arguments<Map<Any, String?>>()
                    if (arguments != null) {
                        val pathToDelete: String = arguments["path"]!!
                        deleteFileUsingPath(pathToDelete)
                        result.success("nice")
                    }
                }
            }
        }
    }



    private fun deleteFileUsingPath(path: String) {
        println("Going to delete $path");
        try{
            File(path).delete();
        }catch(e: Exception){
            println("Error deleting file: $e");
        }
        broadcastFileUpdate(path)
    }


    private fun broadcastFileUpdate(path: String) {
        context.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(File(path))))
        println("updated!")
    }



    @SuppressLint("MissingPermission")
    private fun goForWallpaper() {
        thread {
            val wallpaperManager = WallpaperManager.getInstance(this)
            val newWallpaper = BitmapFactory.decodeFile("/storage/emulated/0/Android/data/com.Phoenix.project/files/legendary-er.png")
            wallpaperManager.setBitmap(newWallpaper, null, false, WallpaperManager.FLAG_LOCK)
        }
    }

    @SuppressLint("MissingPermission")
    private fun setHomeScreenWallpaper() {
        thread {
            val wallpaperManager = WallpaperManager.getInstance(this)
            // yourWallpaper = BitmapFactory.decodeResource(context.getResources(),wallpaperManager.getDrawable())!!;
            // wallpaperManager.getDrawable()
            val newWallpaper = BitmapFactory.decodeFile("/storage/emulated/0/Android/data/com.Phoenix.project/files/legendary-er.png")
            wallpaperManager.setBitmap(newWallpaper, null, false, WallpaperManager.FLAG_SYSTEM)
        }
    }

    private fun getExternalStorageDirectories(): String? {
        val files = getExternalFilesDirs(null)
        for (file in files) {
            if (Environment.isExternalStorageRemovable(file)) {
                return file.path.replace("Android/data/com.Phoenix.project/files", "")
            }
        }
        return null
    }

    private fun getSettingsPermission() {
        if (!android.provider.Settings.System.canWrite(context)) {
            val intent = Intent(android.provider.Settings.ACTION_MANAGE_WRITE_SETTINGS)
            intent.data = Uri.parse("package:" + context.packageName)
            context.startActivity(intent)
        }
    }

    private fun setRingtone(ringtonePath: String) {
        if (android.provider.Settings.System.canWrite(context)) {
            try {
                RingtoneManager.setActualDefaultRingtoneUri(
                        context,
                        RingtoneManager.TYPE_RINGTONE,
                        Uri.fromFile(File(ringtonePath))
                )
            } catch (e: Exception) {
                Log.i("ringtone", e.toString())
                Toast.makeText(context, "Failed setting ringtone!", Toast.LENGTH_SHORT).show()
            }
        } else {
            getSettingsPermission()
        }
    }


    //    private fun flashInit() {
//        visualize()
//        startVisualizing()
//        cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
//        cameraID = cameraManager.cameraIdList[0]
//    }


//    private fun resetKot() {
//        switchVisualizing()
//        println("reset complete")
//        dontFlashDamnit()
//        onCompletingFlash = true
//    }
//
//    @SuppressLint("MissingPermission")
//    private fun visualize() {
//        mAudioBufferSize = AudioRecord.getMinBufferSize(samplingRate, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_8BIT)
//        if (ActivityCompat.checkSelfPermission(
//                this,
//                Manifest.permission.RECORD_AUDIO
//            ) != PackageManager.PERMISSION_GRANTED
//        ) {
//            return
//        }
//        mAudioRecord = AudioRecord(MediaRecorder.AudioSource.MIC, samplingRate, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_8BIT, mAudioBufferSize)
//
//        if (mAudioRecord!!.state != AudioRecord.STATE_INITIALIZED) println("AudioRecord init failed")
//        else println("AudioRecord init success")
//
//        try {
//            visualizer = Visualizer(0).apply {
//                enabled = false
//
//                measurementMode = Visualizer.MEASUREMENT_MODE_PEAK_RMS
//
//                captureSize = captureSizeRange[1]
//
//                scalingMode = Visualizer.SCALING_MODE_NORMALIZED
//
//                setDataCaptureListener(object : Visualizer.OnDataCaptureListener {
//                    override fun onFftDataCapture(visualizer: Visualizer?, fft: ByteArray?, samplingRate: Int) {
//                        if (!onCompletingFlash) updateVisualizerFFT(fft)
//                    }
//
//                    override fun onWaveFormDataCapture(visualizer: Visualizer?, waveform: ByteArray?, samplingRate: Int) {
//                        if (!onCompletingFlash) {
//                            updateVisualizer(waveform)
//                        }
//                    }
//
//
//                }, Visualizer.getMaxCaptureRate(), true, true)
//            }.apply {
//                mDataCaptureSize = captureSize.apply {
//
//                    mWaveBuffer = ByteArray(this)
//                    mFftBuffer = ByteArray(this)
//                }
//            }
//        } catch (e: Exception) {
//            println("ERROR DURING VISUALIZER INITIALIZATION: $e")
//        }
//    }
//
//    private fun updateVisualizer(bytes: ByteArray?) {
//        calculateRMSLevel(bytes)
//        val measurementPeakRms = Visualizer.MeasurementPeakRms()
//        visualizer!!.getMeasurementPeakRms(measurementPeakRms)
//    }
//
//    private fun updateVisualizerFFT(bytes: ByteArray?) {
//        calculateRMSLevel(bytes)
//    }
//
//    private fun calculateRMSLevel(audioData: ByteArray?) {
////        var amplitude = 0.0
//        val loopSize: Int = audioData!!.size / 2
//
//    }
//
//    private fun switchVisualizing() {
//        mAudioRecord!!.stop()
//        visualizer?.enabled = false
//        mAudioRecordState = false
//    }
//
//    private fun startVisualizing() {
//        onCompletingFlash = false
//        mAudioRecord!!.startRecording()
//        visualizer?.enabled = true
//        mAudioRecordState = true
//    }
//
//    private fun dontFlashDamnit() {
//        torx = false
//        cameraManager.setTorchMode(cameraID, torx)
//
//    }
}


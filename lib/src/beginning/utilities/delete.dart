import 'package:media_store_plus/media_store_plus.dart';

Future<void> deleteFileWithMediaStore(String filePath) async {
  try {
    Uri? uri = await MediaStore().getUriFromFilePath(path: filePath);
    if (uri == null) {
      throw Exception('MediaStore getUriFromFilePath failed');
    }
    print("INSIDE $uri");
    bool deleted = await MediaStore().deleteFileUsingUri(
      uriString: uri.toString(),
      forceUseMediaStore: true,
    );
    if (deleted) {
      print('File $filePath deleted using MediaStore');
    } else {
      throw Exception('MediaStore delete failed');
    }
  } catch (e) {
    print('MediaStore delete failed ($e)');
  }
}

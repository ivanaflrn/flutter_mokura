import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:cross_file/cross_file.dart';

class ImageCompressionService {
  Future<XFile> compressImage(XFile xfile) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.absolute.path, "${path.basenameWithoutExtension(xfile.path)}_compressed.jpg");

    xfile.length().then((value) => print(value));
    var result = await FlutterImageCompress.compressAndGetFile(
      xfile.path,
      targetPath,
      quality: 50,
    );
    result?.length().then((value) => print(value));

    return result!;
  }
}

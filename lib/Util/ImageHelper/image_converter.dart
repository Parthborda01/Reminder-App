import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageConverter{

  String imageToString(File image){
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
  Future<File> stringToImage(String imgString) async {
    var newBytes = base64Decode(imgString);
    String temPath = (await getTemporaryDirectory()).path;
    File imgFile=File('$temPath/AddFile.png');
    await imgFile.writeAsBytes(
        newBytes.buffer.asUint8List(newBytes.offsetInBytes, newBytes.lengthInBytes));
    return imgFile;
  }


}
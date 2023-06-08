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
    var newbytes = base64Decode(imgString);
    String tempath = (await getTemporaryDirectory()).path;
    File imgfile=File('$tempath/AddFile.png');
    await imgfile.writeAsBytes(
        newbytes.buffer.asUint8List(newbytes.offsetInBytes, newbytes.lengthInBytes));
    return imgfile;
  }


}
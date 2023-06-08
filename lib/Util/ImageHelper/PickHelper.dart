import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdfx/pdfx.dart';

class FileData {
  final double width;
  final double height;
  final File imageFile;

  FileData(this.width, this.height, this.imageFile);
}

class PickHelper {
  Future<FileData?> fetchPDF() async {
    FileData? data;
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    String? s = result?.files.single.path;
    if (s != null) {
      final document = await PdfDocument.openFile(s);
      final page = await document.getPage(1);
      //pdf into image

      double cropWidth = page.width * 3;
      double cropHeight = page.height * 3;

      final pageImage = await page.render(
        width: cropWidth, // rendered image width resolution, required
        height: cropHeight, // rendered image height resolution, required

        // Rendered image compression format, also can be PNG, WEBP*
        // Optional, default: PdfPageImageFormat.PNG
        // Web not supported
        format: PdfPageImageFormat.jpeg,

        // Image background fill color for JPEG
        // Optional, default '#ffffff'
        // Web not supported

        backgroundColor: '#ffffff',
        // Crop rect in image for render
        // Optional, default null
        // Web not supported
      );

      //file making
      var bytes = pageImage!.bytes;
      // this will get a temporary path for saving the file
      String tempath = (await getTemporaryDirectory()).path;
      // save the file
      int uniqueNumber = DateTime.now().microsecondsSinceEpoch;
      File imageFile = File('$tempath/$uniqueNumber');

      // save the image
      await imageFile.writeAsBytes(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      // closing the page
      page.close();
      // closing the document
      document.close();
      data = FileData(cropWidth, cropHeight, imageFile);
    }
    return data;
  }
}


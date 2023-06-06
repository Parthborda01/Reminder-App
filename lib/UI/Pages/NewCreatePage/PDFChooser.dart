import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:slider_button/slider_button.dart';
import 'package:student_dudes/UI/Routes/route.dart';
import 'package:student_dudes/UI/Theme/ThemeConstants.dart';
import '../../../Util/PdfToImage/PickHelper.dart';

class PDFChooser extends StatefulWidget {
  const PDFChooser({
    Key? key,
  }) : super(key: key);

  @override
  State<PDFChooser> createState() => _PDFChooserState();
}

class _PDFChooserState extends State<PDFChooser> {
  FileData? fileData;
  String error = "";
  PickHelper pickHelper = PickHelper();

  @override
  void initState() {
    // TODO: implement initState
    selectMatch();
    super.initState();
  }

  selectMatch() async {
    fileData = await pickHelper.fetchPDF();
    if (fileData == null) {
      error = "Not Selected!";
    } else {
      error = "";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: fileData == null && error.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  error.isNotEmpty
                      ? Text(error)
                      : AspectRatio(
                          aspectRatio: fileData!.width / fileData!.height,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: PhotoView(
                              filterQuality: FilterQuality.high,
                              minScale: PhotoViewComputedScale.contained * 1,
                              maxScale: PhotoViewComputedScale.contained * 2.2,
                              backgroundDecoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              imageProvider: FileImage(fileData!.imageFile),
                            ),
                          ),
                        ),
                  // Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(250, 60))
                        ),
                        onPressed: () async {
                          selectMatch();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          Text("Repick",
                              style: Theme.of(context).textTheme.headlineMedium),
                              const Icon(Icons.refresh_rounded,size: 26
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: fileData == null
                            ? const SizedBox()
                            : SliderButton(
                                backgroundColor: Theme.of(context).canvasColor,
                                buttonColor: Theme.of(context).backgroundColor,
                                baseColor: deadColor,
                                dismissible: true,
                                buttonSize: 60,
                                vibrationFlag: true,
                                action: () {
                                  Navigator.pushNamed(context, RouteNames.tableBuild,arguments: fileData).then((value) => Navigator.of(context).pop());
                                },
                                label: Text(
                                  "Slide to Load!",
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                icon: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

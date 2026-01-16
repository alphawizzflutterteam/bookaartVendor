import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf_plus/flutter_html_to_pdf_plus.dart';
// import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
// import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../base/custom_app_bar.dart';

class HtmlToPdfConverter extends StatefulWidget {
  final url;
  const HtmlToPdfConverter(this.url);

  @override
  State<HtmlToPdfConverter> createState() => _HtmlToPdfConverterState();
}

class _HtmlToPdfConverterState extends State<HtmlToPdfConverter> {
  String htmlContent = '';

  @override
  void initState() {
    super.initState();
    fetchHtmlContent();
  }

  void fetchHtmlContent() async {
    var response = await http.get(Uri.parse("${widget.url}"));
    setState(() {
      htmlContent = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "Certificate",
      ),
      // appBar: AppBar(title: Text('Certificate')),
      body: Center(
        child: htmlContent.isEmpty
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          javaScriptEnabled: true,
                        ),
                      ),
                      onWebViewCreated: (controller) {
                        controller.loadData(
                          data: htmlContent,
                          mimeType: 'text/html',
                          encoding: 'utf-8',
                        );
                      },
                    ),
                    // child: WebViewPlus(
                    //   javascriptMode: JavascriptMode.unrestricted,
                    //   onWebViewCreated: (controller) {
                    //     controller.loadString(htmlContent);
                    //   },
                    // ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final plugin = DeviceInfoPlugin();
                      final android = await plugin.androidInfo;
                      print("++++++++++++");
                      var status = android.version.sdkInt! < 33
                          ? await Permission.storage.request()
                          : PermissionStatus.granted;

                      // status = await Permission.storage.request();
                      //await Permission.storage.request();
                      print("++++++++++++${status}");
                      if (status == PermissionStatus.granted) {
                        if (mounted) {
                          setState(() {});
                        }
                        var targetPath;

                        if (Platform.isIOS) {
                          var target = await getApplicationDocumentsDirectory();
                          targetPath = target.path.toString();
                        }
                        else {
                          // var downloadsDirectory =
                          //     await DownloadsPathProvider.downloadsDirectory;
                          Directory? downloadsDirectory = await getDownloadsDirectory();
                          if (downloadsDirectory == null) {
                            downloadsDirectory = await getExternalStorageDirectory();
                          }

                          targetPath = downloadsDirectory!.path.toString();
                        }

                        var targetFileName = "Invoice_47";
                        var generatedPdfFile, filePath;
                        try {
                          final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
                            content: htmlContent,
                            configuration: PrintPdfConfiguration(
                                targetDirectory: targetPath,
                                targetName: targetFileName,
                                margins: PdfPageMargin(top: 50, bottom: 50, left: 50, right: 50),
                                printOrientation: PrintOrientation.Landscape,
                                printSize: PrintSize.A4
                            ),
                          );
                          filePath = generatedPdfFile.path;
                        } on Exception {
                          generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
                            content: htmlContent,
                            configuration: PrintPdfConfiguration(
                                targetDirectory: targetPath,
                                targetName: targetFileName,
                                margins: PdfPageMargin(top: 50, bottom: 50, left: 50, right: 50),
                                printOrientation: PrintOrientation.Landscape,
                                printSize: PrintSize.A4
                            ),
                          );
                          filePath = generatedPdfFile.path;
                        }

                        // try {
                        //   generatedPdfFile =
                        //       await FlutterHtmlToPdf.convertFromHtmlContent(
                        //           htmlContent!, targetPath, targetFileName);
                        //   filePath = generatedPdfFile.path;
                        // } on Exception {
                        //   //  filePath = targetPath + "/" + targetFileName + ".html";
                        //   generatedPdfFile =
                        //       await FlutterHtmlToPdf.convertFromHtmlContent(
                        //           htmlContent!, targetPath, targetFileName);
                        //   filePath = generatedPdfFile.path;
                        // }

                        if (mounted) {
                          setState(() {});
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "INVOICE_PATH",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.amber),
                          ),
                          /*action: SnackBarAction(
                              label: "VIEW",
                              textColor: Colors.amber,
                              onPressed: () async {
                                final result = await OpenFilex.open(filePath);
                                print("object${result.message}");
                              })*/
                          backgroundColor: Colors.white,
                          elevation: 1.0,
                        ));
                      }
                      // Implement PDF creation logic here
                    },
                    child: Text('Download'),
                  ),
                ],
              ),
      ),
    );
  }
}

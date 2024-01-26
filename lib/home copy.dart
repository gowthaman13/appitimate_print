// ignore_for_file: file_names, avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:epson_epos_example/model/constant.dart';
import 'package:epson_epos_example/model/printDetials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:epson_epos/epson_epos.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ignore: duplicate_ignore
class _HomeScreenState extends State<HomeScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  List<EpsonPrinterModel> printers = [];
  late PrintDetail printDetail;
  bool loader = false;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    WebView.platform = AndroidWebView();
  }

  onDiscoveryUSB() async {
    try {
      List<EpsonPrinterModel>? data =
          await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.USB);
      if (data != null && data.length > 0) {
        data.forEach((element) {
          print(element.toJson());
        });
        setState(() {
          printers = data;
        });
      }
    } catch (e) {
      log("Error: " + e.toString());
    }
  }

  Future<img.Image> getLogoImage() async {
    final response =
        await http.get(Uri.parse(printDetail.data.department.logo));

    if (response.statusCode == 200) {
      final List<int> bytes = response.bodyBytes;

      // Decode the original image
      img.Image originalImage = img.decodeImage(Uint8List.fromList(bytes))!;

      // Resize the image to your desired width and height
      int targetWidth = 400; // Set your desired width
      int targetHeight = 400; // Set your desired height
      img.Image resizedImage = img.copyResize(originalImage,
          width: targetWidth, height: targetHeight);

      return resizedImage;
    } else {
      throw Exception('Failed to load logo');
    }
  }

  Future<List<int>> _customEscPos() async {
    final profile = await CapabilityProfile.load();
    final generator =
        Generator(PaperSize.mm80, profile); // Using mm80 for wider paper size
    List<int> bytes = [];
    if (printDetail.data.department.logo != "" &&
        printDetail.data.department.logo.isNotEmpty) {
      final img.Image logoImage = await getLogoImage();
      //logo
      bytes += generator.image(logoImage, align: PosAlign.center);
    }

    var cashier = printDetail.data.cashier.length > 15
        ? '${printDetail.data.cashier.substring(0, 12)}..'
        : printDetail.data.cashier;

    var customer = printDetail.data.customer.name.length > 15
        ? '${printDetail.data.customer.name.substring(0, 12)}..'
        : printDetail.data.customer.name;

    bytes += generator.text('${printDetail.data.department.address}');

    bytes += generator.text('${printDetail.data.department.contact}',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('------------------------------------------------',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(
        genPrintRow2('Bill No: ${printDetail.data.billNo}',
            'Date: ${printDetail.data.date}', 1),
        styles: PosStyles(align: PosAlign.left));
    bytes += generator.text(
        genPrintRow2('Cashier: $cashier', 'Time: ${printDetail.data.time}', 1),
        styles: PosStyles(align: PosAlign.left));

    if (printDetail.data.customer.name != "" &&
        printDetail.data.customer.name != 'null') {
      bytes += generator.text(
        genPrintRow2('Customer: $customer',
            'Code: ${printDetail.data.customer.code}', 1),
      );
    }

    bytes += generator.text('------------------------------------------------',
        styles: PosStyles(
          align: PosAlign.center,
        ));

    bytes += generator.text(
        genPrintRow('NO', 'QTY', 'PRICE', 'DISCOUNT', 'TOTAL', 1),
        styles: PosStyles(align: PosAlign.left, bold: true));

    bytes += generator.text('------------------------------------------------',
        styles: PosStyles(align: PosAlign.left, bold: true));

    final items = printDetail.data.products;
    int i = 1;

    for (var item in items) {
      var truncatedLabel = item.label.length > 40
          ? '${item.label.substring(0, 40)}..'
          : item.label;

      bytes += generator.text(genPrintRow1('$i $truncatedLabel'));
      bytes += generator.text(
          genPrintRow('', '${item.qty}', '${item.unitPrice}',
              '${item.discount}', '${item.total}', 1),
          styles: PosStyles(align: PosAlign.left));
      i++;
    }

    bytes += generator.text('------------------------------------------------',
        styles: PosStyles(align: PosAlign.left));

    if (printDetail.data.serviceCharge != '0.00' &&
        printDetail.data.serviceCharge != '')
      bytes += generator.text(genPrintRow2(
          "Service Charges", '${printDetail.data.serviceCharge}', 1));
    if (printDetail.data.deliveryCharge != '0.00' &&
        printDetail.data.deliveryCharge != '')
      bytes += generator.text(genPrintRow2(
          "Delivery Charges", '${printDetail.data.deliveryCharge}', 1));
    if (printDetail.data.packageCharge != '0.00' &&
        printDetail.data.packageCharge != '')
      bytes += generator.text(
          genPrintRow2(
              "Package Charges", '${printDetail.data.packageCharge}', 1),
          styles: PosStyles(fontType: PosFontType.fontA));

    if (printDetail.data.otherCharge != '0.00' &&
        printDetail.data.otherCharge != '')
      bytes += generator.text(
          genPrintRow2("Other Charges", '${printDetail.data.otherCharge}', 1));

    bytes += generator.text(
        genPrintRow2('Net Total', '${printDetail.data.total}', 1),
        styles: PosStyles(bold: true));
    bytes += generator.text(
        genPrintRow2('Received Amount', '${printDetail.data.totalPaid}', 1));

    final balance = double.parse(printDetail.data.totalPaid) -
        double.parse(printDetail.data.total);
    //balance
    bytes += generator.text(genPrintRow2('Balance', '${balance}0', 1));

    if (double.parse(printDetail.data.totalDiscount) > 0.00) {
      bytes += generator.text(
          '------------------------------------------------',
          styles: PosStyles(align: PosAlign.left, bold: true));
      bytes += generator.text(
          genPrintRow2(
              "* Total Discount:", '${printDetail.data.totalDiscount}', 2),
          styles: PosStyles(align: PosAlign.center, bold: true));
    }

    bytes += generator.text('------------------------------------------------',
        styles: PosStyles(align: PosAlign.center, bold: true));

    // Thank you message
    bytes += generator.text(
        '${printDetail.data.department.thankMsg}\nPowered by Apptimate',
        styles: PosStyles(align: PosAlign.center));

    // Feed and cut
    // bytes += generator.feed(2);
    // bytes += generator.cut();

    return bytes;
  }

  Future<img.Image> textToImage(String text) async {
    // Create an image with a white background
    img.Image image = img.Image(200, 50);
    image.fill(img.getColor(255, 255, 255));

    // Draw the text on the image
    img.drawString(image, img.arial_24, 20, 10, text);

    return image;
  }

  Future<void> screenShot(EpsonPrinterModel printer) async {
    final img.Image logoImage = await getLogoImage();

    screenshotController
        .captureFromWidget(Column(
      children: [
        // Image.memory(logoIm  age),
        Container(
            child: Text(
          "தமிழ் அரிச்சுவடி (Tamil script) என்பது தமிழ் மொழியில் உள்ள எழுத்துகளின் வரிசை ஆகும். அரி என்னும் முன்னடை சிறு என்னும் பொருள் கொண்டது.",
          style: TextStyle(color: Colors.black),
        )),
      ],
    ))
        .then((Uint8List capturedImage) {
      setState(() {
        image = capturedImage;
      });
      onPrintTest(printer, capturedImage: capturedImage);
      // Handle captured image
    });
  }

  void onPrintTest(EpsonPrinterModel printer,
      {Uint8List? capturedImage}) async {
    setState(() {
      loader = true;
    });

    final profile = await CapabilityProfile.load();
    final generator =
        Generator(PaperSize.mm80, profile); // Using mm80 for wider paper size

    img.Image? originalImage = img.decodeImage(capturedImage!);

    List<int> bytes = [];
    bytes += generator.image(originalImage!, align: PosAlign.center);

    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];

      commands.add(command.addTextAlign(EpsonEPOSTextAlign.CENTER));
      commands.add(command.rawData(Uint8List.fromList(bytes)));
      commands.add(command.addFeedLine(2));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      await EpsonEPOS.onPrint(printer, commands);
    } catch (e) {
      log("Error printing: $e");
    } finally {
      setState(() {
        loader = false; // Hide loader when printing is done
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (image != null) Image.memory(image!),
            Center(
              child: TextButton(
                  onPressed: () async {
                    await onDiscoveryUSB();
                    screenShot(printers[0]);
                  },
                  child: Text('Click')),
            ),
            // WebView(
            //   initialUrl: 'https://Sapiduponga.apptimate.lk',
            //   javascriptMode: JavascriptMode.unrestricted,
            //   onWebViewCreated: (WebViewController webViewController) {
            //     _controller.complete(webViewController);
            //   },
            //   onProgress: (int progress) {
            //     print('WebView is loading (progress : $progress%)');
            //   },
            //   onPageStarted: (String url) {},
            //   onPageFinished: (String url) {},
            //   javascriptChannels: Set.from([
            //     JavascriptChannel(
            //       name: 'Print',
            //       onMessageReceived: (JavascriptMessage message) async {
            //         final responseJson = message.message;
            //         log(responseJson.toString());
            //         if (responseJson.isEmpty) {
            //           return;
            //         }
            //         setState(() {
            //           printDetail = PrintDetail.fromJson(jsonDecode(
            //             responseJson,
            //           ));
            //         });

            //         await onDiscoveryUSB();

            //         if (printers.length != 0) {
            //           screenShot(printers[0]);
            //         }
            //       },
            //     ),
            //   ]),
            //   gestureNavigationEnabled: true,
            //   backgroundColor: const Color(0x00000000),
            // ),
            if (loader)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}

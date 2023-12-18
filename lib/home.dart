// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:epson_epos_example/model/constant.dart';
import 'package:epson_epos_example/model/printDetials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:epson_epos/epson_epos.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
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

  @override
  void initState() {
    super.initState();
    WebView.platform = AndroidWebView();
  }

  // onDiscoveryTCP() async {
  //   try {
  //     List<EpsonPrinterModel>? data =
  //         await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.TCP);
  //     if (data != null && data.length > 0) {
  //       data.forEach((element) {
  //         print(element.toJson());
  //       });
  //       setState(() {
  //         printers = data;
  //       });
  //     }
  //   } catch (e) {
  //     log("Error: " + e.toString());
  //   }
  // }

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
      return img.decodeImage(Uint8List.fromList(bytes))!;
    } else {
      throw Exception('Failed to load logo');
    }
  }

  Future<List<int>> _customEscPos() async {
    final profile = await CapabilityProfile.load();
    final generator =
        Generator(PaperSize.mm80, profile); // Using mm80 for wider paper size
    List<int> bytes = [];
    final img.Image logoImage = await getLogoImage();
    //logo
    bytes += generator.image(logoImage, align: PosAlign.center);
    //title
    bytes += generator.text(title('Restaurant'),
        styles: PosStyles(
            align: PosAlign.center,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    bytes += generator.feed(2);

    bytes += generator.text('------------------------------------------',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text(
        genPrintRow1('Bill No: ${printDetail.data.billNo}',
            'Date: ${printDetail.data.date}', 1),
        styles: PosStyles(bold: true));
    bytes += generator.text(
        genPrintRow1('Cashier: ${printDetail.data.cashier}',
            'Time: ${printDetail.data.time}', 1),
        styles: PosStyles(bold: true));

    bytes += generator.text('------------------------------------------',
        styles: PosStyles(
          align: PosAlign.center,
        ));
    bytes += generator.text(
        genPrintRow(
            col1: 'NO',
            col2: 'QTY',
            col3: 'PRICE',
            col4: 'DISCOUNT',
            col5: 'TOTAL'),
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text('------------------------------------------',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final items = printDetail.data.products;
    int i = 1;

    for (var item in items) {
      // bytes += generator.text('${item.label}               ${item.total}',
      //     styles: PosStyles(align: PosAlign.left));
      bytes += generator.text(genPrintRow(col1: '$i', col2: '${item.label}'),
          styles: PosStyles(align: PosAlign.left));
      bytes += generator.text(genPrintRow(
          col1: '',
          col2: '${item.qty}',
          col3: '${item.unitPrice}',
          col4: '${item.discount}',
          col5: '${item.total}'));
      i++;
    }

    bytes += generator.text('------------------------------------------',
        styles: PosStyles(align: PosAlign.center));

    //net total
    bytes += generator.text(
        genPrintRow2('Net Total', '${printDetail.data.grossTotal}', 1),
        styles: PosStyles(bold: true));
    // Total
    bytes += generator.text(
        genPrintRow2('Total', '${printDetail.data.totalPaid}', 1),
        styles: PosStyles(bold: true));

    //balance
    bytes += generator.text(
        genPrintRow2('Balance', '${printDetail.data.totalPaid}', 1),
        styles: PosStyles(bold: true));

    bytes += generator.text('------------------------------------------',
        styles: PosStyles(align: PosAlign.center, bold: true));

    // Thank you message
    bytes += generator.text(
        'Thank you. Come Agian Please.\nPowered by Apptimate',
        styles: PosStyles(align: PosAlign.center, bold: true));

    // Feed and cut
    // bytes += generator.feed(2);
    // bytes += generator.cut();

    return bytes;
  }

  void onPrintTest(EpsonPrinterModel printer) async {
    EpsonEPOSCommand command = EpsonEPOSCommand();
    List<Map<String, dynamic>> commands = [];
    commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
    commands.add(command.rawData(Uint8List.fromList(await _customEscPos())));
    commands.add(command.addFeedLine(2));
    commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
    await EpsonEPOS.onPrint(printer, commands);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://restaurant.apptimate.lk',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          javascriptChannels: Set.from([
            JavascriptChannel(
              name: 'Print',
              onMessageReceived: (JavascriptMessage message) async {
                final responseJson = message.message;
                log(responseJson.toString());
                if (responseJson.isEmpty) {
                  return;
                }
                setState(() {
                  printDetail = PrintDetail.fromJson(jsonDecode(responseJson));
                });

                await onDiscoveryUSB();
                // final items = printDetail.data.products;
                // items.forEach((element) {
                //   print(element.label +
                //       " " +
                //       element.total +
                //       " " +
                //       element.qty.toString());
                // });

                if (printers.length != 0) {
                  onPrintTest(printers[0]);
                }
              },
            ),
          ]),
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        ),
      ),
    );
  }
}

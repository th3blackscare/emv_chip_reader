import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:intl/intl.dart';

class NFC_Provider{
  NFC_Provider(){}
  NFCTag? chip;
  List data = [];
  // Check availability
  var isAvailable = NFCAvailability.disabled;

// Start Session
  startSession() async {
    chip = await FlutterNfcKit.poll(timeout: Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!", iosAlertMessage: "Scan your tag");


    // perform ATR
    await transmitAPDU('00A404000000');
    // Application Selection Process (General)
    await transmitAPDU('00A404000E325041592E5359532E444446303100');
    await transmitAPDU('00A404000E315041592E5359532E444446303100');
    // await transmitAPDU('00A4040008A00000000300000000');
    // PDOL Selection
    await transmitAPDU('00A4040007A000000003101000');
    // await transmitAPDU('80A80000028300');
    // await transmitAPDU('80A80000189F66049F02069F03069F1A0295055F2A029A039C019F370400');
    getGPO();
    // stopSession();
  }

  getGPO() async {
    String GPOCommand = "80A80000238321F620C000000000000001000000000000081800000000000818";
    final now = new DateTime.now();
    String Formatter = DateFormat('yyMMdd').format(now);
    String Rand1 = [Random().nextInt(9),Random().nextInt(9)].join();
    String Rand2 = [Random().nextInt(9),Random().nextInt(9)].join();
    String Rand3 = [Random().nextInt(9),Random().nextInt(9)].join();
    String Rand4 = [Random().nextInt(9),Random().nextInt(9)].join();
    GPOCommand += Formatter+Rand1+Rand2+Rand3+Rand4+"00";
    await transmitAPDU(GPOCommand);
  }

// Stop Session
  stopSession() async {
    await FlutterNfcKit.finish();

  }

  transmitAPDU(String apdu) async {
    var result = await FlutterNfcKit.transceive(apdu, timeout: Duration(seconds: 5)); // timeout is still Android-only, persist until next change
    print(result);
  }


}

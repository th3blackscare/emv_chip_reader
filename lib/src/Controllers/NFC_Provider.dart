import 'dart:typed_data';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

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
    transmitAPDU('00A4040000');
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

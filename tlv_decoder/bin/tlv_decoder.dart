import 'package:tlv_decoder/tlv_decoder.dart' as tlv_decoder;

void main(List<String> arguments) {
  print(decodeTLV('6F25840E315041592E5359532E4444463031A5138801015F2D046172656EBF0C065F56034547599000'));
  print(dataTree);
}

List<Map<String, dynamic>> dataTree = [];

/**{
  "operation" : "",
  "tag" : "",
  "length" : "",
  "decimal" : "",
  "type" : "",
  "value"
}**/


decodeTLV(String apdu,{String parent_tag = ""}) {
  int pointer = 0;
  while (pointer < apdu.length) {
    int innerPointer = pointer;
    String tag = apdu.substring(innerPointer, innerPointer + 2);
    String tag2Bits = "";
    /**
     * check if the tag is more than 1 bytes length
     * **/
    if((int.parse(tag,radix: 16) & 0x1F) == 0x1F){

      // print("Subsequent Tage Detected - 2 Bytes");
      tag2Bits = apdu.substring(innerPointer+2, innerPointer + 4);

      if((int.parse(tag,radix: 16) & 0X7F) == 0X7F){
        // print("Subsequent Tage Detected - 3 Bytes");
        tag2Bits += apdu.substring(innerPointer+4, innerPointer + 6);
        innerPointer = innerPointer + 2;
      }

      innerPointer = innerPointer + 2;
    }
    innerPointer = innerPointer + 2;

    /**
     * getting the length tag and convert it to its equivalent Decimal Length.
     * **/

    String length = apdu.substring(innerPointer, innerPointer + 2);
    int lengthDecimal = int.parse(length, radix: 16);
    innerPointer = innerPointer + 2;
    /**
     * getting The Value
     * **/


    String data = apdu.substring(innerPointer, innerPointer + (lengthDecimal * 2));


    // print('Tag ${tag+tag2Bits} length $length $data');

    /**
     * check if the Tag is a Constructed Tag,
     * if it's constructed will use recursion to decode the value.
     * **/


    Map<String, dynamic> body = {
      "parent" : parent_tag,
      "tag" : tag+tag2Bits,
      "length" : length,
      "decimal" : lengthDecimal,
      "value" : []
    };

    if ((int.parse(tag, radix: 16) & 0X20 ) != 0) { // check for constructed tag
      // print("Constructed Tag Detected");
      body['type'] = "constructed";
      decodeTLV(data,parent_tag: tag+tag2Bits); // recursively decode inner TLV structure
    } else{
      body['type'] = "primitive";
      body['value'] = data;
    }
    // print(body);
    dataTree.add(body);

    pointer = innerPointer + (lengthDecimal * 2);

  }
  // print(dataTree);
  // return body;
}

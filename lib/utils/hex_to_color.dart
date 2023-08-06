import 'dart:ui';

import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
      var hexString = this;
    print (hexString);
   try{
   
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
   }catch (e){
  
    var col = hexString.replaceAll('#', 'ff');

    return Colors.transparent;
   }
  }
}
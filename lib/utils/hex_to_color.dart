import 'dart:ui';

extension ColorExtension on String {
  toColor() {
   try{
     var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
   }catch (e){
    return Color(0xffaad7fa);
   }
  }
}
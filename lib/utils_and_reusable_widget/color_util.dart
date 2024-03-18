import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

hexStringToColor(String hexColor){
  hexColor= hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length ==6){
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

pickImage (ImageSource sourece) async{
  final ImagePicker _imagePicker= ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: sourece);
  if (_file!= null){
    return await _file.readAsBytes();
  }
  
  print("Không tìm thấy ảnh");

}
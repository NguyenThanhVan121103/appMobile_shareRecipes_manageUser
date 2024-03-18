import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Image logoWidget(String imageName){
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 540,
    height: 160,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswoodType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: !isPasswoodType,
    autocorrect: !isPasswoodType,
    cursorColor: Colors.black12,
    style: TextStyle(color: Colors.black12.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black12,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black12.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.black26.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswoodType ? TextInputType.visiblePassword: TextInputType.emailAddress,
  );
}



Container signInSignUpButton (BuildContext context, bool isLogin, Function onTap, ){
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
    ),
    child: ElevatedButton(
      onPressed: (){
        onTap();
      },
      child: Text(
        isLogin ? 'Login In' : 'Sign Up',
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if(states.contains(MaterialState.pressed)){
              return Colors.black26;
            }
            return Colors.white70;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
          )
      ),
    ),
  );
}
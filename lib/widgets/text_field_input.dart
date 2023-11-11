import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Icon icon;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const inputBorder = InputBorder.none;

    return SizedBox(
      width: size.width * 0.8,
      child: TextField(
        cursorColor: Colors.black,
        controller: textEditingController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: icon,
          border: inputBorder,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 2, color: Colors.black)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}
class TextFieldInput2 extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  
  const TextFieldInput2({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const inputBorder = InputBorder.none;

    return SizedBox(
      width: size.width * 0.8,
      child: TextField(
        cursorColor: Colors.black,
        controller: textEditingController,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
  
          border: inputBorder,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1, color: Colors.black)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 1.5, color: Colors.black)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}




class ChampText extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Icon icon;

  const ChampText({super.key, 
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const inputBorder = InputBorder.none;

    return SizedBox(
        //margin: const EdgeInsets.symmetric(vertical: 1),
        // padding: const EdgeInsets.symmetric(vertical:1, horizontal: 20),
        // height: 50,
        width: size.width * 0.8,
        /* decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withAlpha(50)),*/
        child: TextField(
          cursorColor: Colors.black,
          controller: textEditingController,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black),
            prefixIcon: icon,
            border: inputBorder,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1, color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 2, color: Colors.black)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          ),
          keyboardType: textInputType,
          obscureText: isPass,
        ));
  }
}

class ChampTextSimple extends StatelessWidget {
  // final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const ChampTextSimple({super.key, 
    // required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
        height: 50,
        width: size.width * 0.8,
        child: TextField(
          cursorColor: Colors.blue,
          // controller: textEditingController,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:const TextStyle(color: Colors.black),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 3, color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:const BorderSide(width: 1, color: Colors.black)),
          ),
          keyboardType: textInputType,
          obscureText: isPass,
        ));
  }
}

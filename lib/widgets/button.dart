import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
   bool _isLoading = false;

   Button({super.key,   required this.text});
  
 

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return 
                 Container(
                   child:  !_isLoading
                      ? Text(
                          text,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                  width: size.width * 0.8,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    color: Colors.blue,
                  ),
                );
            
  }
}


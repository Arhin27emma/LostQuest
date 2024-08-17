import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key, required this.text, required this.press,
  });
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            )
          ),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
          backgroundColor: const MaterialStatePropertyAll(Colors.red)
        ),
        
        onPressed: press, 
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      )
    );
  }
}
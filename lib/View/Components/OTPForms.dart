import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPForms extends StatefulWidget {
  const OTPForms({super.key});
  //static String routeName = "OTPForms";

  @override
  State<OTPForms> createState() => _OTPFormsState();
}

class _OTPFormsState extends State<OTPForms> {

  final _otpController = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 34,
      child: Form(
        key: _formKey1,
        child: TextFormField(
          controller: _otpController,
          onChanged: (value){
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly
          ],
          textAlign: TextAlign.center,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              hintStyle: TextStyle(color: Colors.black26),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.red)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black26))),
                  validator: (value){
                    if (value!.length != 6) 
                      return "invalid otp";
                    return null;
                  },
        ),
        
      ),
    );
  }
}

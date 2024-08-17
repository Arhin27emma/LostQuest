import 'package:flutter/material.dart';
import 'package:lost_and_found/Model/Authentication/phoneAuth.dart';
import 'package:lost_and_found/View/Components/OTPForms.dart';
import 'package:lost_and_found/View/Components/button.dart';
import 'package:lost_and_found/View/Screens/homeScreen.dart';

class OTPVerifications extends StatefulWidget {
  const OTPVerifications({super.key});
  static String routeName = "OTPVerification.dart";

  @override
  State<OTPVerifications> createState() => _OTPVerificationsState();
}

class _OTPVerificationsState extends State<OTPVerifications> {

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();


  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage("assets/images/onboardingImage1.jpg",),
                          
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Lost And Found", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                              width: 1000,
                              height: 700,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "OTP Verification",
                                          style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20,),
                                        const Center(
                                          child: Text(
                                            "Please enter your phone number to recieve a verification code ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                          ),
                                        ),
                                        const SizedBox(height: 30,),
                                        Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            controller: _phoneController,
                                            
                                            keyboardType: TextInputType.phone,
                                            decoration: const InputDecoration(
                                              prefixText: "+233 ",
                                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                              labelText: "Phone number",
                                              hintText: "Enter Phone Number",
                                              hintStyle: TextStyle(color: Colors.black26),
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                              suffixIcon: Icon(Icons.phone_outlined),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                                borderSide: BorderSide(
                                                  color: Colors.red
                                                )
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                                borderSide: BorderSide(color: Colors.black26),
                                              ),
                                              
                                            ),
                                            validator: (value){
                                              if (value!.length != 10) 
                                                return "Invalid phone number";
                                              return null;
                                            },
                                          ),
                                          
                                        ),
                                        const SizedBox(height: 30,),
                                        DefaultButton(text: "Send OTP", press: (){
                                          if (_formKey.currentState!.validate()) {
                                            PhoneAuth.sendOTP(phone: _phoneController.text, errorStep: () => 
                                            ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              const SnackBar(
                                                content: 
                                                Text(
                                                  "Error in sending OTP", 
                                                  style: TextStyle(
                                                    color: Colors.white
                                                  ),
                                                ),
                                                backgroundColor: Colors.red, )
                                              ), 
                                              nextStep: () => showDialog(
                                                context: context, builder: (context)=> 
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: SizedBox(
                                                    width: 1000,
                                                    height: 70,
                                                    child: AlertDialog(
                                                      title: const Text("OTP verification"),
                                                      content: Column(
                                                        children: [
                                                          const Text("Enter 6 digit number"),
                                                          const Row(
                                                            children: [
                                                              SizedBox(height: 30,),
                                                              Row(
                                                                children: [
                                                                  OTPForms(),
                                                                  SizedBox(width: 10),
                                                                  OTPForms(),
                                                                  SizedBox(width: 10),
                                                                  OTPForms(),
                                                                  SizedBox(width: 10),
                                                                  OTPForms(),
                                                                  SizedBox(width: 10),
                                                                  OTPForms(),
                                                                  SizedBox(width: 10),
                                                                  OTPForms(),
                                                                ],
                                                              ),
                                                              
                                                                                                
                                                            ],
                                                          ),
                                                          TextButton(
                                                            onPressed: (){
                                                              if (_formKey1.currentState!.validate()) {
                                                                  PhoneAuth.loginWithOTP(
                                                                    OTP: _otpController.text).then((value) {
                                                                      if (value == "success") {
                                                                        Navigator.pop(context);
                                                                        Navigator.pushNamed(context, Home.routeName);
                                                                      }else{
                                                                        Navigator.pop(context);
                                                                        ScaffoldMessenger.of(context)
                                                                        .showSnackBar(
                                                                          SnackBar(
                                                                            content: 
                                                                            Text(
                                                                              value,
                                                                              style: const TextStyle(
                                                                                color: Colors.white
                                                                              ),
                                                                            ),
                                                                            backgroundColor: Colors.red, )
                                                                          );
                                                                        }
                                                                      });
                                                                }
                                                            }, 
                                                            child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.indigo, fontWeight: FontWeight.bold),))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              )
                                            );
                                          }
                                        }),
                                        
                                         
                                        
                                      ]
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/Model/Authentication/accountDetailsAuth.dart';
import 'package:lost_and_found/View/Components/button.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});
  static String routeName = "accountDetails.dart";

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsAppController = TextEditingController();

  final AccountDetailsAuth _detailsAuth = AccountDetailsAuth();

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsAppController.dispose();
    super.dispose();
  }

  void clear(){
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _whatsAppController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account Details",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        titleSpacing: 50,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "Enter Your Personal Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            const FieldNames(
              name: "Full Name",
            ),
            FormField(
              controller: _nameController,
              keyboard: TextInputType.name,
              hintText: "Enter your full name",
              icon: const Icon(Icons.person_2_outlined),
            ),
            const FieldNames(
              name: "Email",
            ),
            FormField(
              controller: _emailController,
              keyboard: TextInputType.emailAddress,
              hintText: "Enter your email address",
              icon: const Icon(Icons.email_outlined),
            ),
            const FieldNames(
              name: "Phone Number",
            ),
            FormField(
              controller: _phoneController,
              keyboard: TextInputType.phone,
              hintText: "Enter your phone number",
              icon: const Icon(Icons.call),
            ),
            const FieldNames(
              name: "WhatsApp Contact",
            ),
            FormField(
              controller: _whatsAppController,
              keyboard: TextInputType.phone,
              hintText: "Enter your whatsApp number",
              icon: const Icon(Icons.chat_outlined),
            ),
            //const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, ),
              child: Center(
                child: DefaultButton(text: "Save", press: (){
                  
                    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty || _whatsAppController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AwesomeSnackbarContent(
                            title: 'Required Fields',
                            message: 'Please fill in all fields',
                            contentType: ContentType.failure,
                          ),
                        ),);
                        clear();
                      return;
                    }else{
                      _detailsAuth.updateEmail(_emailController.text.trim());
                      _detailsAuth.updateDetails(
                        _nameController.text.trim(),
                        _phoneController.text.trim(),
                        _whatsAppController.text.trim(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AwesomeSnackbarContent(
                            title: 'Success',
                            message: 'Successfully saved',
                            contentType: ContentType.success,
                          ),
                        ),);
                    }
                    clear();
                }),
              ),
            )
          ],
                ),
        )),
    );
  }
}

class FieldNames extends StatelessWidget {
  const FieldNames({
    super.key, required this.name,
  });
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 20, bottom: 8),
      child: Text(
        name,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class FormField extends StatefulWidget {
  const FormField({
    super.key, required this.keyboard, required this.hintText, this.icon, required this.controller,
  });

  final TextInputType keyboard;
  final String hintText;
  final Icon? icon;
  final TextEditingController controller;

  @override
  State<FormField> createState() => _FormFieldState();
}

class _FormFieldState extends State<FormField> {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboard,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20, top: 11),
                suffixIcon: widget.icon,
                hintText: widget.hintText,
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none)
              ),
          ),
        ),
      ),
    );
  }
}

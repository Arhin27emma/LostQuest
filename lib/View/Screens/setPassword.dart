import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/Model/Authentication/accountDetailsAuth.dart';
import 'package:lost_and_found/View/Components/button.dart';

class PasswordSet extends StatefulWidget {
  const PasswordSet({super.key});
  static String routeName = "setPassword";

  @override
  State<PasswordSet> createState() => _PasswordSetState();
}

class _PasswordSetState extends State<PasswordSet> {
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  final AccountDetailsAuth _auth = AccountDetailsAuth();

  void dispose(){
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void clear(){
    _currentPassword.clear();
    _newPassword.clear();
    _confirmPassword.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Password Settings", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.indigo),),
        titleSpacing: 45,
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
                "Change Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            const FieldNames(
              name: "Current Password",
            ),
            FormField(
              controller: _currentPassword,
              keyboard: TextInputType.visiblePassword,
              hintText: "Enter current password",
              icon: const Icon(Icons.password),
            ),
            const FieldNames(
              name: "New Password",
            ),
            FormField(
              controller: _newPassword,
              keyboard: TextInputType.emailAddress,
              hintText: "Enter new password",
              icon: const Icon(Icons.lock_open),
              
            ),
            const FieldNames(
              name: "Confirm Password",
            ),
            FormField(
              controller: _confirmPassword,
              keyboard: TextInputType.phone,
              hintText: "Confirm new password",
              icon: const Icon(Icons.lock_outline),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 8),
              child: Center(
                child: DefaultButton(
                  text: "Save", press: (){
                 
                  if (_currentPassword.text.trim().isEmpty || _newPassword.text.trim().isEmpty || _confirmPassword.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Password error',
                              message: 'All fields required',
                              contentType: ContentType.failure,
                            ),
                          ),);
                  }
                  else if(_newPassword.text.trim().length < 6){
                    ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Password error',
                              message: 'Password must be long(at least 6 characters)',
                              contentType: ContentType.failure,
                            ),
                          ),);
                  }else{
                     _auth.updatePassword(_newPassword.text.trim(),);
                     ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: AwesomeSnackbarContent(
                              title: 'Success',
                              message: 'Password successfully updated',
                              contentType: ContentType.failure,
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
            obscureText: true,
            
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

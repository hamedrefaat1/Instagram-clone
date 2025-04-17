// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/data/firebase_service/firebase_auth.dart';
import 'package:instagram_app/util/dialog.dart';
import 'package:instagram_app/util/exceptions.dart';

class LoginScreen extends StatefulWidget {
final  VoidCallback show;
   LoginScreen({super.key , required this.show});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  FocusNode email_F = FocusNode();

  final password = TextEditingController();
  FocusNode password_F = FocusNode();

  @override
  void initState() {
    super.initState();
    email_F.addListener(() {
      setState(() {}); // ✅ عشان يعيد بناء الواجهة لما يتغير الفوكس
    });
    password_F.addListener(() {
      setState(() {}); // ✅ عشان يعيد بناء الواجهة لما يتغير الفوكس
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: 100.h, width: 96.w),
          Center(
            child: Image.asset("assets/image/logo.jpg"),
          ),
          SizedBox(
            height: 100.h,
          ),
          texitFiled(email, Icons.email, "Email", email_F),
          SizedBox(
            height: 15.h,
          ),
          texitFiled(password, Icons.lock, "Password", password_F),
          SizedBox(
            height: 15.h,
          ),
          forgetPassword(),
          SizedBox(
            height: 15.h,
          ),
          loginClickButton(),
          SizedBox(
            height: 15.h,
          ),
          dontHaveAccountGoToSignUp()
        ],
      )),
    );
  }

  Padding dontHaveAccountGoToSignUp() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have account? ",
            style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap:widget.show,
            child: Text(
              "SignUp",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Padding loginClickButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: GestureDetector(
          onTap:() async{
              try {
            await Authentication().logIn(
                email: email.text,
                password: password.text,
                context: context,
                );
          } on exceptions catch (e) {
            dialogBuilder(context, e.massage);
          }
          },
          child: Text(
            "Login",
            style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget forgetPassword() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Text(
        "Forgot your password?",
        style: TextStyle(
            fontSize: 13.sp, color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget texitFiled(TextEditingController controller, IconData icon,
      String type, FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.r)),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: type,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: Colors.grey, width: 2.w)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: Colors.black, width: 2.w)),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/data/firebase_service/firebase_auth.dart';
import 'package:instagram_app/util/dialog.dart';
import 'package:instagram_app/util/exceptions.dart';
import 'package:instagram_app/util/imagepicker.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback show;
  SignUpScreen({super.key, required this.show});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController email = TextEditingController();
  FocusNode email_F = FocusNode();

  final TextEditingController userName = TextEditingController();
  FocusNode userName_F = FocusNode();

  final bio = TextEditingController();
  FocusNode bio_F = FocusNode();

  final password = TextEditingController();
  FocusNode password_F = FocusNode();

  final passwordConfirm = TextEditingController();
  FocusNode passwordConfirm_F = FocusNode();
 
   File? _imageFile;
  @override
  void initState() {
    super.initState();
    email_F.addListener(() {
      setState(() {}); // ✅ عشان يعيد بناء الواجهة لما يتغير الفوكس
    });
    password_F.addListener(() {
      setState(() {}); // ✅ عشان يعيد بناء الواجهة لما يتغير الفوكس
    });
    userName_F.addListener(() {
      setState(() {}); // ✅ عشان يعيد بناء الواجهة لما يتغير الفوكس
    });
    passwordConfirm_F.addListener(() {
      setState(() {}); // ✅ عشان يعيد بناء الواجهة لما يتغير الفوكس
    });
    bio_F.addListener(() {
      setState(() {}); // ✅ عشان يعيد بناء الواجهة لما يتغير الفوكس
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
            SizedBox(height: 80.h, width: 96.w),
            Center(
              child: Image.asset("assets/image/logo.jpg"),
            ),
            SizedBox(
              height: 60.h,
            ),
            Center(
                child: InkWell(
              onTap: () async {
                File _imagefile = await Imagepickerr().upLoadImage("gallery");
                setState(() {
                  _imageFile = _imagefile;
                });
              },
              child: CircleAvatar(
                radius: 34.r,
                backgroundColor: Colors.grey,
                child: _imageFile==null?  CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: AssetImage("assets/image/person.png"),
                ):   CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: Image.file(_imageFile! , fit: BoxFit.cover,).image,
                ) 
              ),
            )),
            SizedBox(
              height: 30.h,
            ),
            texitFiled(email, Icons.email, "Email", email_F),
            SizedBox(
              height: 15.h,
            ),
            texitFiled(userName, Icons.person, "UserName", userName_F),
            SizedBox(
              height: 15.h,
            ),
            texitFiled(bio, Icons.edit, "Bio", bio_F),
            SizedBox(
              height: 15.h,
            ),
            texitFiled(password, Icons.lock, "Password", password_F),
            SizedBox(
              height: 15.h,
            ),
            texitFiled(passwordConfirm, Icons.lock, "Password Confirm",
                passwordConfirm_F),
            SizedBox(
              height: 15.h,
            ),
            loginClickButton(),
            SizedBox(
              height: 15.h,
            ),
            dontHaveAccountGoToSignUp()
                    ],
                  ),
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
            "Already have account? ",
            style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Sign Up",
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
      child: InkWell(
        onTap: () async {
          try {
            await Authentication().signUp(
                email: email.text,
                userName: userName.text,
                bio: bio.text,
                password: password.text,
                passwordConfirm: passwordConfirm.text,
                imgProfile: _imageFile!);
          } on exceptions catch (e) {
            dialogBuilder(context, e.massage);
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
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

// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/data/firebase_service/firestore.dart';
import 'package:instagram_app/data/firebase_service/storage.dart';

// ignore: must_be_immutable
class Add_Text_For_Post extends StatefulWidget {
  File _file;
  Add_Text_For_Post(this._file, {super.key});

  @override
  State<Add_Text_For_Post> createState() => _Add_Text_For_PostState();
}

class _Add_Text_For_PostState extends State<Add_Text_For_Post> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool islooding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'New post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    islooding = true;
                  });
                  String post_url = await StorageMethods()
                      .uploadImageToStorage('post', widget._file);
                await FirestoreMethods().creatPost(postImage:post_url , location: location.text, caption: caption.text);
                  setState(() {
                    islooding = false;
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Share',
                  style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: islooding
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.black,
                ))
              : Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        child: Row(
                          children: [
                            Container(
                              width: 65.w,
                              height: 65.h,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                image: DecorationImage(
                                  image: FileImage(widget._file),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            SizedBox(
                              width: 280.w,
                              height: 60.h,
                              child: TextField(
                                controller: caption,
                                decoration: const InputDecoration(
                                  hintText: 'Write a caption ...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SizedBox(
                          width: 280.w,
                          height: 30.h,
                          child: TextField(
                            controller: location,
                            decoration: const InputDecoration(
                              hintText: 'Add location',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/data/firebase_service/firestore.dart';
import 'package:instagram_app/data/firebase_service/storage.dart';
import 'package:video_player/video_player.dart';

class ReelsEditeScreen extends StatefulWidget {
  File videoFile;
  ReelsEditeScreen(this.videoFile, {super.key});

  @override
  State<ReelsEditeScreen> createState() => _ReelsEditeScreenState();
}
class _ReelsEditeScreenState extends State<ReelsEditeScreen> {
  final caption = TextEditingController();
  late VideoPlayerController controller;
  bool isLoading = false;
  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            isVideoInitialized = true;
          });
        }
        controller.setLooping(true);
        controller.setVolume(1.0);
        controller.play();
      }).catchError((e) {
        print("خطأ أثناء تحميل الفيديو: $e");
      });
  }

  @override
  void dispose() {
    controller.pause();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: const Text(
          'New Reels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Container(
                        width: 270.w,
                        height: 420.h,
                        child: isVideoInitialized
                            ? AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: VideoPlayer(controller),
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: caption,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Write a caption ...',
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 45.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: const Text('Save draft'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });

                            String reelsUrl = await StorageMethods()
                                .uploadImageToStorage('Reels', widget.videoFile);
                            await FirestoreMethods().creatReels(
                              video: reelsUrl,
                              caption: caption.text,
                            );

                            setState(() {
                              isLoading = false;
                            });

                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 45.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: const Text(
                              'Share',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/data/firebase_service/firestore.dart';
import 'package:instagram_app/util/cache_image.dart';
import 'package:instagram_app/widgets/comment_widget.dart';
import 'package:instagram_app/widgets/like_animation.dart';

class PostWidget extends StatefulWidget {
  final snapshot;
  PostWidget(this.snapshot);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
 
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35.w,
                  height: 35.h,
                  child:
                      CacheImage(imageUrl: widget.snapshot["userImgProfile"]),
                ),
              ),
              title: Text(
                widget.snapshot["userName"],
                style: TextStyle(fontSize: 13.sp),
              ),
              subtitle: Text(
                widget.snapshot["location"],
                style: TextStyle(fontSize: 11.sp),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        GestureDetector(
          onDoubleTap: () async {
            await doLikeWhenDoubleClick();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 375.w,
                height: 320.h,
                child: CacheImage(imageUrl: widget.snapshot["postImage"]),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 111,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 14.w,
                  ),
                  GestureDetector(
                      onTap: () async {
                        await FirestoreMethods().addORdeleteLike(
                            snapshot: widget.snapshot, type: 'posts');
                      },
                      child: widget.snapshot["likes"]
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Icon(
                              Icons.favorite,
                              size: 25.w,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_outline,
                              size: 25.w, color: Colors.black)),
                  SizedBox(
                    width: 17.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: DraggableScrollableSheet(
                                  maxChildSize: 0.6.h,
                                  initialChildSize: 0.6.h,
                                  minChildSize: 0.2.h,
                                  builder: (context, scrollController) {
                                    //***********************************************// */
                                    return CommentWidget(
                                        "posts", widget.snapshot["postId"]);
                                  }),
                            );
                          });
                    },
                    child: Image.asset(
                      "assets/image/comment.webp",
                      height: 28.h,
                    ),
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  Image.asset(
                    "assets/image/send.jpg",
                    height: 28.h,
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: Icon(
                      Icons.bookmark_border,
                      size: 25.w,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 19.w, top: 13.5.h, bottom: 5.h),
                child: Text(
                  widget.snapshot["likes"].length.toString(),
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot["userName"] + " ",
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.snapshot["caption"],
                      style: TextStyle(
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15.w,
                  top: 10.h,
                  bottom: 13.h,
                ),
                child: Text(
                  formatDate(widget.snapshot["time"].toDate(),
                      [yyyy, '-', mm, '-', dd]),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  doLikeWhenDoubleClick() async {
    setState(() {
     isLikeAnimating = true;
    });
    
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String postId = widget.snapshot["postId"]; // ID الخاص بالمنشور
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("posts").doc(postId);
    await postRef.update({
      "posts" == "posts" ? "likes" : "like": FieldValue.arrayUnion([userId])
    });
  }
}

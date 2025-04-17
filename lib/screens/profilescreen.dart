// ignore_for_file: unused_field, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/data/firebase_service/firestore.dart';
import 'package:instagram_app/data/models/usermodel.dart';
import 'package:instagram_app/screens/edit_profile_screen.dart';
import 'package:instagram_app/screens/post_screen.dart';
import 'package:instagram_app/util/cache_image.dart';

class Profilescreen extends StatefulWidget {
  final uid;
  const Profilescreen(this.uid, {super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late final _postCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPostCount();
  }

  void _getPostCount() async {
    QuerySnapshot postSnap = await _firebaseFirestore
        .collection("posts")
        .where("uid", isEqualTo: widget.uid)
        .get();
    setState(() {
      _postCount = postSnap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FutureBuilder(
                  future: FirestoreMethods().getUser(widget.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return headProfilePage(snapshot.data!);
                  }),
            ),
            StreamBuilder(
                stream: _firebaseFirestore
                    .collection("posts")
                    .where("uid", isEqualTo: widget.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  }
                  var snapLength = snapshot.data!.docs.length;
                  return SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var snap = snapshot.data!.docs[index].data();
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PostScreen(snap)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 0.4),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CacheImage(
                                  imageUrl: snap[
                                      "postImage"]), // استخدام CacheImage بدلاً من Image.network
                            ),
                          ),
                        );
                      }, childCount: snapLength),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 4,
                          childAspectRatio: 0.9));
                })
          ],
        )),
      ),
    );
  }

  Widget headProfilePage(Usermodel user) {
    bool isMyProfile = user.uid == FirebaseAuth.instance.currentUser!.uid;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: ClipOval(
                  child: SizedBox(
                      height: 80.h,
                      width: 80.w,
                      child: CacheImage(imageUrl: user.imgProfile)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 50.w,
                      ),
                      Text(
                        "$_postCount",
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Text(
                        user.followers.length.toString(),
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 60.w,
                      ),
                      Text(
                        user.following.length.toString(),
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 43.w,
                      ),
                      Text(
                        "posts",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      ),
                      SizedBox(
                        width: 13.w,
                      ),
                      Text(
                        "Following",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  user.bio,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: isMyProfile
                  ? editedProfileButton(user)
                  : followAndMessageButtons(user)),
          SizedBox(
            height: 8.h,
          ),
          SizedBox(
            height: 30.h,
            width: double.infinity,
            child: const TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [
                  Icon(Icons.grid_on),
                  Icon(Icons.video_collection),
                  Icon(Icons.person),
                ]),
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }

  Widget editedProfileButton(Usermodel user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                      uid: _auth.currentUser!.uid,
                      userName:user.userName ,
                      bio: user.bio,
                      imgProfile: user.imgProfile,
                    )));
      },
      child: Container(
        alignment: Alignment.center,
        height: 30.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(color: Colors.grey.shade500,) ),
        child: Text("Edit Your Profile"),
      ),
    );
  }

  Widget followAndMessageButtons(Usermodel user) {
    bool isFollowing =
        user.followers.contains(FirebaseAuth.instance.currentUser!.uid);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (isFollowing) {
              await FirestoreMethods().unfollowUser(user.uid);
            } else {
              await FirestoreMethods().followUser(user.uid);
            }
            setState(() {}); // تحديث الواجهة بعد الضغط
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isFollowing ? Colors.white : Colors.blue,
            side: BorderSide(color: Colors.blue),
            padding: EdgeInsets.symmetric(horizontal: 30.w),
          ),
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(color: isFollowing ? Colors.black : Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // هنا ممكن تضيف نافذة الدردشة
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            padding: EdgeInsets.symmetric(horizontal: 30.w),
          ),
          child: Text(
            "Message",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

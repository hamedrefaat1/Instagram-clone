import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_app/screens/post_screen.dart';
import 'package:instagram_app/screens/profilescreen.dart';
import 'package:instagram_app/util/cache_image.dart';

class Exploerscreen extends StatefulWidget {
  const Exploerscreen({super.key});

  @override
  State<Exploerscreen> createState() => _ExploerscreenState();
}

class _ExploerscreenState extends State<Exploerscreen> {
  final TextEditingController search = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          searchFiled(),
          if (!show)
            StreamBuilder(
                stream: _firebaseFirestore.collection("posts").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  }
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostScreen(
                                        snapshot.data!.docs[index].data())));
                          },
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.grey),
                            child: CacheImage(
                              imageUrl: snapshot.data!.docs[index]
                                          .data()
                                          .containsKey("postImage") &&
                                      snapshot.data!.docs[index]["postImage"] !=
                                          null
                                  ? snapshot.data!.docs[index]["postImage"]
                                  : "https://example.com/default_image.png", //  صورة افتراضية 
                            ),
                          ),
                        );
                      },
                      childCount: snapshot.data == null
                          ? 0
                          : snapshot.data!.docs.length,
                    ),
                    gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        pattern: const [
                          QuiltedGridTile(2, 1),
                          QuiltedGridTile(2, 2),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 1),
                          QuiltedGridTile(1, 1),
                        ]),
                  );
                }),
          if (show)
            StreamBuilder(
                stream: _firebaseFirestore
                    .collection("users")
                    .where("userName", isGreaterThanOrEqualTo: search.text)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  }
                  return SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final snap = snapshot.data!.docs[index];
                      return Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          GestureDetector(
                           onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Profilescreen(snap.id)));
                           },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundImage:
                                      snap.data().containsKey("imgProfile") &&
                                              snap["imgProfile"] != null
                                          ? NetworkImage(snap["imgProfile"])
                                          : AssetImage("assets/image/person.png")
                                              as ImageProvider,
                                ),
                                SizedBox(
                                  width: 15.h,
                                ),
                                Text(snap["userName"])
                              ],
                            ),
                          )
                        ],
                      );
                    },
                    childCount:
                        snapshot.data == null ? 0 : snapshot.data!.docs.length,
                  ));
                })
        ],
      )),
    );
  }

  SliverToBoxAdapter searchFiled() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          height: 36.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black),
                Expanded(
                    child: TextField(
                  onChanged: (value) {
                    setState(() {
                      show = value.isNotEmpty;
                    });
                  },
                  controller: search,
                  decoration: const InputDecoration(
                    hintText: "Search User",
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/data/firebase_service/firestore.dart';
import 'package:instagram_app/util/cache_image.dart';

class CommentWidget extends StatefulWidget {
  String type;
  String uidd;
   CommentWidget(this.type, this.uidd,{super.key});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final TextEditingController comment = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.r),
        topRight: Radius.circular(25.r),
      ),
      child: Container(
        color: Colors.white,
        height: 300.h,
        child: Stack(
          children: [
            
            Positioned(
              top: 5.h,
              left: 140.w,
              child: Container(
                color:Colors.black,
                height: 3.h,
                width: 100.w,
              )
              ),
              StreamBuilder(
                stream: _firestore.collection(widget.type).doc(widget.uidd).collection("comments").snapshots(),
                 builder: (context, snapshot){
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: ListView.builder(
                          itemCount: snapshot.data==null?0: snapshot.data!.docs.length,
                          itemBuilder: (context, index){
                                if(!snapshot.hasData){
                                 const  Center(child: CircularProgressIndicator());
                                }
                                return comment_item(snapshot.data!.docs[index].data());
                        }),
                      );
                 }
                ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  color:Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                         height: 45.h,
                         width: 260.w,
                         child: TextField(
                          controller: comment,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Add a comment",
                            border: InputBorder.none,
                            
                          ),
                         ),
                      ),
                      GestureDetector(
                       onTap: (){
                            if(comment.text.isNotEmpty){
                              FirestoreMethods().addComment(comment: comment.text, type: widget.type, uidd: widget.uidd);
                            }
                            setState(() {
                              comment.clear();
                            });
                       },
                        child: Icon(Icons.send))
                    ],
                  ),
                ),
              )
          ],
        )
      ),
    );
  }

  ListTile comment_item(final snapshot) => ListTile(
         leading: ClipOval(
          child: SizedBox(
            height: 35.h,
            width: 35.w,
            child: CacheImage(imageUrl: snapshot["userImgProfile"],
            ),
          ),
         ),
         title: Text(snapshot["username"], style: TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.bold),),
         subtitle: Text(snapshot["comment"], style: TextStyle(color: Colors.black, fontSize: 13.sp,)),
  );
}
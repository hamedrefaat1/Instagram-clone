// ignore_for_file: unused_field, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: SizedBox(
            width: 105.w,
            height: 28,
            child: Image.asset("assets/image/instagram.jpg"),
          ),
          leading: Image.asset("assets/image/camera.jpg"),
          actions: [
            const Icon(
              Icons.favorite_border_outlined,
              color: Colors.black,
            ),
            SizedBox(
              width: 16,
            ),
            Image.asset("assets/image/send.jpg"),
            SizedBox(
              width: 13,
            )
          ],
        ),
        body: CustomScrollView(
          slivers: [
             StreamBuilder(
              stream: _firebaseFirestore.collection("posts").orderBy("time" ,descending: true).snapshots(),
               builder: (context, snapshot){
                  return   SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if(!snapshot.hasData){
                      return Center(child:CircularProgressIndicator());
                    }
                 return PostWidget(snapshot.data!.docs[index].data());
            }, childCount: snapshot.data==null? 0 : snapshot.data!.docs.length
            )
            );
               }
               
               )
          ],
        ));
  }
}

// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/data/firebase_service/storage.dart';
import 'package:instagram_app/util/imagepicker.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  final String userName;
   final String bio;
    final String imgProfile;
  const EditProfileScreen({required this.uid, required this.userName, required this.bio, required this.imgProfile,super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController uesrNameController = TextEditingController();
    final TextEditingController bioController = TextEditingController();
    bool isLoading = false;
    File? selectImage;
    String? newProfileImage;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
      uesrNameController.text= widget.userName;
      bioController.text= widget.bio;
      newProfileImage = widget.imgProfile;
  }


 Future<void> pickImage() async{
   File? image = await Imagepickerr().upLoadImage("gallery");
   if(image!=null){
    setState(() {
      selectImage=image;
    });
   }
 }
 Future<void> uploadNewImage()async{
  if(selectImage == null){
    return;
  }
  setState(() {
    isLoading = true;
  });

  String imageUrl = await StorageMethods().uploadImageToStorage("ProfileImages", selectImage!);
  setState(() {
    newProfileImage=imageUrl;
    isLoading= false;
  });

 }
  void updateProfileInfo() async{
    setState(() {
      isLoading= true;
    });
   await FirebaseFirestore.instance.collection("users").doc(widget.uid).update({
       "userName":uesrNameController.text.trim(),
       "bio":bioController.text.trim(),
       "imgProfile":newProfileImage,
   });
  
  QuerySnapshot postsSnapshot = await FirebaseFirestore.instance.collection("posts").where("uid", isEqualTo: widget.uid).get();

  for( var doc in  postsSnapshot.docs){
         await FirebaseFirestore.instance.collection("posts").doc(doc.id).update({"userImgProfile": newProfileImage });
  }

   setState(() {
     isLoading = false;
   });
     Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Edit Profile"),),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundImage: selectImage!= null ? FileImage(selectImage!) : NetworkImage(widget.imgProfile),
                ),
                IconButton(
                  onPressed: pickImage,
                   icon: Icon(Icons.camera_alt, color: Colors.blue, size: 20,))
              ],
              ),
              SizedBox(height: 10.h,),
              if(selectImage!=null)
                  ElevatedButton(
                    onPressed:uploadNewImage ,
                    child: Text("Upload New Image")
                  )
              ,
              SizedBox(height: 20.h,),
              TextField(
                controller: uesrNameController,
                decoration: InputDecoration(
                  labelText: "UserName"
                ),
              ),
            SizedBox(height: 20.h,),
             TextField(
                controller: bioController,
                decoration: InputDecoration(
                  labelText: "Bio"
                ),
              ),
                SizedBox(height: 30.h,),
                isLoading? CircularProgressIndicator() : ElevatedButton(onPressed: updateProfileInfo, child: Text("Save Changes" , style: TextStyle(color:Colors.black),))
            ],
          ),
          ),
    );
  }
}
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_players/controller/app_controller.dart';
import 'package:music_players/model/song_model.dart';
import 'package:music_players/widgets/loading_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class UploadMusicView extends StatefulWidget {
  const UploadMusicView({super.key});

  @override
  State<UploadMusicView> createState() => _UploadMusicViewState();
}

class _UploadMusicViewState extends State<UploadMusicView> {
  File? photo;
  File? song;
  String songName = "";
  bool loading = true;

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  var appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.deepPurple.shade800.withOpacity(.8),
            Colors.deepPurple.shade200.withOpacity(.8),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              children: [
                TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Title",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.title,
                        size: 22.sp,
                        color: Colors.grey.shade400,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide.none)),
                ),
                15.h.heightBox,
                TextFormField(
                  controller: description,
                  decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Description",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.description_outlined,
                        size: 22.sp,
                        color: Colors.grey.shade400,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: BorderSide.none)),
                ),
                15.h.heightBox,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: .3.sh,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: photo != null
                                ? DecorationImage(
                                    image: FileImage(photo!), fit: BoxFit.cover)
                                : null,
                            borderRadius: BorderRadius.circular(25.r)),
                        child: IconButton(
                            onPressed: () => imagePicker(),
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 30.sp,
                            )),
                      ),
                    ),
                    20.w.widthBox,
                    Expanded(
                      child: Container(
                        height: .3.sh,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.r)),
                        child: song == null
                            ? IconButton(
                                onPressed: () => songPicker(),
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 30.sp,
                                ))
                            : InkWell(
                                onTap: () => songPicker(),
                                child: Text(
                                  songName.firstLetterUpperCase(),
                                  maxLines: 5,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
                15.h.heightBox,
                ElevatedButton(
                  onPressed: () async {
                    if (title.text.isEmpty ||
                        description.text.isEmpty ||
                        photo == null ||
                        song == null) {
                      Get.snackbar(
                          "Error", "Please upload all the required Files",
                          backgroundColor: Colors.red);
                    } else {
                      try {
                        appController.updateLoading();

                        String imageUrl =
                            await uploadData(photo!, filetype: "image");
                        String songUrl = await uploadData(song!);

                        SongsModel songsModel = SongsModel(
                            title: title.text,
                            description: description.text,
                            url: imageUrl,
                            coverurl: songUrl);
                        await FirebaseFirestore.instance
                            .collection("songs")
                            .doc()
                            .set(songsModel.toMap())
                            .then((value) {
                          Get.back();
                          Get.snackbar(
                            "Done",
                            "Song Uploaded...",
                            backgroundColor: Colors.green,
                          );
                        });
                        appController.updateLoading();
                      } on FirebaseException catch (e) {
                        appController.updateLoading();
                        Get.snackbar("Error", e.message.toString(),
                            backgroundColor: Colors.red);
                      } catch (e) {
                        appController.updateLoading();
                        Get.snackbar("Error", e.toString(),
                            backgroundColor: Colors.red);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      fixedSize: Size.fromHeight(45.h)),
                  child: Text(
                    "Upload",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            loadingWidget(context),
          ],
        ),
      ),
    );
  }

  imagePicker() async {
    XFile? xfileimage = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);
    if (xfileimage == null) {
      if (kDebugMode) {
        print("image not picked");
      }
    } else {
      photo = File(xfileimage.path);
      setState(() {});
      if (kDebugMode) {
        print("image picked");
      }
    }
  }

  songPicker() async {
    FilePickerResult? xfileSongs =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (xfileSongs == null) {
      if (kDebugMode) {
        print("song not picked");
      }
    } else {
      song = File(xfileSongs.files.first.path!);
      songName = xfileSongs.names.first!;
      setState(() {});
      if (kDebugMode) {
        print("song picked");
      }
    }
  }

  Future<String> uploadData(
    File file, {
    String filetype = "song",
  }) async {
    try {
      Reference reference =
          FirebaseStorage.instance.ref("${title.text}/$filetype/${title.text}");
      UploadTask task = reference.putFile(
          file,
          SettableMetadata(
            contentType: filetype == "song" ? "audio/mp3" : "image/jpeg",
          ));

      return await (await task).ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw e.message!;
    }
  }
}

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_players/controller/song_controller.dart';
import 'package:music_players/model/song_model.dart';
import 'package:overlay_support/overlay_support.dart';

CollectionReference songRef = FirebaseFirestore.instance.collection("songs");
CollectionReference appDataRef =
    FirebaseFirestore.instance.collection("app_data");

class AppController extends GetxController {
  List<SongsModel> songs = [];
  updateSongs(List<SongsModel> newsongs) {
    songs = newsongs;
    update();
  }

  bool loading = true;
  updateLoading() {
    loading = !loading;
    update();
  }

  Future<void> getData() async {
    try {
      QuerySnapshot _songs =
          await songRef.orderBy("time").limitToLast(10).get();
      List<SongsModel> allsong = _songs.docs
          .map(
              (e) => SongsModel.fromMap(e.data() as Map<String, dynamic>, e.id))
          .toList();
      updateSongs(allsong.reversed.toList());
      appDataRef.doc("details").snapshots().listen((event) async {
        var currentSongController = Get.put(CurrentSongController());
        String currentSongid = event.get("currentsong");
        bool isSongFound = songs.any((element) => element.id == currentSongid);

        late SongsModel song;
        if (isSongFound) {
          song = songs.where((element) => element.id == currentSongid).first;
        } else {
          DocumentSnapshot findSong = await songRef.doc(currentSongid).get();
          song = SongsModel.fromMap(
              findSong.data() as Map<String, dynamic>, findSong.id);
        }
        if (currentSongController.isPlaying &&
            currentSongController.currentsong.id == currentSongid) {
        } else {
          currentSongController.updateCurrentSong(song);
          showSimpleNotification(
              Text(
                song.title,
                style: const TextStyle(color: Colors.white),
              ),
              background: Colors.green);
        }
      });
    } on FirebaseException catch (e) {
      Get.snackbar("Error", e.message.toString());
    }
    updateLoading();
  }
}

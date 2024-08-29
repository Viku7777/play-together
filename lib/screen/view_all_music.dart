import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:music_players/controller/app_controller.dart';
import 'package:music_players/model/song_model.dart';
import 'package:music_players/screen/home_view.dart';

class ViewAllMusic extends StatefulWidget {
  const ViewAllMusic({super.key});

  @override
  State<ViewAllMusic> createState() => _ViewAllMusicState();
}

class _ViewAllMusicState extends State<ViewAllMusic> {
  var controller = Get.put(AppController());
  List<SongsModel> songs = [];
  List<SongsModel> allsongs = [];
  var route = Get.arguments ?? "";
  @override
  void initState() {
    getData();
    super.initState();
  }

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
          foregroundColor: Colors.white,
        ),
        body: GetBuilder<AppController>(
          builder: (controller) {
            return controller.loading
                ? Container(
                    height: 1.sh,
                    width: 1.sw,
                    color: Colors.black45,
                    alignment: Alignment.center,
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 60.sp,
                    ),
                  )
                : Column(
                    children: [
                      route == "search"
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              child: TextFormField(
                                onChanged: (value) {
                                  if (value.length >= 2) {
                                    songs = songs
                                        .where((element) => element.title
                                            .toLowerCase()
                                            .startsWith(value.toLowerCase()))
                                        .toList();
                                  } else if (value.isEmpty) {
                                    songs.clear();
                                    songs.addAll(allsongs);
                                  }
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Search",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.bold),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 22.sp,
                                      color: Colors.grey.shade400,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        borderSide: BorderSide.none)),
                              ),
                            )
                          : const SizedBox(),
                      Expanded(
                        child: ListView(
                          children: songs
                              .map((e) => SongTiles(currentSong: e))
                              .toList(),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  getData() async {
    controller.loading = true;
    var result = await songRef.get();
    allsongs = result.docs
        .map((e) => SongsModel.fromMap(e.data() as Map<String, dynamic>, e.id))
        .toList()
        .reversed
        .toList();
    songs = allsongs;
    controller.updateLoading();
    controller.updateSongs(songs);
  }
}

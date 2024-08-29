// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:music_players/controller/song_controller.dart';
import 'package:music_players/model/song_model.dart';

class SongCard extends StatefulWidget {
  SongsModel song;
  SongCard({
    super.key,
    required this.song,
  });

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  var currentSongcontroller = Get.put(CurrentSongController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: .5.sw,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                  image: NetworkImage(widget.song.coverurl),
                  fit: BoxFit.cover)),
        ),
        InkWell(
          onTap: () {
            Get.toNamed("/play", arguments: widget.song);
          },
          child: Container(
            height: 50.h,
            width: .40.sw,
            margin: EdgeInsets.only(bottom: 10.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: Colors.white.withOpacity(.8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  widget.song.title,
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.play_circle,
                  color: Colors.deepPurple,
                  size: 30.sp,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

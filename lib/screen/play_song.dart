// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_players/controller/song_controller.dart';
import 'package:music_players/model/song_model.dart';
import 'package:velocity_x/velocity_x.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({
    super.key,
  });

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  int index = 0;

  AudioPlayer audioplayer = AudioPlayer();
  var audioController = Get.put(CurrentSongController());
  @override
  void initState() {
    audioController.updateCurrentSong(Get.arguments as SongsModel);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<CurrentSongController>(
        builder: (controller) => Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              controller.currentsong.coverurl,
              fit: BoxFit.cover,
            ),
            const _Backgroundfilter(),
            Positioned(
              bottom: .025.sh,
              left: 0,
              right: 0,
              child: GetBuilder<CurrentSongController>(
                builder: (controller) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.currentsong.title,
                        style: TextStyle(
                            fontSize: 25.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      5.h.heightBox,
                      Text(
                        controller.currentsong.description,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      .05.sh.heightBox,
                      Row(
                        children: [
                          Text(
                            formatTime(controller.postion),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          5.w.widthBox,
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  activeTrackColor:
                                      Colors.white.withOpacity(.2),
                                  inactiveTrackColor: Colors.white,
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.white,
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 10),
                                  thumbShape: const RoundSliderThumbShape(
                                      disabledThumbRadius: 4,
                                      enabledThumbRadius: 4)),
                              child: Slider(
                                min: 0,
                                value: controller.postion.inMilliseconds
                                    .toDouble(),
                                max: controller.duration.inMilliseconds
                                        .toDouble() +
                                    10,
                                onChanged: (value) {
                                  controller.audioplayer.seek(
                                      Duration(milliseconds: value.round()));
                                },
                              ),
                            ),
                          ),
                          5.w.widthBox,
                          Text(
                            formatTime(controller.duration),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // IconButton(
                          //     onPressed: () => changeplay(false),
                          //     icon: Icon(
                          //       Icons.skip_previous,
                          //       color: Colors.white,
                          //       size: 45.sp,
                          //     )),
                          GetBuilder<CurrentSongController>(
                              builder: (controller) => IconButton(
                                    onPressed: () async {
                                      if (audioController.duration.inSeconds <=
                                          audioController.postion.inSeconds) {
                                        audioplayer.seek(Duration.zero).then(
                                            (value) =>
                                                controller.audioplayer.play());
                                      }
                                      if (controller.audioplayer.playing) {
                                        controller.audioplayer.pause();
                                      } else {
                                        controller.audioplayer.play();
                                      }
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      (!controller.audioplayer.playing ||
                                              audioController
                                                      .duration.inSeconds <=
                                                  audioController
                                                      .postion.inSeconds)
                                          ? Icons.play_circle
                                          : Icons.pause_circle,
                                      color: Colors.white,
                                      size: 75.sp,
                                    ),
                                  )),
                          // IconButton(
                          //     onPressed: () => changeplay(true),
                          //     icon: Icon(
                          //       Icons.skip_next,
                          //       color: Colors.white,
                          //       size: 45.sp,
                          //     ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.audioplayer.seek(Duration.zero);
                            },
                            child: const Icon(
                              Icons.replay_rounded,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // audioplayer.seek(Duration.zero);
                            },
                            child: const Icon(
                              Icons.cloud_download_rounded,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String formatTime(Duration? time) {
  if (time == null) {
    return "--:--";
  } else {
    return "${time.inMinutes <= 9 ? "0${time.inMinutes}" : "${time.inMinutes}"}:${time.inSeconds.remainder(60) <= 9 ? "0${time.inSeconds.remainder(60)}" : "${time.inSeconds.remainder(60)}"}";
  }
}

class _Backgroundfilter extends StatelessWidget {
  const _Backgroundfilter();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstOut,
      shaderCallback: (bounds) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [
              0.0,
              .4,
              .6
            ],
            colors: [
              Colors.white,
              Colors.white.withOpacity(.5),
              Colors.white.withOpacity(0),
            ]).createShader(bounds);
      },
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800,
            ])),
      ),
    );
  }
}

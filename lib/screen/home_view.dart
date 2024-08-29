// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:music_players/controller/app_controller.dart';
import 'package:music_players/controller/song_controller.dart';
import 'package:music_players/model/song_model.dart';
import 'package:music_players/widgets/section_header.dart';
import 'package:music_players/widgets/song_card.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var controller = Get.put(AppController());
  var currentsongcontroller = Get.put(CurrentSongController());
  @override
  void initState() {
    controller.getData();
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
          appBar: const CustomAppBar(),
          body: GetBuilder<AppController>(
              builder: (controller) => controller.loading
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
                        const _DiscoverMusic(),
                        10.h.heightBox,
                        Expanded(
                            child: ListView(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 15.h,
                                    bottom: 15.h),
                                child: sectionHeader("Trending Music")),
                            SizedBox(
                              height: 1.sh * 0.27,
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 10.w),
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) =>
                                    SongCard(song: controller.songs[index]),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 15.h,
                                    bottom: 15.h),
                                child: sectionHeader("Songs", isMore: true)),
                            ...List.generate(
                                controller.songs.length >= 10
                                    ? 5
                                    : controller.songs.length - 5, (index) {
                              SongsModel currentSong =
                                  controller.songs[5 + index];
                              return SongTiles(currentSong: currentSong);
                            })
                          ],
                        ))
                      ],
                    )),
          bottomNavigationBar: GetBuilder<CurrentSongController>(
              builder: (controller) => controller.isPlaying
                  ? GestureDetector(
                      onLongPress: () {
                        controller.isPlaying = false;
                        // controller.audioplayer.dispose();
                        controller.update();
                      },
                      child: Container(
                        height: 70.h,
                        margin: EdgeInsets.only(bottom: 10.h)
                            .copyWith(left: 10.w, right: 10.w),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(.8),
                            borderRadius: BorderRadius.circular(15.r)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.network(
                                controller.currentsong.coverurl,
                                height: 50.h,
                                width: 50.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            10.w.widthBox,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.currentsong.title,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    controller.currentsong.description,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (controller.audioplayer.playing) {
                                    controller.audioplayer.pause();
                                  } else {
                                    controller.audioplayer.play();
                                  }
                                },
                                icon: Icon(
                                  controller.audioplayer.playing
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  color: Colors.white,
                                  size: 35.sp,
                                ))
                          ],
                        ),
                      ),
                    )
                  : const SizedBox())),
    );
  }
}

class SongTiles extends StatelessWidget {
  const SongTiles({
    super.key,
    required this.currentSong,
  });

  final SongsModel currentSong;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      margin: EdgeInsets.only(bottom: 10.h).copyWith(left: 10.w, right: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(.8),
          borderRadius: BorderRadius.circular(15.r)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.network(
              currentSong.coverurl,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.cover,
            ),
          ),
          10.w.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentSong.title,
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  currentSong.description,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () => Get.toNamed("/play", arguments: currentSong),
              icon: Icon(
                Icons.play_circle,
                color: Colors.white,
                size: 35.sp,
              ))
        ],
      ),
    );
  }
}

class _DiscoverMusic extends StatelessWidget {
  const _DiscoverMusic();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome",
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Enjoy your favorite music",
            style: TextStyle(
                fontSize: 23.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          10.h.heightBox,
          TextFormField(
            readOnly: true,
            onTap: () => Get.toNamed("/all", arguments: "search"),
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: "Search",
                hintStyle: TextStyle(
                    color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                prefixIcon: Icon(
                  Icons.search,
                  size: 22.sp,
                  color: Colors.grey.shade400,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none)),
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
      leading: InkWell(
          onTap: () => Get.toNamed("/upload"),
          child: const Icon(Icons.grid_view_rounded)),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSaaB_Sr_3Yd-PJIHxJqWj5BHqpju6dsa_s_kajro2L88fynSuQkM0KCPuXu17O1D2h6I&usqp=CAU"),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:music_players/controller/app_controller.dart';

Widget loadingWidget(BuildContext context) => GetBuilder<AppController>(
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
        : const SizedBox());

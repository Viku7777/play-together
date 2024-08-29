import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_players/controller/app_controller.dart';
import 'package:music_players/model/song_model.dart';

class CurrentSongController extends GetxController {
  late SongsModel currentsong;
  bool isPlaying = false;
  bool loading = false;
  updateloading() {
    loading = !loading;
    update();
  }

  AudioPlayer audioplayer = AudioPlayer();

  Duration duration = Duration.zero;
  Duration postion = Duration.zero;

  updateCurrentSong(
    SongsModel newSong,
  ) async {
    audioplayer.playing ? audioplayer.pause() : null;
    currentsong = newSong;
    isPlaying = true;
    duration = Duration.zero;
    postion = Duration.zero;
    appDataRef.doc("details").update({"currentsong": newSong.id});
    await audioplayer.setUrl(newSong.url);
    duration = audioplayer.duration!;
    audioplayer.positionStream.listen((event) {
      updatePostion(
        event,
      );
    });
    await audioplayer.play();
    update();
  }

  updatePostion(
    Duration duration,
  ) {
    postion = duration;

    update();
  }
}

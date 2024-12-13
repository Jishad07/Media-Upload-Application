import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends ChangeNotifier {
  List<Map<String, String>> _videoUrls = [];
  bool _isLoading = false;

  List<Map<String, String>> get videoUrls => _videoUrls;
  bool get isLoading => _isLoading;

  // Fetch videos from Firebase Storage
  Future<void> fetchVideos() async {
    _isLoading = true;
    notifyListeners();

    try {
      ListResult result =
          await FirebaseStorage.instance.ref('uploads/videos').listAll();
      List<Map<String, String>> data = [];
      for (var item in result.items) {
        String videoUrl = await item.getDownloadURL();
        String videoName = item.name;
        String videoPlayUrls =
            "https://firebasestorage.googleapis.com/v0/b/here-dating-app.firebasestorage.app/o/uploads%2Fvideos%2F${item.name}?alt=media&token=37d3c092-0b79-46c2-aa37-fb0e263699a3";
        String videoLength = await _getVideoLength(videoUrl);
        String thumbnailName =
            "${item.name.replaceAll(RegExp(r'\.mp4$'), '')}_thumbnail.jpg";
        String videoImageUrl = await _getThumbnailUrl(thumbnailName);
        String thumpnailUrl =
            "https://firebasestorage.googleapis.com/v0/b/here-dating-app.firebasestorage.app/o/uploads%2Fthumbnails%2F${item.name}_thumbnail.jpg?alt=media&token=47d28969-79c4-47d5-9b86-578cc1b7d629";
        data.add({
          'videoPlayUrls': videoPlayUrls,
          'videoName': videoName,
          'videoImageUrl': videoImageUrl,
          "thumpNailUrl": thumpnailUrl,
          "videoLength": videoLength,
        });
      }
      _videoUrls = data;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // getThumbnailUrl
  Future<String> _getThumbnailUrl(String thumbnailName) async {
    try {
      Reference thumbnailRef =
          FirebaseStorage.instance.ref('uploads/thumbnails/$thumbnailName');
      String thumbnailUrl = await thumbnailRef.getDownloadURL();
      return thumbnailUrl;
    } catch (e) {
      return '';
    }
  }

  Future<String> _getVideoLength(String videoUrl) async {
    try {
      VideoPlayerController videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await videoPlayerController.initialize();
      Duration duration = videoPlayerController.value.duration;
      String videoDuration = _formatDuration(duration);
      await videoPlayerController.dispose();
      return videoDuration;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}

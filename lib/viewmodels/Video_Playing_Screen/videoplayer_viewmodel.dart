import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel extends ChangeNotifier {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _isControlsVisible = true;
  Duration _currentPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;
  bool _isMuted = false;
  List<String> videoPlaylist = [];
  int currentVideoIndex = 0;

  VideoPlayerController? get controller => _controller;
  bool get isPlaying => _isPlaying;
  bool get isInitialized => _isInitialized;
  bool get isControlsVisible => _isControlsVisible;
  Duration get currentPosition => _currentPosition;
  Duration get videoDuration => _videoDuration;
  bool get isMuted => _isMuted;
  String get currentVideoUrl => videoPlaylist[currentVideoIndex];

  // Initialize the video player
  void initialize(String videoUrl) {
    videoPlaylist = [videoUrl];
    _loadVideo(videoUrl);
  }

  void _loadVideo(String videoUrl) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    _controller?.initialize().then((_) {
      _videoDuration = _controller?.value.duration ?? Duration.zero;
      _isInitialized = true;
      notifyListeners();
      _controller?.play();
      _isPlaying = true;
    }).catchError((error) {
      _isInitialized = false;
      notifyListeners();
    });
    _controller?.addListener(() {
      _currentPosition = _controller?.value.position ?? Duration.zero;
      notifyListeners();
    });
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _controller?.pause();
    } else {
      _controller?.play();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void stopVideo() {
    _controller?.seekTo(Duration.zero);
    _controller?.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void seekTo(double seconds) {
    _controller?.seekTo(Duration(seconds: seconds.toInt()));
    notifyListeners();
  }

  void toggleControls() {
    _isControlsVisible = !_isControlsVisible;
    notifyListeners();
  }

  void toggleMute() {
    if (_isMuted) {
      _controller?.setVolume(1.0);
    } else {
      _controller?.setVolume(0.0);
    }
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void increaseVolume() {
    _controller?.setVolume(1.0);
    notifyListeners();
  }

  void nextVideo() {
    if (currentVideoIndex < videoPlaylist.length - 1) {
      currentVideoIndex++;
      _loadVideo(videoPlaylist[currentVideoIndex]);
    }
    notifyListeners();
  }

  void previousVideo() {
    if (currentVideoIndex > 0) {
      currentVideoIndex--;
      _loadVideo(videoPlaylist[currentVideoIndex]);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

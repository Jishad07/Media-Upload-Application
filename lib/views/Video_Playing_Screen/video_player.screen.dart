// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/Video_Playing_Screen/videoplayer_viewmodel.dart';
import '../Widgets/appbar_widget.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;

  VideoPlayerScreen({super.key, required this.videoUrl});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoPlayerViewModel()..initialize(videoUrl),
      child: Consumer<VideoPlayerViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: CustomAppBar(title: "Video Player"),
            body: GestureDetector(
              onTap: () {
                viewModel.toggleControls();
              },
              child: Center(
                child: viewModel.isInitialized
                    ? Stack(
                        children: [
                          AspectRatio(
                            aspectRatio:
                                viewModel.controller?.value.aspectRatio ?? 1,
                            child: VideoPlayer(viewModel.controller!),
                          ),
                          if (viewModel.isControlsVisible)
                            _buildControls(viewModel),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls(VideoPlayerViewModel viewModel) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.7)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressBar(viewModel),
            const SizedBox(height: 10),
            _buildPlaybackControls(viewModel),
            const SizedBox(height: 10),
            _buildVolumeControl(viewModel),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackControls(VideoPlayerViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 40,
          ),
          onPressed: viewModel.previousVideo,
        ),
        IconButton(
          icon: Icon(
            viewModel.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 40,
          ),
          onPressed: viewModel.togglePlayPause,
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 40,
          ),
          onPressed: viewModel.nextVideo,
        ),
      ],
    );
  }

  Widget _buildProgressBar(VideoPlayerViewModel viewModel) {
    return Slider(
      activeColor: Colors.teal,
      inactiveColor: Colors.white30,
      min: 0,
      max: viewModel.videoDuration.inSeconds.toDouble(),
      value: viewModel.currentPosition.inSeconds.toDouble(),
      onChanged: (value) {
        viewModel.seekTo(value);
      },
    );
  }

  Widget _buildVolumeControl(VideoPlayerViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            viewModel.isMuted ? Icons.volume_off : Icons.volume_up,
            color: Colors.white,
            size: 30,
          ),
          onPressed: viewModel.toggleMute,
        ),
      ],
    );
  }

  Widget buildNavigationControls(VideoPlayerViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 40,
          ),
          onPressed: viewModel.previousVideo,
        ),
        IconButton(
          icon: const Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 40,
          ),
          onPressed: viewModel.nextVideo,
        ),
      ],
    );
  }
}

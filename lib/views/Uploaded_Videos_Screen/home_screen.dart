import 'package:flutter/material.dart';
import 'package:media_upload/viewmodels/Uploaded_Videos_Screen/videos_view_model.dart';
import 'package:media_upload/views/Widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

import '../Video_Playing_Screen/video_player.screen.dart';
import '../Media_Uploading_Screen/media_upload_screen.dart';

class VideosListScreen extends StatefulWidget {
  const VideosListScreen({super.key});

  @override
  State<VideosListScreen> createState() => _VideosListScreen();
}

class _VideosListScreen extends State<VideosListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoViewModel>(context, listen: false).fetchVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Videos"),
      body: Consumer<VideoViewModel>(
        builder: (context, videoViewModel, child) {
          if (videoViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (videoViewModel.videoUrls.isEmpty) {
            return const Center(child: Text("No videos available"));
          }
          return ListView.builder(
            itemCount: videoViewModel.videoUrls.length,
            itemBuilder: (context, index) {
              var video = videoViewModel
                  .videoUrls[videoViewModel.videoUrls.length - 1 - index];
              String videoUrl = video['videoPlayUrls'] ?? '';
              String thumbnailUrl = video['thumpNailUrl'] ?? '';
              String videoName = video['videoName'] ?? '';
              String videoLength = video['videoLength'] ?? 'Unknown';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerScreen(videoUrl: videoUrl),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      thumbnailUrl.isNotEmpty
                          ? Stack(
                              children: [
                                SizedBox(
                                  height: 75,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      thumbnailUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 15,
                                    width: 40,
                                    color: Colors.black,
                                    child: Text(
                                      videoLength,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.videocam,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              videoName,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showMoreOptions(context, video);
                        },
                        icon: const Icon(Icons.more_vert_rounded),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MediaUploadScreen(),
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.upload_rounded),
      ),
    );
  }

  void _showMoreOptions(BuildContext context, Map<String, String> video) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Video'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

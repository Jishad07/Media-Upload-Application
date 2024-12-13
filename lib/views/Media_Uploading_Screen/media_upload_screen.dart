import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../viewmodels/Media_Upload_Screen/upload_media_view_model.dart';
import '../Uploaded_Videos_Screen/home_screen.dart';
import '../Widgets/appbar_widget.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MediaUploadScreen extends StatelessWidget {
  const MediaUploadScreen({super.key});

  Future<void> showProgressNotification(int progress) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'upload_channel',
      'Upload Progress',
      channelDescription: 'Shows upload progress',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'File Uploading...',
      'Progress: $progress%',
      platformChannelSpecifics,
      payload: 'upload_progress',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Media Upload"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<MediaViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.status == "Upload successful") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Upload Successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (ctx) => VideosListScreen(),
                  ),
                );
              });
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (viewModel.mediaFile != null &&
                    viewModel.status == "Uploading media...")
                  GestureDetector(
                    onTap: () => viewModel.pickMedia(),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 75,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: viewModel.thumbnailDownloadUrl != null
                                      ? Image.network(
                                          viewModel.thumbnailDownloadUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              if (viewModel.thumbnailDownloadUrl != null)
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LinearProgressIndicator(
                                        minHeight: 20,
                                        color: Colors.teal,
                                        value: viewModel.progress / 100,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${viewModel.progress.toStringAsFixed(2)}%",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.teal, Colors.blueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            child: Icon(
                              Icons.cloud_upload_outlined,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: viewModel.pickMedia,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.teal,
                              ),
                              child: const Center(
                                child: Text(
                                  'Upload Media',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (viewModel.status != "Idle")
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      viewModel.status,
                      style: TextStyle(
                        fontSize: 18,
                        color: viewModel.status == "Upload successful"
                            ? Colors.green
                            : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                if (viewModel.status == "Uploading media...")
                  const SpinKitCircle(
                    color: Colors.teal,
                    size: 50,
                  ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

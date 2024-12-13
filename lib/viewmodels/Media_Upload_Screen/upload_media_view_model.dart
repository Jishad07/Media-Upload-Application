import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MediaViewModel extends ChangeNotifier {
  FirebaseStorage storage = FirebaseStorage.instance;
  File? _mediaFile;
  String _status = "Idle";
  double _progress = 0;
  String? _thumbnailDownloadUrl;
  final double minFileSizeMB = 100;
  bool _isUploading = false;
 File? get mediaFile => _mediaFile;
 String get status => _status;
double get progress => _progress;
String? get thumbnailDownloadUrl => _thumbnailDownloadUrl;

  // method of  pick media (video)
  Future<void> pickMedia() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'avi'],
    );
    if (pickedFile != null) {
      _mediaFile = File(pickedFile.files.single.path!);

      // Check file size
      double fileSizeMB = _mediaFile!.lengthSync() / (1024 * 1024);
      if (fileSizeMB < minFileSizeMB) {
        _status = "File size is too small. Minimum size is ${minFileSizeMB}MB.";
        notifyListeners();
        showErrorNotification(
            "File size is too small. Minimum size is ${minFileSizeMB}MB.");
        return;
      }
    
    // Check file type
      String fileExtension = extension(_mediaFile!.path);
      if (!['.mp4', '.mov', '.avi'].contains(fileExtension)) {
        _status = "Unsupported file type";
        notifyListeners();
        showErrorNotification("Unsupported file type");
        return;
      }
      _status = "Media Selected";
      uploadMedia();
      notifyListeners();

      // Create the thumbnail for the selected video
      try {
        File thumbnailFile = await createThumbnail(_mediaFile!);
        _thumbnailDownloadUrl = await uploadThumbnail(thumbnailFile);
        notifyListeners();
      } catch (e) {
        _status = "Error generating thumbnail: $e";
        notifyListeners();
        showErrorNotification("Error generating thumbnail: $e");
      }
    } else {
      _status = "No file selected";
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        _status = "Idle";
        notifyListeners();
      });
    }
  }

  // Method to create  thumbnail
  Future<File> createThumbnail(File videoFile) async {
    final String videoPath = videoFile.path;
    final String thumbnailPath = '${videoPath}_thumbnail.jpg';

 
    try {
      await FFmpegKit.execute(
        '-i $videoPath -ss 00:00:01.000 -vframes 1 $thumbnailPath',
      );
    } catch (e) {
      throw "Error creating thumbnail: $e";
    }

    return File(thumbnailPath); 
  }

  // Method to upload the thumbnail to Firebase Storage
  Future<String?> uploadThumbnail(File thumbnailFile) async {
    try {
      String fileName = basename(thumbnailFile.path);
      Reference storageRef =
          storage.ref().child('uploads/thumbnails/$fileName');
      UploadTask uploadTask = storageRef.putFile(thumbnailFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      showErrorNotification("Error uploading thumbnail: $e");
      throw "Error uploading thumbnail: $e";
    }
  }

  // Method to upload media (video) to Firebase Storage
  Future<void> uploadMedia() async {
    if (_mediaFile == null) return;
        Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      if (result == ConnectivityResult.none) {
        _status = "Network lost. Upload paused.";
        _isUploading = false;
        notifyListeners();
        showRetryNotification();
      } else {
        if (!_isUploading) {
          _status = "Resuming upload...";
          _isUploading = true;
          notifyListeners();
          await retryUpload();
        }
      }
    });

    try {
      _status = "Uploading media...";
      _isUploading = true;
      notifyListeners();
      String videoFileName = basename(_mediaFile!.path);
      Reference videoRef = storage.ref().child('uploads/videos/$videoFileName');
      UploadTask videoUploadTask = videoRef.putFile(_mediaFile!);

      videoUploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        _progress = (snapshot.bytesTransferred.toDouble() /
                snapshot.totalBytes.toDouble()) *
            100;
        notifyListeners();
      });

      TaskSnapshot videoSnapshot = await videoUploadTask.whenComplete(() {});
      String videoDownloadUrl = await videoSnapshot.ref.getDownloadURL();

      _status = "Upload successful";
      notifyListeners();
      Future.delayed(const Duration(seconds: 5), () {
        _status = "Idle";
        notifyListeners();
      });
    } catch (e) {
      _status = "Upload failed: $e";
      notifyListeners();
      showErrorNotification("Upload failed: $e");
      Future.delayed(const Duration(seconds: 3), () {
        _status = "Idle";
        notifyListeners();
      });
    }
  }
  Future<void> retryUpload() async {
    if (_mediaFile != null) {
      await uploadMedia();
    }
  }

  // Error notification
  void showErrorNotification(String message) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var androidDetails = AndroidNotificationDetails(
      'upload_channel',
      'File Uploads',
      channelDescription: 'Notifies about upload errors',
      priority: Priority.high,
      importance: Importance.max,
      color: Colors.red,
      icon: 'ic_error',
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      0,
      'Upload Error',
      message,
      platformDetails,
      payload: 'error',
    );
  }

  // Retry notification
  void showRetryNotification() {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var androidDetails = AndroidNotificationDetails(
      'upload_channel',
      'File Uploads',
      channelDescription: 'Notifies about upload failure and retry options',
      priority: Priority.high,
      importance: Importance.max,
      color: Colors.orange, // Orange color for retry notifications
      icon: 'ic_retry', // Retry icon
    );
    var platformDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      1,
      'Upload Paused',
      'Network lost. Tap to retry the upload.',
      platformDetails,
      payload: 'retry',
    );
  }
}

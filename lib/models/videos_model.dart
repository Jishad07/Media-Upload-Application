import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String name;
  final String url;
  final String status;
  final Timestamp uploadedAt;

  VideoModel({
    required this.name,
    required this.url,
    required this.status,
    required this.uploadedAt,
  });

  // Convert Firestore document to VideoModel
  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return VideoModel(
      name: data['name'],
      url: data['url'],
      status: data['status'],
      uploadedAt: data['uploadedAt'],
    );
  }

  // Convert VideoModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'status': status,
      'uploadedAt': uploadedAt,
    };
  }
}

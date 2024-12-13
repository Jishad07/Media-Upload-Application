class Media {
  final String name;
  final String url;
  final String status;

  Media({required this.name, required this.url, required this.status});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      name: json['name'],
      url: json['url'],
      status: json['status'],
    );
  }
}

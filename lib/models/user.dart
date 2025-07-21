class User {
  final String name;
  final String title;
  final String imageUrl;

  const User({required this.name, required this.title, required this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'title': title, 'imageUrl': imageUrl};
  }
}

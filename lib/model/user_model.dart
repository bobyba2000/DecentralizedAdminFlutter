class UserModel {
  String name;
  String phoneNumber;
  String? imageUrl;

  UserModel({
    required this.imageUrl,
    required this.name,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      imageUrl: json['imageUrl'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}

import 'dart:convert';

import 'package:admin/model/user_model.dart';

class ServerModel {
  final String url;
  final UserModel owner;
  String? description;
  String status;
  String? location;

  ServerModel({
    this.description,
    required this.url,
    required this.owner,
    this.location,
    required this.status,
  });

  factory ServerModel.fromJson(dynamic json) {
    return ServerModel(
      url: json['url'],
      status: json['status'],
      description: json['description'],
      location: json['location'],
      owner: UserModel.fromJson(json['owner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'status': status,
      'description': description,
      'location': location,
      'owner': owner.toJson(),
    };
  }
}

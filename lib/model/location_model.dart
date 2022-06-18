import 'dart:convert';

import 'package:admin/model/server_model.dart';

class LocationModel {
  String name;
  String? listServers;
  String status;
  String description;
  LocationModel? parent;

  LocationModel({
    required this.name,
    required this.listServers,
    required this.status,
    required this.description,
    required this.parent,
  });

  factory LocationModel.fromJson(dynamic json) {
    return LocationModel(
      name: json['name'] as String,
      listServers: json['listServer'] as String?,
      status: json['status'] as String,
      description: json['description'] as String,
      parent: json['parent'] != null
          ? LocationModel.fromJson(
              json['parent'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'listServer': listServers,
      'status': status,
      'description': description,
      'parent': parent?.toJson(),
    };
  }
}

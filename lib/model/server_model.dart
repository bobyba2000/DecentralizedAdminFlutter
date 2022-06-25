import 'package:admin/model/user_model.dart';

class ServerModel {
  static const oo = 100000;
  final String url;
  final UserModel owner;
  String? description;
  String status;
  String? location;
  int requestNumber;
  int requestDownload;
  int requestUpload;
  double responseTime;
  double responseDownloadTime;
  double responseUploadTime;
  int row;
  int unresponse;

  ServerModel({
    this.description,
    required this.url,
    required this.owner,
    this.location,
    required this.status,
    required this.requestDownload,
    required this.requestNumber,
    required this.requestUpload,
    required this.responseDownloadTime,
    required this.responseTime,
    required this.responseUploadTime,
    required this.unresponse,
    required this.row,
  });

  factory ServerModel.fromJson(dynamic json) {
    return ServerModel(
      url: json['url'],
      status: json['status'],
      description: json['description'],
      location: json['location'],
      owner: UserModel.fromJson(json['owner']),
      requestDownload: int.tryParse(json['requestDownload'].toString()) ?? 0,
      requestNumber: int.tryParse(json['requestNumber'].toString()) ?? 0,
      requestUpload: int.tryParse(json['requestUpload'].toString()) ?? 0,
      responseDownloadTime:
          double.tryParse(json['responseDownloadTime'].toString()) ?? 0,
      responseTime: double.tryParse(json['responseTime'].toString()) ?? 0,
      responseUploadTime:
          double.tryParse(json['responseUploadTime'].toString()) ?? 0,
      unresponse: int.tryParse(json['unresponse'].toString()) ?? 0,
      row: int.tryParse(json['row'].toString()) ?? oo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'status': status,
      'description': description,
      'location': location,
      'owner': owner.toJson(),
      'requestDownload': requestDownload,
      'requestNumber': requestNumber,
      'requestUpload': requestUpload,
      'responseDownloadTime': responseDownloadTime,
      'responseTime': responseTime,
      'responseUploadTime': responseUploadTime,
      'unresponse': unresponse,
      'row': row,
    };
  }
}

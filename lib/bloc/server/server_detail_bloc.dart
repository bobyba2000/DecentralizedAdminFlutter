import 'package:admin/model/location_model.dart';
import 'package:admin/model/server_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ServerDetailState extends Equatable {
  final List<String> listLocation;
  final DatabaseReference? reference;

  const ServerDetailState({
    required this.listLocation,
    required this.reference,
  });
  @override
  List<Object?> get props => [listLocation];
}

class ServerDetailBloc extends Cubit<ServerDetailState> {
  ServerDetailBloc(ServerDetailState state) : super(state);

  Future<void> loadListLocation() async {
    EasyLoading.show();
    DataSnapshot response =
        await FirebaseDatabase.instance.ref('locations').get();
    EasyLoading.dismiss();
    List<LocationModel> listModel = [];
    for (var element in response.children) {
      LocationModel locationItem = LocationModel.fromJson(element.value);
      listModel.add(locationItem);
    }
    List<String> listLocation = listModel.map((e) => e.name).toList();
    emit(ServerDetailState(
      listLocation: listLocation,
      reference: state.reference,
    ));
  }

  Future<bool> submit(ServerModel serverModel) async {
    EasyLoading.show();
    try {
      await state.reference?.update(serverModel.toJson()).then((value) {
        print('done');
      }).onError((error, stackTrace) {
        print(error);
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      return false;
    }

    return true;
  }
}

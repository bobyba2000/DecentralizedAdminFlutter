import 'package:admin/model/server_model.dart';
import 'package:admin/model/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ServerListState extends Equatable {
  final List<ServerModel>? listServer;
  final List<DatabaseReference>? listReference;
  final String? textSearch;

  const ServerListState({
    this.listServer,
    this.textSearch,
    this.listReference,
  });
  @override
  List<Object?> get props => [listServer, textSearch];
}

class ServerListBloc extends Cubit<ServerListState> {
  ServerListBloc() : super(const ServerListState());

  Future<void> loadAllServer() async {
    DataSnapshot response =
        await FirebaseDatabase.instance.ref('servers').get();
    List<ServerModel> listItem =
        response.children.map((e) => ServerModel.fromJson(e.value)).toList();
    List<DatabaseReference> listRef =
        response.children.map((e) => e.ref).toList();

    emit(ServerListState(
      listServer: listItem,
      listReference: listRef,
      textSearch: state.textSearch,
    ));
  }

  Future<List<ServerModel>> loadListFile(int pageIndex, int pageSize) async {
    List<ServerModel> listItem = [];
    if (state.listServer == null) {
      await loadAllServer();
    }
    listItem = state.listServer ?? [];
    // listItem = [
    //   ServerModel(
    //     url: '192.168.1.1',
    //     owner: UserModel(
    //       imageUrl: '',
    //       name: 'TTD',
    //       phoneNumber: '0987654321',
    //     ),
    //     status: 'Pending',
    //     location: 'TP HCM',
    //     description: 'Server Luu tru',
    //   )
    // ];

    return listItem
        .where((element) =>
            element.url.contains(state.textSearch ?? '') ||
            element.owner.name.contains(state.textSearch ?? ''))
        .toList()
        .sublist(
            pageIndex * pageSize,
            (pageIndex * pageSize + pageSize) > listItem.length
                ? listItem.length
                : pageIndex * pageSize + pageSize);
  }

  void search(String textSearch) {
    emit(ServerListState(
      listServer: state.listServer,
      textSearch: textSearch,
      listReference: state.listReference,
    ));
  }
}

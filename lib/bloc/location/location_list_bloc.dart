import 'package:admin/model/location_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LocationListState extends Equatable {
  final List<LocationModel>? listLocation;
  final List<DatabaseReference>? listReference;
  final String? textSearch;

  const LocationListState({
    this.listLocation,
    this.listReference,
    this.textSearch,
  });
  @override
  List<Object?> get props => [listLocation, listReference, textSearch];
}

class LocationListBloc extends Cubit<LocationListState> {
  LocationListBloc() : super(const LocationListState());

  Future<void> loadAllLocation() async {
    try {
      DataSnapshot response =
          await FirebaseDatabase.instance.ref('locations').get();
      List<LocationModel> listItem = response.children
          .map((e) => LocationModel.fromJson(e.value))
          .toList();
      List<DatabaseReference> listRef =
          response.children.map((e) => e.ref).toList();
      emit(
        LocationListState(
          listLocation: listItem,
          listReference: listRef,
          textSearch: state.textSearch,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<LocationModel>> loadListLocation(
      int pageIndex, int pageSize) async {
    List<LocationModel> listItem = [];
    if (state.listLocation == null || pageIndex == 0) {
      await loadAllLocation();
    }
    listItem = state.listLocation ?? [];

    return listItem
        .where((element) => element.name.contains(state.textSearch ?? ''))
        .toList()
        .sublist(
            pageIndex * pageSize,
            (pageIndex * pageSize + pageSize) > listItem.length
                ? listItem.length
                : pageIndex * pageSize + pageSize);
  }

  void search(String textSearch) {
    emit(LocationListState(
      listLocation: state.listLocation,
      textSearch: textSearch,
      listReference: state.listReference,
    ));
  }
}

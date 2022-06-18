import 'package:admin/bloc/location/location_list_bloc.dart';
import 'package:admin/common_widgets/load_more_widget.dart';
import 'package:admin/common_widgets/search_widget.dart';
import 'package:admin/model/location_model.dart';
import 'package:admin/page/location/location_detail_page.dart';
import 'package:admin/page/servers/servers_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class LocationListPage extends StatefulWidget {
  const LocationListPage({
    Key? key,
  }) : super(key: key);

  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  late PagewiseLoadController<LocationModel> _locationController;
  late LocationListBloc _bloc;

  @override
  void initState() {
    _bloc = LocationListBloc();
    _locationController = PagewiseLoadController(
      pageFuture: (pageIndex) => _bloc.loadListLocation(pageIndex ?? 0, 6),
      pageSize: 6,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text(
                  'Add Location',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: LocationDetailPage(
                  location: null,
                  reference: null,
                ),
              );
            },
          );
          await _bloc.loadAllLocation();
          _locationController.reset();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocBuilder<LocationListBloc, LocationListState>(
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'LOCATIONS',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SearchWidget(
                      hintTextSearch: 'Search by username or by url',
                      onSearch: (value) {
                        _bloc.search(value ?? '');
                        _locationController.reset();
                      },
                      flex: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                Flexible(
                  child: LoadMoreWidget<LocationModel>.buildGrid(
                    pullToRefresh: () => _locationController.reset(),
                    pageLoadController: _locationController,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 40,
                    childAspectRatio: 3.5,
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, value, index) {
                      return InkWell(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Update Location',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: LocationDetailPage(
                                  location: value,
                                  reference: state.listReference![index],
                                ),
                              );
                            },
                          );
                          await _bloc.loadAllLocation();
                          _locationController.reset();
                        },
                        child: LocationItemWidget(location: value),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class LocationItemWidget extends StatelessWidget {
  final LocationModel location;
  const LocationItemWidget({Key? key, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: const Offset(5, 5), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(
              Icons.lan,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        location.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location.parent?.name ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                StatusBar(status: location.status),
                const SizedBox(height: 8),
                Text(
                  location.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

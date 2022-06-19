import 'package:admin/bloc/server/server_list_bloc.dart';
import 'package:admin/common_widgets/load_more_widget.dart';
import 'package:admin/common_widgets/network_image_widget.dart';
import 'package:admin/common_widgets/search_widget.dart';
import 'package:admin/model/server_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

class ServersListPage extends StatefulWidget {
  final Function(ServerModel, DatabaseReference?) onSelectServer;
  const ServersListPage({
    Key? key,
    required this.onSelectServer,
  }) : super(key: key);

  @override
  _ServersListPageState createState() => _ServersListPageState();
}

class _ServersListPageState extends State<ServersListPage> {
  late PagewiseLoadController<ServerModel> _serverController;
  late ServerListBloc _bloc;

  @override
  void initState() {
    _bloc = ServerListBloc();
    _serverController = PagewiseLoadController(
      pageFuture: (pageIndex) => _bloc.loadListFile(pageIndex ?? 0, 6),
      pageSize: 6,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ServerListBloc>(
        create: (context) => _bloc,
        child: BlocBuilder<ServerListBloc, ServerListState>(
            builder: (context, state) {
          return Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'SERVERS',
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
                      _serverController.reset();
                    },
                    flex: 1,
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Flexible(
                child: LoadMoreWidget<ServerModel>.buildGrid(
                  pullToRefresh: () => _serverController.reset(),
                  pageLoadController: _serverController,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 40,
                  childAspectRatio: 2.7,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (context, value, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                          onTap: () {
                            widget.onSelectServer(
                                value, state.listReference?[index]);
                          },
                          child: ServerItemWidget(server: value)),
                    );
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

class ServerItemWidget extends StatelessWidget {
  final ServerModel server;
  const ServerItemWidget({
    Key? key,
    required this.server,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 7,
                  offset: const Offset(3, 5), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
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
                    Icons.warehouse,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              server.url,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            server.location ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      StatusBar(status: server.status),
                      const SizedBox(height: 8),
                      Text(
                        server.description ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey,
          height: 4,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                offset: const Offset(3, 5), // changes position of shadow
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              NetworkImageWidget(
                url: server.owner.imageUrl ?? '',
                width: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      server.owner.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      server.owner.phoneNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class StatusBar extends StatelessWidget {
  final String status;
  const StatusBar({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.yellowAccent;
        break;
      default:
    }
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

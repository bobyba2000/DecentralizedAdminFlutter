import 'package:admin/common_widgets/base_button.dart';
import 'package:admin/common_widgets/dropdown_multi_select_widget.dart';
import 'package:admin/common_widgets/dropdown_widget.dart';
import 'package:admin/common_widgets/text_field_widget.dart';
import 'package:admin/model/location_model.dart';
import 'package:admin/model/server_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LocationDetailPage extends StatefulWidget {
  final LocationModel? location;
  final DatabaseReference? reference;
  const LocationDetailPage({
    Key? key,
    required this.location,
    required this.reference,
  }) : super(key: key);

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late LocationModel _location;
  List<String> lisServers = [];
  List<DatabaseReference> listRef = [];
  List<DatabaseReference> listSelected = [];
  List<LocationModel> listLocation = [];

  @override
  void initState() {
    _location = widget.location ??
        LocationModel(
          name: '',
          listServers: null,
          status: '',
          description: '',
          parent: null,
        );
    _nameController.text = _location.name;
    _descriptionController.text = _location.description;
    loadListServer();
    loadListLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldWidget(
            controller: _nameController,
            label: 'Name',
            readOnly: widget.location != null,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: DropDownWidget(
                  label: 'Status',
                  items: const [
                    'Active',
                    'Pending',
                    'Inactive',
                  ],
                  initialValue: _location.status,
                  onSelect: (value) {
                    _location.status = value ?? 'Inactive';
                  },
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: DropDownWidget(
                  label: 'Parent Location',
                  items: listLocation.map((e) => e.name).toList(),
                  initialValue: _location.parent?.name,
                  onSelect: (value) {
                    _location.parent = listLocation
                        .firstWhere((element) => element.name == value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          DropdownMultiSelectWidget(
            options: lisServers,
            selectedValues: _location.listServers?.split(',') ?? [],
            label: 'List Servers',
            onSelect: (values) {
              print(values);
              _location.listServers = values.join(',');
            },
            maxValue: 4,
          ),
          TextFieldWidget(
            controller: _descriptionController,
            label: 'Description',
            maxLines: 3,
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BaseButton(
                label: 'Cancel',
                color: Colors.transparent,
                border: Border.all(
                  color: const Color.fromARGB(255, 41, 41, 41),
                ),
                onClick: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 24),
              BaseButton(
                label: 'Save',
                onClick: () async {
                  if (widget.location == null) {
                    _location.description = _descriptionController.text;
                    _location.name = _nameController.text;
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref('locations');
                    await ref.push().set(_location.toJson());
                    Navigator.pop(context);
                  } else {
                    await widget.reference?.update(_location.toJson());
                    for (var ref in listRef) {
                      ref.update(
                        {
                          'location': null,
                        },
                      );
                    }
                    if (_location.listServers != null) {
                      for (var i = 0; i < lisServers.length; i++) {
                        if (_location.listServers!.contains(lisServers[i])) {
                          await listRef[i].update({'location': _location.name});
                        }
                      }
                    }

                    Navigator.pop(context);
                  }
                },
                color: Colors.blue[900],
                textColor: Colors.white,
              )
            ],
          )
        ],
      ),
    );
  }

  void loadListServer() async {
    DataSnapshot response =
        await FirebaseDatabase.instance.ref('servers').get();
    List<ServerModel> listItem =
        response.children.map((e) => ServerModel.fromJson(e.value)).toList();
    setState(() {
      for (var i = 0; i < listItem.length; i++) {
        if ((listItem[i].location == null ||
                listItem[i].location == '' ||
                listItem[i].location == widget.location?.name) &&
            listItem[i].status == 'Active') {
          lisServers.add(listItem[i].url);
          listRef.add(response.children.elementAt(i).ref);
        }
      }
    });
  }

  void loadListLocation() async {
    DataSnapshot response =
        await FirebaseDatabase.instance.ref('locations').get();
    List<LocationModel> listItem =
        response.children.map((e) => LocationModel.fromJson(e.value)).toList();
    setState(() {
      listLocation = listItem;
    });
  }
}

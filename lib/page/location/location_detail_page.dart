import 'package:admin/common_widgets/base_button.dart';
import 'package:admin/common_widgets/dropdown_multi_select_widget.dart';
import 'package:admin/common_widgets/dropdown_widget.dart';
import 'package:admin/common_widgets/text_field_widget.dart';
import 'package:admin/model/location_model.dart';
import 'package:admin/model/server_model.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:dio/dio.dart';
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
  final TextEditingController _numberController = TextEditingController();
  late LocationModel _location;
  List<String> lisServers = [];
  List<DatabaseReference> listRef = [];
  List<DatabaseReference> listSelected = [];
  List<LocationModel> listLocation = [];
  List<ServerModel> listServerModel = [];
  List<String> listDownloadLink = [
    'https://drive.google.com/file/d/1AwtXE_ghNA_D-8EyH-6I_cDIF2ITocqa/view?usp=sharing',
    'https://drive.google.com/file/d/1S6QVJu0AwVjnLnCz_N5vtxwvFO7dvlQq/view?usp=sharing',
    'https://drive.google.com/file/d/1YIFU9OwaYIX7xuguq6tzPp24z8WQGC_z/view?usp=sharing',
    'https://drive.google.com/file/d/1wrnAf53IBs2P3g1r3Bc6xEPad9S88P9f/view?usp=sharing',
  ];
  List<String> listCurlCmd = [
    'curl -L "https://www.googleapis.com/drive/v3/files/1AwtXE_ghNA_D-8EyH-6I_cDIF2ITocqa?alt=media&key=AIzaSyBweJa2UVBTe3fAWA_DyFSsrMPiO_X-g2c" > install.sh',
    'curl -L "https://www.googleapis.com/drive/v3/files/1S6QVJu0AwVjnLnCz_N5vtxwvFO7dvlQq?alt=media&key=AIzaSyBweJa2UVBTe3fAWA_DyFSsrMPiO_X-g2c" > install.sh',
    'curl -L "https://www.googleapis.com/drive/v3/files/1YIFU9OwaYIX7xuguq6tzPp24z8WQGC_z?alt=media&key=AIzaSyBweJa2UVBTe3fAWA_DyFSsrMPiO_X-g2c" > install.sh',
    'curl -L "https://www.googleapis.com/drive/v3/files/1wrnAf53IBs2P3g1r3Bc6xEPad9S88P9f?alt=media&key=AIzaSyBweJa2UVBTe3fAWA_DyFSsrMPiO_X-g2c" > install.sh',
  ];

  @override
  void initState() {
    _location = widget.location ??
        LocationModel(
          name: '',
          listServers: null,
          status: '',
          description: '',
          parent: null,
          numberOfUser: 0,
        );
    _nameController.text = _location.name;
    _descriptionController.text = _location.description;
    _numberController.text = _location.numberOfUser.toString();
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
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  controller: _nameController,
                  label: 'Name',
                  readOnly: widget.location != null,
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
                child: TextFieldWidget(
                  controller: _numberController,
                  label: 'Number of Client Users',
                  readOnly: true,
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
              setState(() {
                _location.listServers = values.join(',');
              });
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
                  if (widget.location?.status != 'Active' &&
                      _location.status == 'Active') {
                    ToastUtils.showToast(
                      msg: "Your servers haven't been activated.",
                      isError: true,
                    );
                    return;
                  }
                  if ((_location.status == 'Active' ||
                          _location.status == 'Pending') &&
                      (_location.listServers?.split(',') ?? []).length < 3) {
                    ToastUtils.showToast(
                        msg: 'Please add more servers.', isError: true);
                    return;
                  }
                  DatabaseReference ref =
                      FirebaseDatabase.instance.ref('locations');

                  _location.description = _descriptionController.text;
                  _location.name = _nameController.text;
                  if (widget.reference == null) {
                    await ref.push().set(_location.toJson());
                  } else {
                    await widget.reference?.update(_location.toJson());
                  }
                  if (_location.listServers != null) {
                    setStatusServerAndSendMail();
                  }
                  Navigator.pop(context);
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

  void setStatusServerAndSendMail() async {
    List<ServerModel?> listServerSelected = [];
    for (var i = 0; i < 4; i++) {
      listServerSelected.add(null);
    }

    for (var i = 0; i < lisServers.length; i++) {
      if (_location.listServers!.contains(lisServers[i])) {
        if (listServerModel[i].row != ServerModel.oo) {
          listServerSelected[listServerModel[i].row] = listServerModel[i];
        }
      } else {
        await listRef[i].update(
          {
            'location': '',
            'status': 'Inactive',
            'row': ServerModel.oo,
          },
        );
      }
    }

    int count = 0;
    for (var i = 0; i < lisServers.length; i++) {
      if (_location.listServers!.contains(lisServers[i])) {
        if (listServerModel[i].row == ServerModel.oo) {
          while (count < listServerSelected.length &&
              listServerSelected[count] != null) {
            count++;
          }
          if (count >= listServerSelected.length) break;
          listServerSelected[count] = listServerModel[i]..row = count;
          await listRef[i].update({
            'location': _location.name,
            'status': 'Pending',
            'row': count,
          });
          sendEmail(count, i);
          count++;
        }
      }
    }
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
            listItem[i].location == widget.location?.name)) {
          lisServers.add(listItem[i].url);
          listRef.add(response.children.elementAt(i).ref);
          listServerModel.add(listItem[i]);
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

  void sendEmail(int count, int i) async {
    const serviceId = 'service_td23oi6';
    const templateId = 'template_rb47lh8';
    const userId = 'HS1a6jzGLd48mVux-';
    var dio = Dio();
    try {
      final response =
          await dio.post('https://api.emailjs.com/api/v1.0/email/send', data: {
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_subject': 'Install Server',
          'to_name': listServerModel[i].owner.name,
          'from_name': 'Decentralized Server',
          'to_email': listServerModel[i].owner.email,
          'link_download': listDownloadLink[count],
          'curl_cmd': listCurlCmd[count],
          // 'message':
          //     'Make sure your server open port 9080\n Install file install.sh from ${listDownloadLink[count]}. \n Run command "bash install.sh", select yes if needed.'
        }
      });
    } catch (e) {
      print(e);
    }
  }
}

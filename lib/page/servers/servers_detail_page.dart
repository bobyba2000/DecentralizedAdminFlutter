import 'package:admin/bloc/server/server_detail_bloc.dart';
import 'package:admin/common_widgets/base_button.dart';
import 'package:admin/common_widgets/chart_widget.dart';
import 'package:admin/common_widgets/dropdown_widget.dart';
import 'package:admin/common_widgets/network_image_widget.dart';
import 'package:admin/common_widgets/text_field_widget.dart';
import 'package:admin/model/server_model.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServersDetailPage extends StatefulWidget {
  final ServerModel server;
  final DatabaseReference reference;
  final void Function() onTapBack;
  const ServersDetailPage({
    Key? key,
    required this.server,
    required this.onTapBack,
    required this.reference,
  }) : super(key: key);

  @override
  _ServersDetailPageState createState() => _ServersDetailPageState();
}

class _ServersDetailPageState extends State<ServersDetailPage> {
  final TextEditingController _urlController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _ownerController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _requestController = TextEditingController();
  // final TextEditingController _requestUploadController =
  //     TextEditingController();
  // final TextEditingController _requestDownloadController =
  //     TextEditingController();
  // final TextEditingController _responseUploadController =
  //     TextEditingController();
  // final TextEditingController _responseDownloadController =
  //     TextEditingController();
  // final TextEditingController _responseController = TextEditingController();
  // final TextEditingController _unresponse = TextEditingController();
  // final TextEditingController _requestInfoController = TextEditingController();
  late ServerDetailBloc _bloc;

  late ServerModel _serverModel;

  @override
  void initState() {
    _urlController.text = widget.server.url;
    _descriptionController.text = widget.server.description ?? '';
    _ownerController.text = widget.server.owner.name;
    _phoneController.text = widget.server.owner.phoneNumber;
    _emailController.text = widget.server.owner.email;
    // _requestController.text = widget.server.requestNumber.toString();
    // _requestDownloadController.text = widget.server.requestDownload.toString();
    // _requestUploadController.text = widget.server.requestUpload.toString();
    // _responseController.text = widget.server.responseTime.toString();
    // _responseDownloadController.text =
    //     widget.server.responseDownloadTime.toString();
    // _responseUploadController.text =
    //     widget.server.responseUploadTime.toString();
    // _unresponse.text = widget.server.unresponse.toString();

    // _requestInfoController.text =
    //     'This server have received ${widget.server.requestNumber + widget.server.unresponse} requests. Of these, there are ${widget.server.unresponse} requests that are not answered and ${widget.server.requestNumber} requests that have responses with a response time of ${widget.server.responseTime}ms. There are a total of ${widget.server.requestUpload} upload requests with ${widget.server.responseUploadTime}ms response time and ${widget.server.requestDownload} download requests with ${widget.server.responseDownloadTime}ms response time.';

    _bloc = ServerDetailBloc(
      ServerDetailState(
        listLocation: const [],
        reference: widget.reference,
      ),
    );
    _serverModel = widget.server;
    super.initState();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServerDetailBloc>(
      create: (context) => _bloc..loadListLocation(),
      child: BlocBuilder<ServerDetailBloc, ServerDetailState>(
          builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: widget.onTapBack,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Server Detail',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                BaseButton(
                  label: 'Cancel',
                  color: Colors.transparent,
                  border: Border.all(
                    color: const Color.fromARGB(255, 41, 41, 41),
                  ),
                  onClick: widget.onTapBack,
                ),
                const SizedBox(width: 24),
                BaseButton(
                  label: 'Save',
                  onClick: () async {
                    _serverModel.description = _descriptionController.text;
                    bool isSuccess = await _bloc.submit(_serverModel);
                    if (isSuccess) {
                      widget.onTapBack();
                    } else {
                      ToastUtils.showToast(
                        msg: 'Update Failed',
                        isError: true,
                      );
                    }
                  },
                  color: Colors.blue[900],
                  textColor: Colors.white,
                )
              ],
            ),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 7,
                                offset: const Offset(3, 5),
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'SERVER INFO',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFieldWidget(
                                controller: _urlController,
                                label: 'Url',
                                readOnly: true,
                                maxLines: 1,
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
                                      initialValue: widget.server.status,
                                      onSelect: (value) {
                                        _serverModel.status =
                                            value ?? 'Inactive';
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    child: DropDownWidget(
                                      items: state.listLocation,
                                      label: 'Location',
                                      readOnly: true,
                                      onSelect: (value) {
                                        _serverModel.location = value;
                                      },
                                      initialValue: widget.server.location,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              TextFieldWidget(
                                controller: _descriptionController,
                                label: 'Description',
                                maxLines: 3,
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 7,
                                offset: const Offset(3, 5),
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'SERVER REQUEST INFO',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'This server have received ${widget.server.requestNumber + widget.server.unresponse} requests. Of these, there are ${widget.server.unresponse} requests that are not answered and ${widget.server.requestNumber} requests that have responses with a response time of ${widget.server.responseTime}ms. There are a total of ${widget.server.requestUpload} upload requests with ${widget.server.responseUploadTime}ms response time and ${widget.server.requestDownload} download requests with ${widget.server.responseDownloadTime}ms response time.',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 7,
                          offset: const Offset(3, 5),
                        ),
                      ],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OWNER INFO',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: NetworkImageWidget(
                              url: widget.server.owner.imageUrl,
                              width: 150,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          controller: _emailController,
                          label: 'Email',
                          readOnly: true,
                        ),
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          controller: _ownerController,
                          label: 'Name',
                          readOnly: true,
                        ),
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          controller: _phoneController,
                          label: 'Phone Number',
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class DropdownMultiSelectWidget extends StatefulWidget {
  final List<String> options;
  final List<String> selectedValues;
  final String label;
  final String? hintText;
  final Function(List<String>) onSelect;
  final int maxValue;
  const DropdownMultiSelectWidget({
    Key? key,
    required this.options,
    required this.selectedValues,
    this.hintText,
    required this.label,
    required this.onSelect,
    required this.maxValue,
  }) : super(key: key);

  @override
  _DropdownMultiSelectWidgetState createState() =>
      _DropdownMultiSelectWidgetState();
}

class _DropdownMultiSelectWidgetState extends State<DropdownMultiSelectWidget> {
  InputBorder _inputBorder(Color color) => OutlineInputBorder(
        borderSide: BorderSide(color: color, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      );

  List<String> selectedValues = [];
  @override
  void initState() {
    selectedValues = widget.selectedValues;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DropdownMultiSelectWidget oldWidget) {
    if (oldWidget.selectedValues != widget.selectedValues) {
      setState(() {
        selectedValues = widget.selectedValues;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DropDownMultiSelect(
          onChanged: (List<String> values) {
            if (values[0].isEmpty) {
              values.removeAt(0);
            }
            if (values.length <= widget.maxValue) {
              setState(
                () {
                  selectedValues = values;
                  widget.onSelect(values);
                },
              );
            }
          },
          options: widget.options,
          whenEmpty: 'Select Url',
          selectedValues: selectedValues,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            border: _inputBorder(Colors.transparent),
            enabledBorder: _inputBorder(Colors.transparent),
            focusedBorder: _inputBorder(Colors.black),
            errorBorder: _inputBorder(Colors.red),
            focusedErrorBorder: _inputBorder(Colors.transparent),
            disabledBorder: _inputBorder(Colors.transparent),
            counterText: '',
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Color.fromRGBO(41, 35, 63, 0.5),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

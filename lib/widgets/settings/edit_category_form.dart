import 'package:flutter/material.dart';

import '../common/modal_bottom_sheet_input.dart';
import '../../models/category.dart';
import '../common/select_field.dart';
import '../../extensions.dart';

class EditCategoryForm extends StatefulWidget {
  const EditCategoryForm({required this.initialValue});

  final Category? initialValue;

  @override
  _EditCategoryFormState createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
  var _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};
  var _loading = false;

  void _onSave() {
    setState(() {
      _loading = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _loading = false;
        return;
      });
    }

    _formKey.currentState!.save();

    _loading = false;
    Navigator.of(context).pop(_formData);
  }

  void _saveField(String fieldName, String value) {
    _formData[fieldName] = value;

    // Keyboard appears when editing select or datepicker
    if (fieldName == 'categoryType') {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue == null) return;

    // Set values from the edited category
    _formData['name'] = widget.initialValue!.name;
    _formData['categoryType'] =
        widget.initialValue!.categoryType.valueAsString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ModalBottomSheetInput(
                labelText: 'Name',
                initialValue: widget.initialValue?.name ?? null,
                onSaved: (v) => _saveField('name', v!),
                type: 'text',
              ),
              const SizedBox(height: 15),
              SelectField(
                items: Map.fromEntries(CategoryType.values.map(
                    (e) => MapEntry(e.valueAsString(), e.valueAsString()))),
                onChanged: (val) => _saveField('categoryType', val),
                initialValue:
                    widget.initialValue?.categoryType.valueAsString() ??
                        CategoryType.Incomes.valueAsString(),
              ),
              const SizedBox(height: 15),
              Container(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _onSave,
                  icon: const Icon(Icons.check),
                  label: const Text('Save'),
                ),
              ),
              const SizedBox(height: 5),
              if (widget.initialValue != null)
                Container(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _loading
                        ? null
                        : () =>
                            Navigator.of(context).pop(Map<String, dynamic>()),
                    icon: const Icon(Icons.delete_rounded),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).errorColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

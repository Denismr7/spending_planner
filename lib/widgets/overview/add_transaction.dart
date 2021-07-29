import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/transactions.dart';
import '../common/datepicker_field.dart';
import '../common/modal_bottom_sheet_input.dart';
import '../common/select_field.dart';
import '../../models/category.dart';
import '../../providers/user.dart';
import '../../models/user.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction();

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _mappedCategories = {};
  var _loading = false;
  Map<String, dynamic> _formData = {};

  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories = Category.parseJsonCategories(
        Provider.of<UserProvider>(context, listen: false)
            .getSettingValueAsString(Setting.Categories));
    _createMapFromCategories(_categories);
  }

  void _createMapFromCategories(List<Category> categories) {
    Map<String, String> map = {};
    categories.forEach((element) {
      map[element.name] = element.id;
    });
    _mappedCategories = map;
  }

  void _saveField(String fieldName, dynamic value) {
    _formData[fieldName] = value;

    // Save category type
    if (fieldName == 'Category') {
      _formData['CategoryType'] =
          _categories.firstWhere((element) => element.id == value).categoryType;
    }

    // Keyboard appears when editing select or datepicker
    if (fieldName == 'Category' || fieldName == 'Date') {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  Future<void> _saveTransaction() async {
    setState(() {
      _loading = true;
    });
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    if (_formData['Date'] == null) return;

    final user = FirebaseAuth.instance;

    try {
      final transaction = await TransactionsHelper.addTransaction(
        double.parse(_formData['Amount']),
        user.currentUser!.uid,
        _formData['Category'],
        _formData['CategoryType'],
        _formData['Date'],
        _formData['Description'],
      );

      Provider.of<UserProvider>(context, listen: false)
          .updateBudgetLimit(transaction, true);
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop(transaction);
    } catch (e) {
      print('SPLAN.AddTansactionWidget() Error: ' + e.toString());
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom / 2,
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ModalBottomSheetInput(
                labelText: 'Description',
                onSaved: (val) => _saveField('Description', val),
                type: 'text',
              ),
              const SizedBox(height: 15),
              ModalBottomSheetInput(
                labelText: 'Amount',
                onSaved: (val) => _saveField('Amount', val),
                type: 'number',
              ),
              const SizedBox(height: 15),
              SelectField(
                items: _mappedCategories,
                onChanged: (val) => _saveField('Category', val),
                initialValue: _mappedCategories.values.first,
              ),
              const SizedBox(height: 15),
              DatepickerField(
                labelText: 'Select a date',
                onSelectedDate: (val) => _saveField('Date', val),
              ),
              const SizedBox(height: 15),
              Container(
                height: 40,
                width: 170,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _saveTransaction,
                  icon: const Icon(Icons.check),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

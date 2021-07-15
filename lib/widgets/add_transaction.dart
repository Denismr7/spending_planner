import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spending_planner/helpers/transactions.dart';
import 'package:spending_planner/models/transaction.dart';
import 'package:spending_planner/widgets/datepicker_field.dart';

import 'add_transaction_input.dart';
import 'select_field.dart';
import '../models/category.dart';
// TODO: Use real data
import '../mock.dart';

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
    _categories = categoriesMock;
    _createMapFromCategories(_categories);
  }

  void _createMapFromCategories(List<Category> categories) {
    Map<String, String> map = {};
    categories.forEach((element) {
      map[element.name] = element.id;
    });
    _mappedCategories = map;
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field required';
    }
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
      // FocusScope.of(context).requestFocus(FocusNode());
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
    final transaction = await TransactionsHelper.addTransaction(
      double.parse(_formData['Amount']),
      user.currentUser!.uid,
      _formData['Category'],
      _formData['CategoryType'],
      _formData['Date'],
      _formData['Description'],
    );

    setState(() {
      _loading = false;
    });
    Navigator.of(context).pop(transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 0.4,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AddTransactionInput(
                labelText: 'Description',
                validator: _validateField,
                onSaved: (val) => _saveField('Description', val),
                type: 'text',
              ),
              const SizedBox(height: 15),
              AddTransactionInput(
                labelText: 'Amount',
                validator: _validateField,
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
                        Radius.circular(10),
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

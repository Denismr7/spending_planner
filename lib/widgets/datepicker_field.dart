import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatepickerField extends StatefulWidget {
  // TODO: Add validation (at least to avoid empty values)
  const DatepickerField({
    Key? key,
    required this.labelText,
    required this.onSelectedDate,
  }) : super(key: key);

  final String labelText;
  final Function(DateTime pickedDate) onSelectedDate;

  @override
  _DatepickerFieldState createState() => _DatepickerFieldState();
}

class _DatepickerFieldState extends State<DatepickerField> {
  String? _selectedDate;

  Future<void> _showDatePicker(BuildContext context) async {
    var today = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2018),
      lastDate: today,
    );
    if (pickedDate == null) return;
    var formattedDate = DateFormat.yMMMd().format(pickedDate);
    if (formattedDate == _selectedDate) return;
    setState(() {
      _selectedDate = DateFormat.yMMMd().format(pickedDate);
    });
    widget.onSelectedDate(pickedDate);
  }

  @override
  void initState() {
    super.initState();
    if (_selectedDate != null) {
      DateFormat format = DateFormat.yMMMd();
      widget.onSelectedDate(format.parse(_selectedDate!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDatePicker(context),
      child: Container(
        height: 55,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null ? widget.labelText : _selectedDate!,
              style: TextStyle(
                color: _selectedDate == null ? Colors.black54 : Colors.black87,
                fontSize: 16,
              ),
            ),
            Icon(Icons.date_range_rounded),
          ],
        ),
      ),
    );
  }
}

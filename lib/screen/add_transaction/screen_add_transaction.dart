import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

class ScreenaddTransaction extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenaddTransaction({super.key});

  @override
  State<ScreenaddTransaction> createState() => _ScreenaddTransactionState();
}

class _ScreenaddTransactionState extends State<ScreenaddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;
  String? _categoryID;

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(hintText: 'Purpose'),
              keyboardType: TextInputType.text,
            ),
            const TextField(
              decoration: InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextButton.icon(
              onPressed: () async {
                final _selectedDatetemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now(),
                );
                if (_selectedDatetemp == null) {
                  return;
                } else {
                  setState(() {
                    _selectedDate = _selectedDatetemp;
                  });
                }
              },
              icon: Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : _selectedDate
                        .toString(), //this is ternary operator for displaying 'select date' or selected date on button text //
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategorytype,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategorytype = CategoryType.income;
                          _categoryID = null;
                        });
                      },
                    ),
                    Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedCategorytype,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategorytype = CategoryType.expense;
                          _categoryID = null;
                        });
                      },
                    ),
                    Text('Expense'),
                  ],
                ),
              ],
            ),
            DropdownButton<String>(
              hint: Text('Select Category'),
              value: _categoryID,
              items: (_selectedCategorytype == CategoryType.income
                      ? CategoryDB().incomeCategoryListNotifier
                      : CategoryDB().expenseCategoryListNotifier)
                  .value
                  .map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                );
              }).toList(),
              onChanged:
                  (selectedValue) //value: e.id is being passed to selectedValue
                  {
                setState(() {
                  _categoryID = selectedValue;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Submit'),
            )
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/category/transactions/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/transaction/transaction_model.dart';

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
  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

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
            TextField(
              controller: _purposeTextEditingController,
              decoration: InputDecoration(hintText: 'Purpose'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _amountTextEditingController,
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
                  onTap: () {
                    _selectedCategoryModel = e;
                  },
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
              onPressed: () {
                addTransaction();
              },
              child: Text('Submit'),
            )
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    // if (_categoryID == null) {
    //   return;
    // }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategorytype!,
      category: _selectedCategoryModel!,
    );
    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}

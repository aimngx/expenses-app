import 'dart:io';

import 'package:expenses_app/adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//creating new transaction

//widget class
class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction({super.key, required this.addTx});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

//state class. So we use widget.xxx to access the widget class punya method etc
class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime?
      _selectedDate; //put ? so that initially, it is null, but later is changed. When we called it down later, we put _selectedDate! with '!' to tell change it from nullable to non-nullable

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount =
        double.parse(_amountController.text); //change back the string to double

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return; //break the code
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    //automatically close the top most screen (ie the modal screen) once we're done
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    //the .then allow us to provide a function which is executed once the future resolved to a value (after user chose a date)
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        //to consider for keyboard, adjust the padding at the bottom,
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          //set main axis size to min so that the modal sheet tak take up the whole page
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              //onChanged is fired on every keystroke
              // onChanged: (value) => titleInput = value,
              controller: _titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              //onChanged: (value) => amountInput = value,
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) =>
                  _submitData(), //because on submitted required String as argument, so we use _ to tell that we dont care about it
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                    ),
                  ),
                  AdaptiveFlatButton(
                      text: 'Choose Date', handler: _presentDatePicker)
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // print(titleInput);
                // print(amountInput);
                _submitData();
              },
              child: Text('Add Transaction'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

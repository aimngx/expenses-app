import 'package:flutter/material.dart';

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
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount =
        double.parse(amountController.text); //change back the string to double

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return; //break the code
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
    );

    //automatically close the top most screen (ie the modal screen) once we're done
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              //onChanged is fired on every keystroke
              // onChanged: (value) => titleInput = value,
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              //onChanged: (value) => amountInput = value,
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) =>
                  submitData(), //because on submitted required String as argument, so we use _ to tell that we dont care about it
            ),
            TextButton(
              onPressed: () {
                // print(titleInput);
                // print(amountInput);
                submitData();
              },
              child: Text('Add Transaction'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  Colors.purple,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

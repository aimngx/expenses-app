import 'package:expenses_app/models/transaction.dart';
import 'package:expenses_app/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(
      {super.key, required this.transactions, required this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (BuildContext, BoxConstraints) {
              return Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 24),
                  Container(
                    height: BoxConstraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTx: deleteTx,
                    ))
                .toList());
    // return Card(
    //   child: Row(
    //     children: [
    //       Container(
    //         margin: EdgeInsets.symmetric(
    //           vertical: 10,
    //           horizontal: 15,
    //         ),
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             color: Theme.of(context).primaryColor,
    //             width: 2,
    //           ),
    //         ),
    //         padding: EdgeInsets.all(10),
    //         child: Text(
    //           '\$ ${transactions[index].amount.toStringAsFixed(2)}', //accessing the transaction at the current index and get the amount
    //           //'\$ ' + tx.amount.toString(),
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //         ), // use toString as text widget is expecting a string as their arguments
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             transactions[index].title,
    //             style: Theme.of(context).textTheme.headline6,
    //           ),
    //           Text(
    //             DateFormat('dd MMM yyyy')
    //                 .format(transactions[index].date),
    //             style: TextStyle(color: Colors.grey),
    //           )
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}

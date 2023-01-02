import 'dart:io'; //to know the platform we're using

import 'package:expenses_app/chart.dart';
import 'package:expenses_app/new_transaction.dart';
import 'package:expenses_app/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

class HomePage extends StatefulWidget {
  //create a list based on the transaction model we have

  // String titleInput = '';
  // String amountInput = '';

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransaction = [];

  //show chart
  bool _showChart = false;

  //for recent transactions
  List<Transaction> get _recentTransactions {
    return _userTransaction.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }
  //where method returns iterable but we want list, so sama jugak mcm cara map, we use .toList()

  //create method
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  //delete the item using the unique identifier which is the id
  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  //the value of context (ctx) is accepted as arguments
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior
                .opaque, //to avoid clossing the model sheet when tapping it
            child: NewTransaction(
              addTx: _addNewTransaction,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //save the media query into the variable for better efficiency and performance (ie avoid re render the object)
    final mediaQuery = MediaQuery.of(context);
    //get the orientation so that can decide what to display in what orientation mode
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    //store the appBar in a variable so that we can have access to its size
    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: CupertinoButton(
              onPressed: () => _startAddNewTransaction(context),
              child: Icon(CupertinoIcons.add),
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add),
              )
            ],
          );

    //create var for transaction list widget so that it is easier to use/copy for if else statement
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
        transactions: _userTransaction,
        deleteTx: _deleteTransaction,
      ),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //new way to type if statement, without using {}, syntax allowed only for if statement inside of a list (ie list of widgets/children)
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // use .adaptive to adapt to ios, but not all widget can use .adaptive
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      }),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(
                  recentTransactions: _recentTransactions,
                ),
              ),
            if (!isLandscape) txListWidget,

            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(
                        recentTransactions: _recentTransactions,
                      ),
                    )
                  : txListWidget
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

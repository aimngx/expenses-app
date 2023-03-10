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

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//mix in other class
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransaction = [];

  //show chart
  bool _showChart = false;

  //to observe the lifecycle state (START)
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  //to observe the lifecycle state (END)

  //for recent transactions
  List<Transaction> get _recentTransactions {
    return _userTransaction.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
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

  //builder method to cater to screen orientation
  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
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
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(
          recentTransactions: _recentTransactions,
        ),
      ),
      txListWidget,
    ];
  }

  //for app bar
  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: CupertinoButton(
              onPressed: () => _startAddNewTransaction(context),
              child: const Icon(CupertinoIcons.add),
            ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: const Icon(Icons.add),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    //save the media query into the variable for better efficiency and performance (ie avoid re render the object)
    final mediaQuery = MediaQuery.of(context);

    //get the orientation so that can decide what to display in what orientation mode
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    //store the appBar in a variable so that we can have access to its size
    final dynamic appBar = _buildAppBar();

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
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              // use spread operator ... to spread/pull the list of widget one by one to the surrounding list(ie Column)
              ..._buildPotraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

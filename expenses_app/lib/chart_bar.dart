import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentageTotal;

  //connstructor
  const ChartBar(
      {super.key,
      required this.label,
      required this.spendingAmount,
      required this.spendingPercentageTotal});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // use fittedbox to force the text to shrink
        Container(
          height: 20,
          child: FittedBox(
            child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 60,
          width: 10,
          child: Stack(
            children: [
              //the children is arranged from the bottom layer to the top layer
              //bottom layer ie the main container
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // the layered container
              FractionallySizedBox(
                heightFactor: spendingPercentageTotal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 4),
        Text(label), //which holds the week day
      ],
    );
  }
}

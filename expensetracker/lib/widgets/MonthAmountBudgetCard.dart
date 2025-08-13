import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MonthAmountBudgetCard extends StatefulWidget {
  MonthAmountBudgetCard({required this.date, required this.amount});
  DateTime date;
  double amount;

  @override
  State<MonthAmountBudgetCard> createState() => _MonthAmountCardState();
}

class _MonthAmountCardState extends State<MonthAmountBudgetCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Text(formatToMonthYear(widget.date),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )),
        Spacer(),
        // Text(
        //     "${(widget.amount >= 0) ? "+ " : "- "}₹${widget.amount.abs().toStringAsFixed(2)}",
        //     style: TextStyle(
        //       color: (widget.amount >= 0) ? creditColor : debitColor,
        //       fontSize: 20,
        //       fontWeight: FontWeight.w500,
        //     )),
      ],
    ));
  }
}

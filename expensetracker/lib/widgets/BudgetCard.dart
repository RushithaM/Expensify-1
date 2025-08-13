import 'package:expensetracker/models/category_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BudgetCard extends StatefulWidget {
  BudgetCard(
      {super.key,
      required this.category,
      required this.budget,
      required this.currentDayBudget,
      required this.date});

  double budget;
  double currentDayBudget;
  Category category;
  DateTime date;

  @override
  State<BudgetCard> createState() => _CategoryAnalysisCardState();
}

class _CategoryAnalysisCardState extends State<BudgetCard> {
  double creditPercent = 0.0;
  double debitPercent = 0.0;

  double budgetSpentToday = 0;
  double budgetForToday = 0;
  double budgetLeftPerType = 0;

  @override
  void initState() {
    super.initState();
    calculateBudgetLeft();
  }

  calculateBudgetLeft() {
    budgetSpentToday = widget.currentDayBudget;
    if (widget.category.type == "Daily") {
      budgetLeftPerType = double.parse(
        ((widget.category.budget - (-widget.budget + widget.currentDayBudget)) /
                getRemainingDaysInMonth(
                    widget.date.year, widget.date.month, widget.date.day))
            .toStringAsFixed(2),
      );
    } else if (widget.category.type == "Weekly") {
      budgetLeftPerType = double.parse(
        ((widget.category.budget - (-widget.budget + widget.currentDayBudget)) /
                getTotalSundaysLeft(widget.date))
            .toStringAsFixed(2),
      );
    } else if (widget.category.type == "Monthly") {
      budgetLeftPerType = double.parse(
          (widget.category.budget - (-widget.budget + widget.currentDayBudget))
              .toStringAsFixed(2));
    }
    budgetForToday =
        double.parse((budgetLeftPerType + budgetSpentToday).toStringAsFixed(2));
  }

  // calculateBudgetLeft() {
  //   curCat = catPro.categories
  //       .firstWhere((c) => c.id == widget.categoryTransaction.id);
  //   if (widget.categoryTransaction.totalCost <= 0) {
  //     if (curCat.budget + widget.categoryTransaction.totalCost >= 0) {
  //       budgetLeft = curCat.budget + widget.categoryTransaction.totalCost;
  //       if (curCat.type == "Daily") {
  //         pertype = double.parse(
  //             (budgetLeft / daysInMonth(widget.date)).toStringAsFixed(2));
  //       } else if (curCat.type == "Weekly") {
  //         pertype = double.parse((budgetLeft / 4).toStringAsFixed(2));
  //       } else {
  //         pertype = budgetLeft;
  //       }
  //       alertString = "left";
  //     } else {
  //       budgetLeft = curCat.budget + widget.categoryTransaction.totalCost;
  //       if (curCat.type == "Daily") {
  //         pertype = double.parse(
  //             (budgetLeft / daysInMonth(widget.date)).toStringAsFixed(2));
  //       } else if (curCat.type == "Weekly") {
  //         pertype = double.parse((budgetLeft / 4).toStringAsFixed(2));
  //       } else {
  //         pertype = budgetLeft;
  //       }
  //       alertString = "spent extra";
  //     }
  //   } else {
  //     if (curCat.budget - widget.categoryTransaction.totalCost >= 0) {
  //       budgetLeft = curCat.budget - widget.categoryTransaction.totalCost;
  //       if (curCat.type == "Daily") {
  //         pertype = double.parse(
  //             (budgetLeft / daysInMonth(widget.date)).toStringAsFixed(2));
  //       } else if (curCat.type == "Weekly") {
  //         pertype = double.parse((budgetLeft / 4).toStringAsFixed(2));
  //       } else {
  //         pertype = budgetLeft;
  //       }
  //       alertString = "yet to get";
  //     } else {
  //       budgetLeft = widget.categoryTransaction.totalCost - curCat.budget;
  //       if (curCat.type == "Daily") {
  //         pertype = double.parse(
  //             (budgetLeft / daysInMonth(widget.date)).toStringAsFixed(2));
  //       } else if (curCat.type == "Weekly") {
  //         pertype = double.parse((budgetLeft / 4).toStringAsFixed(2));
  //       } else {
  //         pertype = budgetLeft;
  //       }
  //       alertString = "got extra";
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE0E4F5), width: 3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 12, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(widget.category.emoji,
                        style: TextStyle(
                          fontSize: 30,
                        )),
                  ),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.category.categoryName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3C3C3C),
                            fontWeight: FontWeight.w500,
                          )),
                      Text("₹${budgetSpentToday.abs()} spent today",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3C3C3C),
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("₹${budgetForToday.abs()}",
                      style: TextStyle(
                        fontSize: 16,
                        color: (budgetForToday >= 0) ? creditColor : debitColor,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(
                      (budgetForToday >= 0)
                          ? "left for " +
                              "${(widget.category.type == "Daily") ? "today" : (widget.category.type == "Weekly") ? "week" : "month"}"
                          : "spent extra",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3C3C3C),
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:expensetracker/models/category_monthly_transactions_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryAnalysisCard extends StatefulWidget {
  CategoryAnalysisCard(
      {super.key,
      required this.categoryTransaction,
      required this.creditCost,
      required this.debitCost});

  CategoryTransaction categoryTransaction;
  double creditCost;
  double debitCost;

  @override
  State<CategoryAnalysisCard> createState() => _CategoryAnalysisCardState();
}

class _CategoryAnalysisCardState extends State<CategoryAnalysisCard> {
  double creditPercent = 0.0;
  double debitPercent = 0.0;
  @override
  void initState() {
    super.initState();
    creditPercent = (widget.categoryTransaction.totalCost >= 0)
        ? (widget.categoryTransaction.totalCost * 100) / widget.creditCost
        : 0.0;
    debitPercent = (widget.categoryTransaction.totalCost < 0)
        ? (widget.categoryTransaction.totalCost * 100) / widget.debitCost
        : 0.0;
    if (widget.creditCost == 0.0) {
      creditPercent = 0.0;
    }
    if (widget.debitCost == 0.0) {
      debitPercent = 0.0;
    }
  }

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
                    child: Text(
                        catPro.categories
                            .firstWhere(
                                (category) =>
                                    category.id ==
                                    widget.categoryTransaction.id,
                                orElse: () => emptyCategory)
                            .emoji,
                        style: TextStyle(
                          fontSize: 30,
                        )),
                  ),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          catPro.categories
                              .firstWhere(
                                  (category) =>
                                      category.id ==
                                      widget.categoryTransaction.id,
                                  orElse: () => emptyCategory)
                              .categoryName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3C3C3C),
                            fontWeight: FontWeight.w500,
                          )),
                      Text(
                          "${double.parse((widget.categoryTransaction.totalCost < 0) ? (debitPercent).toStringAsFixed(2) : creditPercent.toStringAsFixed(2))}% of ${(widget.categoryTransaction.totalCost < 0) ? "debit" : "credit"}",
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
                  Text(
                      "${(widget.categoryTransaction.totalCost >= 0) ? "+ " : "- "}₹${widget.categoryTransaction.totalCost.abs()}",
                      style: TextStyle(
                        fontSize: 16,
                        color: (widget.categoryTransaction.totalCost >= 0)
                            ? creditColor
                            : debitColor,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(
                      widget.categoryTransaction.count.toString() +
                          " transactions",
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

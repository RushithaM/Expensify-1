import 'package:expensetracker/models/category_model.dart';
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

  Category category = emptyCategory;
  @override
  void initState() {
    super.initState();
    category = catPro.categories
        .firstWhere((cat) => cat.id == widget.categoryTransaction.id);
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
    print(category.budget);
    print(widget.categoryTransaction.totalCost);
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
                    child: Text(category.emoji,
                        style: TextStyle(
                          fontSize: 30,
                        )),
                  ),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.categoryName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3C3C3C),
                            fontWeight: FontWeight.w500,
                          )),
                      Text(
                          (category.budget == 0 ||
                                  widget.categoryTransaction.totalCost > 0)
                              ? "NA"
                              : "₹${(category.budget + widget.categoryTransaction.totalCost).abs()} " +
                                  "${((category.budget + widget.categoryTransaction.totalCost) < 0) ? "spent extra" : "left"}",
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

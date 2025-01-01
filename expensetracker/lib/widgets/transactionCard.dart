import 'package:expensetracker/models/transaction_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TransactionCard extends StatefulWidget {
  TransactionCard(
      {super.key,
      required this.transaction,
      required this.editTransaction,
      required this.deleteTransaction,
      required this.isRecent});
  final editTransaction;
  final deleteTransaction;
  Transaction transaction;
  bool isRecent;
  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool isLoading = false;
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
              Expanded(
                flex: 7,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Container(
                            alignment: Alignment.center,
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: lightColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: Text(
                                catPro.categories
                                    .firstWhere(
                                      (category) =>
                                          category.id ==
                                          widget.transaction.categoryId,
                                      orElse: () => emptyCategory,
                                    )
                                    .emoji,
                                style: TextStyle(fontSize: 30)))),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              catPro.categories
                                  .firstWhere(
                                      (category) =>
                                          category.id ==
                                          widget.transaction.categoryId,
                                      orElse: () => emptyCategory)
                                  .categoryName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3C3C3C),
                                fontWeight: FontWeight.w500,
                              )),
                          Text(widget.transaction.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF3C3C3C),
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        "${(widget.transaction.type == "credit") ? "+ " : "- "}₹${widget.transaction.amount.abs().toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: (widget.transaction.type == "credit")
                              ? creditColor
                              : debitColor,
                          fontWeight: FontWeight.w500,
                        )),
                    Text(formatDateTime(widget.transaction.date.toString()),
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF3C3C3C),
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
              ),
              (!widget.isRecent)
                  ? Expanded(
                      flex: 1,
                      child: PopupMenuButton<String>(
                        color: Colors.white,
                        onSelected: (value) async {
                          if (value == "Edit") {
                            widget.editTransaction();
                          } else if (value == "Delete") {
                            widget.deleteTransaction();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "Edit",
                            child: Text("Edit"),
                          ),
                          PopupMenuItem(
                            value: "Delete",
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}

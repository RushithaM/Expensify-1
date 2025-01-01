import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/screens/transactions/add_transaction.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/monthAmountCard.dart';
import 'package:expensetracker/widgets/transactionCard.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool stopCalling = false;
  bool isLoading = false;

  bool deleteLoading = false;
  void initState() {
    super.initState();
    getMonthlytransactions();
  }

  Future<void> getMonthlytransactions() async {
    if (stopCalling) {
      return;
    }
    if (mounted)
      setState(() {
        isLoading = true;
      });
    while (!stopCalling) {
      var resp = await transPro.getMonthlyTransactions(prefs!.getString('id')!,
          generateDate(year, month), generateDate(year, month + 1));
      if (resp['message'] == "No more transactions available") {
        stopCalling = true;
        if (mounted)
          setState(() {
            stopCalling = true;
          });
      }
      month -= 1;
      if (month == 0) {
        month = 12;
        year -= 1;
      }
      if (mounted) setState(() {});
    }
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        toolbarHeight: 70,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: Text(
            'History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: appColor,
          onRefresh: () async {
            transPro.monthlyTransactions = [];
            month = DateTime.now().month;
            year = DateTime.now().year;
            stopCalling = false;
            if (mounted) setState(() {});
            await getMonthlytransactions();
          },
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0;
                          i < transPro.monthlyTransactions.length;
                          i++)
                        Column(
                          children: [
                            MonthAmountCard(
                                date: transPro.monthlyTransactions[i].date,
                                amount: calculateMonthlyTotal(transPro
                                    .monthlyTransactions[i].transactions)),
                            SizedBox(height: 10),
                            for (int j = transPro.monthlyTransactions[i]
                                        .transactions.length -
                                    1;
                                j >= 0;
                                j--)
                              TransactionCard(
                                isRecent: false,
                                transaction: transPro
                                    .monthlyTransactions[i].transactions[j],
                                deleteTransaction: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, SetState) {
                                          return AlertDialog(
                                            title: Text("Delete Transaction"),
                                            content: Text(
                                              "Are you sure you want to delete this transaction?",
                                              style: TextStyle(
                                                  color: Color(0xFF3C3C3C)),
                                            ),
                                            actions: [
                                              if (deleteLoading)
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: appColor),
                                                )
                                              else
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: CancelButton(
                                                          "Cancel"),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        SetState(() {
                                                          deleteLoading = true;
                                                        });
                                                        var resp = await transPro
                                                            .deleteTransaction(
                                                                transPro
                                                                        .monthlyTransactions[
                                                                            i]
                                                                        .transactions[
                                                                    j],
                                                                i,
                                                                j,
                                                                transPro
                                                                    .monthlyTransactions[
                                                                        i]
                                                                    .transactions[
                                                                        j]
                                                                    .date);
                                                        SetState(() {
                                                          deleteLoading = false;
                                                        });
                                                        if (resp['message'] ==
                                                            'success') {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    "Transaction Deleted")),
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    "Something went wrong")),
                                                          );
                                                        }
                                                        if (mounted)
                                                          setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          AppButton("Delete"),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                editTransaction: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddTransactionPage(
                                                  transaction: transPro
                                                      .monthlyTransactions[i]
                                                      .transactions[j],
                                                  i: i,
                                                  j: j,
                                                  isEdit: true)));
                                  if (mounted) setState(() {});
                                },
                              ),
                            SizedBox(height: 7),
                          ],
                        ),
                      if (stopCalling)
                        Align(
                          alignment: Alignment.center,
                          child: Text("No more transactions available",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3C3C3C),
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      if (isLoading)
                        Align(
                          alignment: Alignment.center,
                          child: Text("Loading...",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3C3C3C),
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      SizedBox(height: 60)
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}

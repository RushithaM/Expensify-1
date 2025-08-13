import 'package:expensetracker/main.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/screens/calendar/calendar.dart';
import 'package:expensetracker/screens/profile/profile.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/home/summaryCard.dart';
import 'package:expensetracker/widgets/transactionCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    if (isLoading) return;
    if (mounted)
      setState(() {
        name = (prefs == null) ? "" : prefs!.getString('name')!;
      });
    if (checkServerStatus(bUrl) == "Down") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No internet connection"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (!areRecentFetched) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      await getCategories();
      await getRecentTransactions();
      await getCurrentMonthTransactions();
      if (mounted)
        setState(() {
          isLoading = false;
        });
      areRecentFetched = true;
    }
  }

  Future<void> getCurrentMonthTransactions() async {
    await transPro.getMonthlyTransactions(prefs!.getString('id')!,
        generateDate(year, month, 1), generateDate(year, month + 1, 1));
    month -= 1;
    if (month == 0) {
      month = 12;
      year -= 1;
    }
    if (mounted) setState(() {});
  }

  Future<void> getCategories() async {
    var resp = await catPro.getcategories(prefs!.getString('id')!);
    if (resp['message'] == 'success') {
    } else if (resp['message'] == "Service Unavailable") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please try again later"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> getRecentTransactions() async {
    DateTime now = DateTime.now();
    await transPro.getRecentTransactions(
        prefs!.getString('id')!, generateDate(now.year, now.month, 1));
    if (mounted) setState(() {});
  }

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        toolbarHeight: 180,
        title: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/logo.svg',
                        color: Colors.white, width: 40, height: 50),
                    SizedBox(width: 10),
                    Text(
                      'Expensify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarPage()));
                      },
                      child: Icon(Icons.calendar_month_outlined,
                          color: Colors.white, size: 30),
                    ),
                    SizedBox(width: 12),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                        },
                        child:
                            Icon(Icons.person, color: Colors.white, size: 30)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25),
            Text("Hello, ${name} 👋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                )),
            SizedBox(height: 10),
            Text("${(totalAmount >= 0) ? "" : "- "}₹${totalAmount.abs()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                )),
          ]),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: appColor,
          onRefresh: () async {
            transPro.recentTransactions = [];
            transPro.monthlyTransactions = [];
            transPro.categoryMonthlyTransactions = [];
            catPro.categories = [];
            initGlobals();
            await getDetails();
          },
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Summary",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF3C3C3C),
                                  fontWeight: FontWeight.w500,
                                )),
                            Text(
                              "This month",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3C3C3C),
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            summary(
                                context,
                                "🤑",
                                "Income",
                                (transPro.monthlyTransactions.length != 0)
                                    ? calculateIncome(transPro
                                        .monthlyTransactions[0].transactions)
                                    : 0,
                                'up'),
                            summary(
                                context,
                                "💸",
                                "Expense",
                                (transPro.monthlyTransactions.length != 0)
                                    ? calculateExpendicture(transPro
                                        .monthlyTransactions[0].transactions)
                                    : 0,
                                'down')
                          ],
                        ),
                        SizedBox(height: 20),
                        Text("Recent Transactions",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF3C3C3C),
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(height: 16),
                        if (!isLoading &&
                            transPro.recentTransactions.length == 0)
                          Center(
                            child: Text("No transactions yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3C3C3C),
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        for (int i = 0;
                            i < transPro.recentTransactions.length;
                            i++)
                          TransactionCard(
                            transaction: transPro.recentTransactions[i],
                            deleteTransaction: () {},
                            editTransaction: () {},
                            isRecent: true,
                          ),
                        if (isLoading)
                          Center(
                            child: Text("Loading...",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3C3C3C),
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        SizedBox(height: 50),
                      ],
                    ));
              }),
        ),
      ),
    );
  }
}

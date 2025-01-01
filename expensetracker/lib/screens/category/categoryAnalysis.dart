import 'package:expensetracker/models/category_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/screens/category/add_category.dart';
import 'package:expensetracker/screens/category/all_categories.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/categoryAnalysisCard.dart';
import 'package:expensetracker/widgets/monthAmountCard.dart';
import 'package:flutter/material.dart';

class CategoryAnalysisPage extends StatefulWidget {
  const CategoryAnalysisPage({super.key});

  @override
  State<CategoryAnalysisPage> createState() => _CategoryAnalysisPageState();
}

class _CategoryAnalysisPageState extends State<CategoryAnalysisPage> {
  @override
  void initState() {
    super.initState();
    getCategoryMonthlyData();
  }

  bool stopCallingAnalysis = false;
  bool isLoading = false;

  Future<void> getCategoryMonthlyData() async {
    if (stopCallingAnalysis) {
      return;
    }
    if (mounted)
      setState(() {
        isLoading = true;
      });
    while (!stopCallingAnalysis) {
      var resp = await transPro.getCategoryMonthlyTransactions(
          prefs!.getString('id')!,
          generateDate(catYear, catMonth),
          generateDate(catYear, catMonth + 1));
      if (resp['message'] == "No more transactions available") {
        stopCallingAnalysis = true;
        if (mounted)
          setState(() {
            stopCallingAnalysis = true;
          });
      }
      catMonth -= 1;
      if (catMonth == 0) {
        catMonth = 12;
        catYear -= 1;
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
        title: Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AllCategories()));
                },
                child: Icon(
                  Icons.category,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: appColor,
          onRefresh: () async {
            transPro.categoryMonthlyTransactions = [];
            catMonth = DateTime.now().month;
            catYear = DateTime.now().year;
            stopCallingAnalysis = false;
            if (mounted) setState(() {});
            await getCategoryMonthlyData();
          },
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Column(
                    children: [
                      for (int i = 0;
                          i < transPro.categoryMonthlyTransactions.length;
                          i++)
                        Column(
                          children: [
                            MonthAmountCard(
                                date: transPro
                                    .categoryMonthlyTransactions[i].date,
                                amount: getTotalCost(transPro
                                    .categoryMonthlyTransactions[i]
                                    .categoryTransactions)),
                            SizedBox(height: 10),
                            for (int j = 0;
                                j <
                                    transPro.categoryMonthlyTransactions[i]
                                        .categoryTransactions.length;
                                j++)
                              CategoryAnalysisCard(
                                  categoryTransaction: transPro
                                      .categoryMonthlyTransactions[i]
                                      .categoryTransactions[j],
                                  creditCost: getCreditCost(transPro
                                      .categoryMonthlyTransactions[i]
                                      .categoryTransactions),
                                  debitCost: getDebitCost(transPro
                                      .categoryMonthlyTransactions[i]
                                      .categoryTransactions)),
                            SizedBox(height: 7),
                          ],
                        ),
                      if (stopCallingAnalysis)
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
                      SizedBox(height: 100),
                    ],
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: appColor,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddCategory(
                  category: Category(
                      active: true,
                      categoryName: "",
                      emoji: "",
                      id: "",
                      userId: ""),
                  isEdit: false);
            }));
          },
          child: Icon(Icons.add, size: 20, color: Colors.white),
          backgroundColor: appColor,
        ),
      ),
    );
  }
}

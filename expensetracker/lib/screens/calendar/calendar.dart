import 'package:expensetracker/models/monthly_budget_details.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/BudgetCard.dart';
import 'package:expensetracker/widgets/MonthAmountBudgetCard.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    transPro.monthlyBudgetDetails = [];
    stopCallingMonthlyBudget = false;
    budgetMonth = DateTime.now().month;
    budgetYear = DateTime.now().year;
    getMonthlyBudgetData();
  }

  bool stopCallingMonthlyBudget = false;
  bool isLoading = false;

  Future<void> getMonthlyBudgetData() async {
    if (stopCallingMonthlyBudget) {
      return;
    }
    if (mounted)
      setState(() {
        isLoading = true;
      });
    while (!stopCallingMonthlyBudget) {
      var resp = await transPro.getMonthlyBudgetDetails(
          prefs!.getString('id')!,
          generateDate(budgetYear, budgetMonth, 1),
          generateDate(budgetYear, budgetMonth + 1, 1),
          generateDate(budgetYear, budgetMonth, DateTime.now().day));
      if (resp['message'] == "No more transactions available") {
        stopCallingMonthlyBudget = true;
        if (mounted)
          setState(() {
            stopCallingMonthlyBudget = true;
          });
      }
      budgetMonth -= 1;
      if (budgetMonth == 0) {
        budgetMonth = 12;
        budgetYear -= 1;
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
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: appColor,
          toolbarHeight: 70,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
            child: Text(
              'Calendar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TableCalendar(
                  firstDay: DateTime.parse(createdAtDateString!),
                  lastDay:
                      DateTime(DateTime.now().year, DateTime.now().month + 1, 1)
                          .subtract(Duration(days: 1)),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final startDate = DateTime.parse(createdAtDateString!);
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final normalizedDay =
                          DateTime(day.year, day.month, day.day);
                      if ((normalizedDay.isAfter(startDate) ||
                              normalizedDay.isAtSameMomentAs(startDate)) &&
                          (normalizedDay.isBefore(today) ||
                              normalizedDay.isAtSameMomentAs(today))) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: appColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: appColor,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Column(
                  children: [
                    for (int i = 0;
                        i < transPro.monthlyBudgetDetails.length;
                        i++)
                      if (transPro.monthlyBudgetDetails[i].date
                                  .add(DateTime.now().timeZoneOffset)
                                  .month ==
                              _focusedDay.month &&
                          transPro.monthlyBudgetDetails[i].date
                                  .add(DateTime.now().timeZoneOffset)
                                  .year ==
                              _focusedDay.year)
                        Column(
                          children: [
                            MonthAmountBudgetCard(
                                date: transPro.monthlyBudgetDetails[i].date,
                                amount: 200),
                            SizedBox(height: 10),
                            for (int j = 0; j < catPro.categories.length; j++)
                              if (catPro.categories[j].budget != 0 &&
                                  catPro.categories[j].type != "NA" &&
                                  transPro.monthlyBudgetDetails[i].budgetDetails
                                          .firstWhere(
                                            (budget) =>
                                                budget.id ==
                                                catPro.categories[j].id,
                                            orElse: () => BudgetDetail(
                                                id: '',
                                                totalCost: 0,
                                                currentDay: 0),
                                          )
                                          .totalCost <=
                                      0)
                                BudgetCard(
                                  category: catPro.categories[j],
                                  budget: transPro
                                      .monthlyBudgetDetails[i].budgetDetails
                                      .firstWhere(
                                        (budget) =>
                                            budget.id ==
                                            catPro.categories[j].id,
                                        orElse: () => BudgetDetail(
                                            id: '',
                                            totalCost: 0,
                                            currentDay: 0),
                                      )
                                      .totalCost,
                                  currentDayBudget: transPro
                                      .monthlyBudgetDetails[i].budgetDetails
                                      .firstWhere(
                                        (budget) =>
                                            budget.id ==
                                            catPro.categories[j].id,
                                        orElse: () => BudgetDetail(
                                            id: '',
                                            totalCost: 0,
                                            currentDay: 0),
                                      )
                                      .currentDay,
                                  date: DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day),
                                ),
                            SizedBox(height: 7),
                          ],
                        ),
                    if (stopCallingMonthlyBudget)
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
              )
            ],
          ),
        )));
  }
}

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
  Map<String, dynamic>? _selectedDayData;
  bool _isLoadingDailyData = false;

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

  bool _isFutureDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);
    return selectedDate.isAfter(today);
  }

  bool _isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);
    return selectedDate.isBefore(today);
  }

  double _getDailySpendingForCategory(String categoryId) {
    if (_selectedDayData == null) return 0.0;
    
    final categoryTotals = _selectedDayData!['category_totals'] as Map<String, dynamic>;
    if (categoryTotals.containsKey(categoryId)) {
      final data = categoryTotals[categoryId] as Map<String, dynamic>;
      final debit = data['debit'] as double;
      final credit = data['credit'] as double;
      return debit - credit;
    }
    return 0.0;
  }

  Future<void> _loadDailyTransactions(DateTime date) async {
    setState(() {
      _isLoadingDailyData = true;
    });

    try {
      final response = await transPro.getDailyTransactions(
        prefs!.getString('id')!,
        date,
      );

      if (mounted) {
        setState(() {
          if (response['message'] == 'success') {
            _selectedDayData = response;
          } else {
            _selectedDayData = null;
          }
          _isLoadingDailyData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedDayData = null;
          _isLoadingDailyData = false;
        });
      }
    }
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
                    if (_isPastDate(selectedDay)) {
                      _loadDailyTransactions(selectedDay);
                    } else {
                      setState(() {
                        _selectedDayData = null;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _selectedDay = null;
                      _selectedDayData = null;
                    });
                  },
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
                                date: _selectedDay ?? transPro.monthlyBudgetDetails[i].date,
                                amount: _selectedDay != null && _selectedDayData != null ? 0 : 200),
                            SizedBox(height: 10),
                                                         for (int j = 0; j < catPro.categories.length; j++)
                               if (catPro.categories[j].active == true &&
                                   catPro.categories[j].budget != 0 &&
                                   catPro.categories[j].type != "NA" &&
                                   (_selectedDay != null && _selectedDayData != null
                                       ? _getDailySpendingForCategory(catPro.categories[j].id) > 0  // Only show if daily spending > 0
                                       : transPro.monthlyBudgetDetails[i].budgetDetails
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
                                       0))
                                BudgetCard(
                                  category: catPro.categories[j],
                                  budget: _selectedDay != null && _selectedDayData != null
                                      ? _getDailySpendingForCategory(catPro.categories[j].id)  // Show daily spending as main amount
                                      : transPro
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
                                  currentDayBudget: _selectedDay != null && _selectedDayData != null
                                      ? _getDailySpendingForCategory(catPro.categories[j].id)
                                      : transPro
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
                                  date: _selectedDay ?? DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day),
                                  showDailySpending: _selectedDay != null && _selectedDayData != null,
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

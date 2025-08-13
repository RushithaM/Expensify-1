import 'package:expensetracker/models/category_model.dart';
import 'package:expensetracker/models/category_monthly_transactions_model.dart';
import 'package:expensetracker/models/transaction_model.dart';
import 'package:expensetracker/providers/category_provider.dart';
import 'package:expensetracker/providers/transactions_provider.dart';
import 'package:expensetracker/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:io';

SharedPreferences? prefs;
Map<String, String> headers = {
  'Content-Type': 'application/json',
};

DateFormat stringDateFormat = DateFormat('dd/MM/yyyy');

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

String generateDate(int year, int month, int day) {
  DateTime dateTime = DateTime(year, month, day);
  Duration offset = dateTime.timeZoneOffset;
  int offsetHours = offset.inHours;
  int offsetMinutes = offset.inMinutes.remainder(60);
  String formattedDate =
      "${dateTime.toIso8601String().split('T')[0]}T00:00:00.000"
      "${offsetHours >= 0 ? '+' : '-'}"
      "${offsetHours.abs().toString().padLeft(2, '0')}:"
      "${offsetMinutes.abs().toString().padLeft(2, '0')}";
  return formattedDate;
}

String formatDateTime(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('EEE d, MMMM').format(dateTime);
    return formattedDate;
  } catch (e) {
    return dateTimeString;
  }
}

String formatToMonthYear(DateTime dateTime) {
  return DateFormat('MMMM, yyyy')
      .format(dateTime.add(DateTime.now().timeZoneOffset));
}

double calculateMonthlyTotal(List<Transaction> transactions) {
  double total = 0;
  for (Transaction transaction in transactions) {
    if (transaction.type == 'credit') {
      total += transaction.amount;
    } else if (transaction.type == 'debit') {
      total -= transaction.amount;
    }
  }
  return total;
}

double calculateExpendicture(List<Transaction> transactions) {
  double expendicture = 0;
  for (Transaction transaction in transactions) {
    if (transaction.type == 'debit') {
      expendicture += transaction.amount;
    }
  }
  return expendicture;
}

double calculateIncome(List<Transaction> transactions) {
  double income = 0;
  for (Transaction transaction in transactions) {
    if (transaction.type == 'credit') {
      income += transaction.amount;
    }
  }
  return income;
}

double getTotalCost(List<CategoryTransaction> categoryTransaction) {
  double totalCost = 0;
  for (CategoryTransaction transaction in categoryTransaction) {
    totalCost += transaction.totalCost;
  }
  return totalCost;
}

double getCreditCost(List<CategoryTransaction> categoryTransaction) {
  double creditCost = 0;
  for (CategoryTransaction transaction in categoryTransaction) {
    if (transaction.totalCost >= 0) {
      creditCost += transaction.totalCost;
    }
  }
  return creditCost;
}

double getDebitCost(List<CategoryTransaction> categoryTransaction) {
  double debitCost = 0;
  for (CategoryTransaction transaction in categoryTransaction) {
    if (transaction.totalCost < 0) {
      debitCost += transaction.totalCost;
    }
  }
  return debitCost;
}

int daysInMonth(DateTime date) {
  final firstDayThisMonth = DateTime(date.year, date.month, 1);
  final firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}

int getRemainingDaysInMonth(int year, int month, int day) {
  DateTime today = DateTime(year, month, day);
  DateTime nextMonth =
      (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
  return nextMonth.difference(today).inDays;
}

int getTotalSundaysLeft(DateTime today) {
  DateTime endOfMonth = DateTime(today.year, today.month + 1, 0);
  int count = 0;
  for (DateTime date = DateTime(today.year, today.month, today.day);
      !date.isAfter(endOfMonth);
      date = date.add(Duration(days: 1))) {
    if (date.weekday == DateTime.sunday) {
      count++;
    }
  }
  return count;
}

CategoryProvider catPro = CategoryProvider();
TransactionsProvider transPro = TransactionsProvider();
UserProvider userPro = UserProvider();

bool areRecentFetched = false;
int month = DateTime.now().month;
int year = DateTime.now().year;

int budgetMonth = DateTime.now().month;
int budgetYear = DateTime.now().year;

int catMonth = DateTime.now().month;
int catYear = DateTime.now().year;
double totalAmount = 0;
String? createdAtDateString;

void initGlobals() {
  year = DateTime.now().year;
  month = DateTime.now().month;
  catYear = DateTime.now().year;
  catMonth = DateTime.now().month;
  budgetMonth = DateTime.now().month;
  budgetYear = DateTime.now().year;
  areRecentFetched = false;
  totalAmount = 0;
}

Category emptyCategory = Category(
    type: "",
    categoryName: "Category",
    emoji: "💰",
    active: true,
    userId: "",
    id: "",
    budget: 0);

Future<String> checkServerStatus(String serverUrl) async {
  try {
    final uri = Uri.parse(serverUrl);
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();
    if (response.statusCode == 200) {
      return 'Up';
    } else {
      return 'Dowm';
    }
  } on SocketException {
    return 'Down';
  } catch (e) {
    return 'Down';
  }
}

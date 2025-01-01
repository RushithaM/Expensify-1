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

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

String generateDate(int year, int month) {
  DateTime dateTime = DateTime(year, month, 1);
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
    String formattedDate = DateFormat('EEE d, hh:mm a').format(dateTime);
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

CategoryProvider catPro = CategoryProvider();
TransactionsProvider transPro = TransactionsProvider();
UserProvider userPro = UserProvider();

bool areRecentFetched = false;
int month = DateTime.now().month;
int year = DateTime.now().year;

int catMonth = DateTime.now().month;
int catYear = DateTime.now().year;
double totalAmount = 0;

void initGlobals() {
  year = DateTime.now().year;
  month = DateTime.now().month;
  catYear = DateTime.now().year;
  catMonth = DateTime.now().month;
  areRecentFetched = false;
  totalAmount = 0;
}

Category emptyCategory = Category(
    categoryName: "Category", emoji: "💰", active: true, userId: "", id: "");

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

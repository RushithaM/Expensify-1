import 'dart:convert';
import 'package:expensetracker/main.dart';
import 'package:expensetracker/models/category_monthly_transactions_model.dart';
import 'package:expensetracker/models/transaction_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:http/http.dart' as http;

class TransactionsProvider {
  List<Transaction> recentTransactions = [];
  List<MonthlyTransactions> monthlyTransactions = [];
  List<CategoryMonthlyTransactions> categoryMonthlyTransactions = [];

  Future<Map<String, dynamic>> addTransaction(
      String user_id,
      String category_id,
      double amount,
      String description,
      String type) async {
    final url = Uri.parse('${bUrl}/transactions/add_transaction');
    final body = jsonEncode({
      "user_id": user_id,
      'category_id': category_id,
      'amount': amount,
      "description": description,
      "type": type
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        //amount update
        if (type == "debit") {
          totalAmount -= amount;
        } else {
          totalAmount += amount;
        }
        Transaction newTransaction = Transaction(
            userId: user_id,
            id: resp['transaction_id'],
            categoryId: category_id,
            amount: amount,
            description: description,
            type: type,
            date: DateTime.now());

        //recent update
        transPro.recentTransactions.insert(0, newTransaction);

        //monthly update
        if (transPro.monthlyTransactions.first.date
                    .add(DateTime.now().timeZoneOffset)
                    .month ==
                DateTime.now().month &&
            transPro.monthlyTransactions.first.date
                    .add(DateTime.now().timeZoneOffset)
                    .year ==
                DateTime.now().year) {
          transPro.monthlyTransactions.first.transactions.add(newTransaction);
        } else {
          transPro.monthlyTransactions.add(MonthlyTransactions(
              date: DateTime.now(), transactions: [newTransaction]));
        }

        //monthly caterogy data update
        if (transPro.categoryMonthlyTransactions.isEmpty) {
          return {'message': 'success'};
        }
        if (transPro.categoryMonthlyTransactions.first.date
                    .add(DateTime.now().timeZoneOffset)
                    .month ==
                DateTime.now().month &&
            transPro.categoryMonthlyTransactions.first.date
                    .add(DateTime.now().timeZoneOffset)
                    .year ==
                DateTime.now().year) {
          bool exist = transPro
              .categoryMonthlyTransactions.first.categoryTransactions
              .any((element) => element.id == category_id);
          if (exist) {
            transPro.categoryMonthlyTransactions.first.categoryTransactions
                .firstWhere((element) => element.id == category_id)
                .count += 1;
            if (type == "debit") {
              transPro.categoryMonthlyTransactions.first.categoryTransactions
                  .firstWhere((element) => element.id == category_id)
                  .totalCost -= amount;
            } else {
              transPro.categoryMonthlyTransactions.first.categoryTransactions
                  .firstWhere((element) => element.id == category_id)
                  .totalCost += amount;
            }
          } else {
            transPro.categoryMonthlyTransactions.first.categoryTransactions
                .add(CategoryTransaction(
              id: category_id,
              count: 1,
              totalCost: (type == "credit") ? amount : -amount,
            ));
          }
        } else {
          transPro.categoryMonthlyTransactions.add(CategoryMonthlyTransactions(
              date: DateTime.now(),
              categoryTransactions: [
                CategoryTransaction(
                  id: category_id,
                  count: 1,
                  totalCost: (type == "credit") ? amount : -amount,
                )
              ]));
        }
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> getRecentTransactions(
      String user_id, String date) async {
    final url = Uri.parse('${bUrl}/transactions/get_recent_transactions');
    final body = jsonEncode({"user_id": user_id, 'date': date});
    try {
      transPro.recentTransactions = [];
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        transPro.recentTransactions =
            RecentTransactionModel.fromJson(resp).transactions;
        totalAmount = RecentTransactionModel.fromJson(resp).totalAmount;
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'error': 'Something went wrong: $e', 'message': 'not ok'};
    }
  }

  Future<Map<String, dynamic>> getMonthlyTransactions(
      String user_id, String start_date, String end_date) async {
    final url = Uri.parse('${bUrl}/transactions/get_monthly_transactions');
    final body = jsonEncode(
        {"user_id": user_id, 'start_date': start_date, 'end_date': end_date});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        MonthlyTransactions monthlyTransaction =
            MonthlyTransactionModel.fromJson(resp).monthlyTransactions;
        if (transPro.monthlyTransactions
            .any((element) => element.date == monthlyTransaction.date)) {
          return {'message': 'success'};
        }
        transPro.monthlyTransactions.add(monthlyTransaction);
        return {'message': 'success'};
      } else if (resp['message'] == "No more transactions available") {
        return {'message': 'No more transactions available'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'error': 'Something went wrong: $e', 'message': 'not ok'};
    }
  }

  Future<Map<String, dynamic>> getCategoryMonthlyTransactions(
      String user_id, String start_date, String end_date) async {
    final url =
        Uri.parse('${bUrl}/transactions/get_category_monthly_transactions');
    final body = jsonEncode(
        {"user_id": user_id, 'start_date': start_date, 'end_date': end_date});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        CategoryMonthlyTransactions categoryMonthlyTransaction =
            CategoryMonthlyTransactionsModel.fromJson(resp)
                .categoryMonthlyTransactions;
        if (transPro.categoryMonthlyTransactions.any(
            (element) => element.date == categoryMonthlyTransaction.date)) {
          return {'message': 'success'};
        }
        transPro.categoryMonthlyTransactions.add(categoryMonthlyTransaction);
        return {'message': 'success'};
      } else if (resp['message'] == "No more transactions available") {
        return {'message': 'No more transactions available'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'error': 'Something went wrong: $e', 'message': 'not ok'};
    }
  }

  Future<Map<String, dynamic>> deleteTransaction(
      Transaction transaction, int i, int j, DateTime date) async {
    final url = Uri.parse('${bUrl}/transactions/delete_transaction');
    final body = jsonEncode(
        {"transaction_id": transaction.id, 'user_id': transaction.userId});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      if (resp['message'] == "success") {
        //total amount update
        if (transaction.type == "debit") {
          totalAmount += transPro.monthlyTransactions[i].transactions[j].amount;
        } else {
          totalAmount -= transPro.monthlyTransactions[i].transactions[j].amount;
        }

        //monthly transactions update
        transPro.monthlyTransactions[i].transactions
            .remove(transPro.monthlyTransactions[i].transactions[j]);
        if (transPro.recentTransactions
            .any((element) => element.id == transaction.id)) {
          transPro.recentTransactions
              .removeWhere((element) => element.id == transaction.id);
        }

        //monthly category data update
        if (transPro.categoryMonthlyTransactions.isEmpty) {
          return {'message': 'success'};
        }
        DateTime now = DateTime.now();
        transPro.categoryMonthlyTransactions
            .firstWhere((element) =>
                element.date.add(now.timeZoneOffset).month == now.month &&
                element.date.add(now.timeZoneOffset).year == now.year)
            .categoryTransactions
            .firstWhere((element) => element.id == transaction.categoryId)
            .count -= 1;
        if (transaction.type == "debit") {
          transPro.categoryMonthlyTransactions
              .firstWhere((element) =>
                  element.date.add(now.timeZoneOffset).month == now.month &&
                  element.date.add(now.timeZoneOffset).year == now.year)
              .categoryTransactions
              .firstWhere((element) => element.id == transaction.categoryId)
              .totalCost += transaction.amount;
        } else {
          transPro.categoryMonthlyTransactions
              .firstWhere((element) =>
                  element.date.add(now.timeZoneOffset).month == now.month &&
                  element.date.add(now.timeZoneOffset).year == now.year)
              .categoryTransactions
              .firstWhere((element) => element.id == transaction.categoryId)
              .totalCost -= transaction.amount;
        }
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {'message': 'Something went wrong'};
    }
  }

  Future<Map<String, dynamic>> editTransaction(
      String transaction_id,
      String category_id,
      double amount,
      String user_id,
      String description,
      String type,
      int i,
      int j) async {
    final url = Uri.parse('${bUrl}/transactions/edit_transaction');
    final body = jsonEncode({
      "transaction_id": transaction_id,
      'category_id': category_id,
      'amount': amount,
      "description": description,
      "user_id": user_id,
      "type": type
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      final resp = jsonDecode(response.body);
      double updateAmount = totalAmount;
      if (resp['message'] == "success") {
        //totalamount update
        if (transPro.monthlyTransactions[i].transactions[j].type == "debit") {
          updateAmount +=
              transPro.monthlyTransactions[i].transactions[j].amount;
        } else {
          updateAmount -=
              transPro.monthlyTransactions[i].transactions[j].amount;
        }
        if (type == "debit") {
          updateAmount -= amount;
        } else {
          updateAmount += amount;
        }
        totalAmount = updateAmount;

        final Transaction oldTransaction = Transaction(
          id: transPro.monthlyTransactions[i].transactions[j].id,
          userId: transPro.monthlyTransactions[i].transactions[j].userId,
          categoryId:
              transPro.monthlyTransactions[i].transactions[j].categoryId,
          amount: transPro.monthlyTransactions[i].transactions[j].amount,
          description:
              transPro.monthlyTransactions[i].transactions[j].description,
          type: transPro.monthlyTransactions[i].transactions[j].type,
          date: transPro.monthlyTransactions[i].transactions[j].date,
        );

        //monthly transactions update
        transPro.monthlyTransactions[i].transactions[j].amount = amount;
        transPro.monthlyTransactions[i].transactions[j].description =
            description;
        transPro.monthlyTransactions[i].transactions[j].categoryId =
            category_id;
        transPro.monthlyTransactions[i].transactions[j].type = type;
        transPro.monthlyTransactions[i].transactions[j].date = DateTime.now();

        //recent transactions update
        if (transPro.recentTransactions
            .any((element) => element.id == transaction_id)) {
          transPro.recentTransactions
              .firstWhere((element) => element.id == transaction_id)
              .amount = amount;
          transPro.recentTransactions
              .firstWhere((element) => element.id == transaction_id)
              .description = description;
          transPro.recentTransactions
              .firstWhere((element) => element.id == transaction_id)
              .categoryId = category_id;
          transPro.recentTransactions
              .firstWhere((element) => element.id == transaction_id)
              .type = type;
          transPro.recentTransactions
              .firstWhere((element) => element.id == transaction_id)
              .date = DateTime.now();
        }

        //monthly category data update
        if (transPro.categoryMonthlyTransactions.isEmpty) {
          return {'message': 'success'};
        }
        DateTime now = DateTime.now();
        //correcting
        transPro.categoryMonthlyTransactions
            .firstWhere((element) =>
                element.date.add(now.timeZoneOffset).month == now.month &&
                element.date.add(now.timeZoneOffset).year == now.year)
            .categoryTransactions
            .firstWhere((element) => element.id == oldTransaction.categoryId)
            .totalCost += (oldTransaction.type ==
                "debit")
            ? oldTransaction.amount
            : -oldTransaction.amount;
        transPro.categoryMonthlyTransactions
            .firstWhere((element) =>
                element.date.add(now.timeZoneOffset).month == now.month &&
                element.date.add(now.timeZoneOffset).year == now.year)
            .categoryTransactions
            .firstWhere((element) => element.id == oldTransaction.categoryId)
            .count -= 1;
        //updating
        if (!transPro.categoryMonthlyTransactions.any((element) =>
            element.date.add(now.timeZoneOffset).month == now.month &&
            element.date.add(now.timeZoneOffset).year == now.year)) {
          transPro.categoryMonthlyTransactions.add(CategoryMonthlyTransactions(
              date: DateTime.now(),
              categoryTransactions: [
                CategoryTransaction(
                  id: category_id,
                  count: 1,
                  totalCost: (type == "credit") ? amount : -amount,
                )
              ]));
          return {'message': 'success'};
        }
        if (!transPro.categoryMonthlyTransactions
            .firstWhere((element) =>
                element.date.add(now.timeZoneOffset).month == now.month &&
                element.date.add(now.timeZoneOffset).year == now.year)
            .categoryTransactions
            .any((element) => element.id == category_id)) {
          transPro.categoryMonthlyTransactions
              .firstWhere((element) =>
                  element.date.add(now.timeZoneOffset).month == now.month &&
                  element.date.add(now.timeZoneOffset).year == now.year)
              .categoryTransactions
              .add(CategoryTransaction(
                id: category_id,
                count: 1,
                totalCost: (type == "credit") ? amount : -amount,
              ));
          return {'message': 'success'};
        }
        transPro.categoryMonthlyTransactions
            .firstWhere((element) =>
                element.date.add(now.timeZoneOffset).month == now.month &&
                element.date.add(now.timeZoneOffset).year == now.year)
            .categoryTransactions
            .firstWhere((element) => element.id == category_id)
            .totalCost += (type == "debit") ? -amount : amount;
        transPro.categoryMonthlyTransactions
            .firstWhere((element) =>
                element.date.add(now.timeZoneOffset).month == now.month &&
                element.date.add(now.timeZoneOffset).year == now.year)
            .categoryTransactions
            .firstWhere((element) => element.id == category_id)
            .count += 1;
        return {'message': 'success'};
      } else {
        return {'message': resp['message']};
      }
    } catch (e) {
      return {
        'error': 'Something went wrong: $e',
        'message': 'Something went wrong'
      };
    }
  }
}

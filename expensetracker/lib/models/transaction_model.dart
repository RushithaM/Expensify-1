import 'dart:convert';

RecentTransactionModel RecentTransactionModelFromJson(String str) =>
    RecentTransactionModel.fromJson(json.decode(str));

String RecentTransactionModelToJson(RecentTransactionModel data) =>
    json.encode(data.toJson());

class RecentTransactionModel {
  String message;
  List<Transaction> transactions;
  double totalAmount;

  RecentTransactionModel({
    required this.message,
    required this.transactions,
    required this.totalAmount,
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) =>
      RecentTransactionModel(
        message: json["message"],
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
        "total_amount": totalAmount,
      };
}

MonthlyTransactionModel MonthlyTransactionModelFromJson(String str) =>
    MonthlyTransactionModel.fromJson(json.decode(str));

String MonthlyTransactionModelToJson(MonthlyTransactionModel data) =>
    json.encode(data.toJson());

class MonthlyTransactionModel {
  String message;
  MonthlyTransactions monthlyTransactions;

  MonthlyTransactionModel({
    required this.message,
    required this.monthlyTransactions,
  });

  factory MonthlyTransactionModel.fromJson(Map<String, dynamic> json) =>
      MonthlyTransactionModel(
        message: json["message"],
        monthlyTransactions:
            MonthlyTransactions.fromJson(json["monthly_transactions"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "monthly_transactions": monthlyTransactions.toJson(),
      };
}

class MonthlyTransactions {
  DateTime date;
  List<Transaction> transactions;

  MonthlyTransactions({
    required this.date,
    required this.transactions,
  });

  factory MonthlyTransactions.fromJson(Map<String, dynamic> json) =>
      MonthlyTransactions(
        date: DateTime.parse(json["date"]),
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}

class Transaction {
  String id;
  double amount;
  String categoryId;
  DateTime date;
  String description;
  String type;
  String userId;

  Transaction({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.description,
    required this.type,
    required this.userId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["_id"],
        amount: json["amount"],
        categoryId: json["category_id"],
        date: DateTime.parse(json["date"]),
        description: json["description"],
        type: json["type"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "amount": amount,
        "category_id": categoryId,
        "date": date.toIso8601String(),
        "description": description,
        "type": type,
        "user_id": userId,
      };
}

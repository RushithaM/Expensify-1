// To parse this JSON data, do
//
//     final CategoryMonthlyTransactionsModel = CategoryMonthlyTransactionsModelFromJson(jsonString);

import 'dart:convert';

CategoryMonthlyTransactionsModel CategoryMonthlyTransactionsModelFromJson(String str) => CategoryMonthlyTransactionsModel.fromJson(json.decode(str));

String CategoryMonthlyTransactionsModelToJson(CategoryMonthlyTransactionsModel data) => json.encode(data.toJson());

class CategoryMonthlyTransactionsModel {
    CategoryMonthlyTransactions categoryMonthlyTransactions;
    String message;

    CategoryMonthlyTransactionsModel({
        required this.categoryMonthlyTransactions,
        required this.message,
    });

    factory CategoryMonthlyTransactionsModel.fromJson(Map<String, dynamic> json) => CategoryMonthlyTransactionsModel(
        categoryMonthlyTransactions: CategoryMonthlyTransactions.fromJson(json["category_monthly_transactions"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "category_monthly_transactions": categoryMonthlyTransactions.toJson(),
        "message": message,
    };
}

class CategoryMonthlyTransactions {
    List<CategoryTransaction> categoryTransactions;
    DateTime date;

    CategoryMonthlyTransactions({
        required this.categoryTransactions,
        required this.date,
    });

    factory CategoryMonthlyTransactions.fromJson(Map<String, dynamic> json) => CategoryMonthlyTransactions(
        categoryTransactions: List<CategoryTransaction>.from(json["category_transactions"].map((x) => CategoryTransaction.fromJson(x))),
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "category_transactions": List<dynamic>.from(categoryTransactions.map((x) => x.toJson())),
        "date": date.toIso8601String(),
    };
}

class CategoryTransaction {
    String id;
    int count;
    double totalCost;

    CategoryTransaction({
        required this.id,
        required this.count,
        required this.totalCost,
    });

    factory CategoryTransaction.fromJson(Map<String, dynamic> json) => CategoryTransaction(
        id: json["_id"],
        count: json["count"],
        totalCost: json["total_cost"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "count": count,
        "total_cost": totalCost,
    };
}

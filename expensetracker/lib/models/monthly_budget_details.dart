// To parse this JSON data, do
//
//     final MonthlyBudgetDetailsModel = MonthlyBudgetDetailsModelFromJson(jsonString);

import 'dart:convert';

MonthlyBudgetDetailsModel MonthlyBudgetDetailsModelFromJson(String str) =>
    MonthlyBudgetDetailsModel.fromJson(json.decode(str));

String MonthlyBudgetDetailsModelToJson(MonthlyBudgetDetailsModel data) =>
    json.encode(data.toJson());

class MonthlyBudgetDetailsModel {
  String message;
  MonthlyBudgetDetails monthlyBudgetDetails;

  MonthlyBudgetDetailsModel({
    required this.message,
    required this.monthlyBudgetDetails,
  });

  factory MonthlyBudgetDetailsModel.fromJson(Map<String, dynamic> json) =>
      MonthlyBudgetDetailsModel(
        message: json["message"],
        monthlyBudgetDetails:
            MonthlyBudgetDetails.fromJson(json["monthly_budget_details"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "monthly_budget_details": monthlyBudgetDetails.toJson(),
      };
}

class MonthlyBudgetDetails {
  List<BudgetDetail> budgetDetails;
  DateTime date;

  MonthlyBudgetDetails({
    required this.budgetDetails,
    required this.date,
  });

  factory MonthlyBudgetDetails.fromJson(Map<String, dynamic> json) =>
      MonthlyBudgetDetails(
        budgetDetails: List<BudgetDetail>.from(
            json["budget_details"].map((x) => BudgetDetail.fromJson(x))),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "budget_details":
            List<dynamic>.from(budgetDetails.map((x) => x.toJson())),
        "date": date.toIso8601String(),
      };
}

class BudgetDetail {
  String id;
  double currentDay;
  double totalCost;

  BudgetDetail({
    required this.id,
    required this.currentDay,
    required this.totalCost,
  });

  factory BudgetDetail.fromJson(Map<String, dynamic> json) => BudgetDetail(
        id: json["_id"],
        currentDay: json["current_day"],
        totalCost: json["total_cost"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "current_day": currentDay,
        "total_cost": totalCost,
      };
}

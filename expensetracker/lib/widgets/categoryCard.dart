import 'package:expensetracker/models/category_model.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryCard extends StatefulWidget {
  CategoryCard(
      {super.key,
      required this.category,
      required this.editCategory,
      required this.deleteCategory});
  Category category;
  Function editCategory;
  Function deleteCategory;
  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE0E4F5), width: 3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(widget.category.emoji,
                        style: TextStyle(
                          fontSize: 30,
                        )),
                  ),
                  SizedBox(width: 12),
                  Text(widget.category.categoryName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3C3C3C),
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
              PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) async {
                  if (value == "Edit") {
                    widget.editCategory(widget.category);
                  } else if (value == "Delete") {
                    widget.deleteCategory(widget.category);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "Edit",
                    child: Text("Edit"),
                  ),
                  PopupMenuItem(
                    value: "Delete",
                    child: Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

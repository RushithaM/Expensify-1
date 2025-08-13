import 'package:expensetracker/models/category_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/screens/category/add_category.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/categoryCard.dart';
import 'package:flutter/material.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  bool isDeleteLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        toolbarHeight: 70,
        title: Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: Text(
            'All Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await catPro.getcategories(prefs!.getString("id")!);
            if (mounted) setState(() {});
          },
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      children: [
                        if (catPro.categories.length == 0 ||
                            catPro.categories
                                .every((element) => !element.active))
                          Center(
                            child: Text("No categories added yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3C3C3C),
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        for (int i = 0; i < catPro.categories.length; i++)
                          if (catPro.categories[i].active)
                            CategoryCard(
                                category: catPro.categories[i],
                                editCategory: (Category category) async {
                                  await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AddCategory(
                                      category: category,
                                      isEdit: true,
                                    );
                                  }));
                                  if (mounted) setState(() {});
                                },
                                deleteCategory: (Category category) async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, SetState) {
                                          return AlertDialog(
                                            title: Text("Delete Category"),
                                            content: Text(
                                              "Are you sure you want to delete this category?\nDeleting category won't delete past transactions!",
                                              style: TextStyle(
                                                  color: Color(0xFF3C3C3C)),
                                            ),
                                            actions: [
                                              if (isDeleteLoading)
                                                Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: appColor),
                                                )
                                              else
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: CancelButton(
                                                            "Cancel")),
                                                    InkWell(
                                                        onTap: () async {
                                                          SetState(() {
                                                            isDeleteLoading =
                                                                true;
                                                          });
                                                          var resp = await catPro
                                                              .deletecategory(
                                                                  category.id);
                                                          SetState(() {
                                                            isDeleteLoading =
                                                                false;
                                                          });
                                                          if (resp['message'] ==
                                                              'success') {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  "Category Deleted"),
                                                            ));
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  "Something went wrong"),
                                                            ));
                                                          }
                                                          if (mounted)
                                                            setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: AppButton(
                                                            "Delete")),
                                                  ],
                                                ),
                                            ],
                                          );
                                        });
                                      });
                                }),
                      ],
                    ));
              }),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: appColor,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddCategory(
                category: Category(
                    type: "",
                    active: true,
                    categoryName: "",
                    emoji: "",
                    id: "",
                    userId: "",
                    budget: 0.0),
                isEdit: false,
              );
            }));
            if (mounted) setState(() {});
          },
          child: Icon(Icons.add, size: 20, color: Colors.white),
          backgroundColor: appColor,
        ),
      ),
    );
  }
}

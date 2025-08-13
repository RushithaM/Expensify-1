import 'package:expensetracker/models/category_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/errorText.dart';
import 'package:flutter/material.dart';
import 'package:emoji_extension/emoji_extension.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AddCategory extends StatefulWidget {
  AddCategory({required this.category, required this.isEdit});
  bool isEdit;
  Category category;
  @override
  State<AddCategory> createState() => _AddCategoryState();
}

enum ExpenseType { option1, option2, option3 }

class _AddCategoryState extends State<AddCategory> {
  TextEditingController emojiController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  FocusNode emojiFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode budgetFocus = FocusNode();
  String emojiError = "";
  String nameError = "";
  String typeError = "";
  String budgetError = "";
  bool isLoading = false;
  ExpenseType? _selectedOption;

  void initState() {
    super.initState();
    if (widget.isEdit) {
      emojiController.text = widget.category.emoji;
      nameController.text = widget.category.categoryName;
      if (widget.category.budget != 0) {
        budgetController.text = widget.category.budget.toString();
      } else {
        budgetController.text = "";
      }
      _selectedOption = (widget.category.type == "Daily")
          ? ExpenseType.option1
          : (widget.category.type == "Weekly")
              ? ExpenseType.option2
              : (widget.category.type == "Monthly")
                  ? ExpenseType.option3
                  : null;
    }
    if (mounted) {
      setState(() {
        emojiError = "";
        nameError = "";
        typeError = "";
        budgetError = "";
      });
    }
  }

  var resp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        toolbarHeight: 70,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white)),
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
          child: Text(
            (widget.isEdit) ? 'Edit Category' : 'Add Category',
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  CircleAvatar(
                      backgroundColor: lightAppColor,
                      radius: 100,
                      child: TextFormField(
                        controller: emojiController,
                        style: TextStyle(fontSize: 120),
                        textAlign: TextAlign.center,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "🌝",
                          hintStyle: TextStyle(fontWeight: FontWeight.w100),
                          border: InputBorder.none,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: lightAppColor, width: 3),
                              borderRadius: BorderRadius.circular(8.0),
                              color: lightAppColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    String temp = value;
                                    if (value.length > 2) {
                                      temp = value.substring(
                                          value.length - 2, value.length);
                                    }
                                    if (Emojis.all
                                        .map((e) => e.value)
                                        .contains(temp)) {
                                      emojiController.text = temp;
                                    } else {
                                      emojiController.text = "";
                                    }
                                    if (emojiError.length != 0) {
                                      if (mounted)
                                        setState(() {
                                          emojiError = "";
                                        });
                                    }
                                  },
                                  controller: emojiController,
                                  focusNode: emojiFocus,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                    hintText: "Choose emoji",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ErrorText(emojiError),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: lightAppColor, width: 3),
                              borderRadius: BorderRadius.circular(8.0),
                              color: lightAppColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) {
                                    if (nameError.length != 0) {
                                      if (mounted)
                                        setState(() {
                                          nameError = "";
                                        });
                                    }
                                  },
                                  controller: nameController,
                                  focusNode: nameFocus,
                                  textAlign: TextAlign.center,
                                  textCapitalization: TextCapitalization.words,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(16)
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Choose name",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ErrorText(nameError),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: lightAppColor, width: 3),
                              borderRadius: BorderRadius.circular(8.0),
                              color: lightAppColor),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  onChanged: (value) {
                                    // if (budgetError.length != 0) {
                                    //   if (mounted)
                                    //     setState(() {
                                    //       budgetError = "";
                                    //     });
                                    // }
                                  },
                                  controller: budgetController,
                                  focusNode: budgetFocus,
                                  textAlign: TextAlign.center,
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(7)
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Monthly budget (opt)",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ErrorText(budgetError),
                        SizedBox(height: 20),
                        (_selectedOption == null)
                            ? Text(
                                "Select Expense Type (opt)",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: [
                                  Radio<ExpenseType>(
                                    value: ExpenseType.option1,
                                    groupValue: _selectedOption,
                                    onChanged: (ExpenseType? value) {
                                      if (mounted)
                                        setState(() {
                                          _selectedOption = value;
                                        });
                                      // if (typeError.length > 0) {
                                      //   if (mounted)
                                      //     setState(() {
                                      //       typeError = "";
                                      //     });
                                      // }
                                    },
                                  ),
                                  Text("Daily",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<ExpenseType>(
                                    value: ExpenseType.option2,
                                    groupValue: _selectedOption,
                                    onChanged: (ExpenseType? value) {
                                      if (mounted)
                                        setState(() {
                                          _selectedOption = value;
                                        });
                                      // if (typeError.length > 0) {
                                      //   if (mounted)
                                      //     setState(() {
                                      //       typeError = "";
                                      //     });
                                      // }
                                    },
                                  ),
                                  Text("Weekly",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<ExpenseType>(
                                    value: ExpenseType.option3,
                                    groupValue: _selectedOption,
                                    onChanged: (ExpenseType? value) {
                                      if (mounted)
                                        setState(() {
                                          _selectedOption = value;
                                        });
                                      // if (typeError.length > 0) {
                                      //   if (mounted)
                                      //     setState(() {
                                      //       typeError = "";
                                      //     });
                                      // }
                                    },
                                  ),
                                  Text("Monthly",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              )
                            ]),
                        ErrorText(typeError),
                        SizedBox(height: 30),
                        (isLoading)
                            ? CircularProgressIndicator(color: appColor)
                            : InkWell(
                                onTap: () async {
                                  emojiFocus.unfocus();
                                  nameFocus.unfocus();
                                  budgetFocus.unfocus();
                                  if (emojiController.text.length == 0) {
                                    if (mounted)
                                      setState(() {
                                        emojiError = "Select Emoji";
                                      });
                                    return;
                                  }
                                  if (nameController.text.trim().length == 0) {
                                    if (mounted)
                                      setState(() {
                                        nameError = "Enter name";
                                      });
                                    return;
                                  }
                                  // if (budgetController.text.trim().length ==
                                  //     0) {
                                  //   if (mounted)
                                  //     setState(() {
                                  //       budgetError = "Enter budget";
                                  //     });
                                  //   return;
                                  // }
                                  // if (_selectedOption == null) {
                                  //   if (mounted)
                                  //     setState(() {
                                  //       typeError = "Select type";
                                  //     });
                                  //   return;
                                  // }
                                  if (mounted)
                                    setState(() {
                                      isLoading = true;
                                    });
                                  if (widget.isEdit) {
                                    resp = await catPro.editcategory(
                                        widget.category.id,
                                        nameController.text.trim(),
                                        emojiController.text.trim(),
                                        prefs!.getString('id')!,
                                        (_selectedOption == ExpenseType.option1)
                                            ? "Daily"
                                            : (_selectedOption ==
                                                    ExpenseType.option2)
                                                ? "Weekly"
                                                : (_selectedOption ==
                                                        ExpenseType.option3)
                                                    ? "Monthly"
                                                    : "NA",
                                        budgetController.text.isEmpty
                                            ? 0.0
                                            : double.parse(
                                                budgetController.text));
                                  } else {
                                    resp = await catPro.addcategory(
                                        prefs!.getString('id')!,
                                        nameController.text.trim(),
                                        emojiController.text.trim(),
                                        budgetController.text.isEmpty
                                            ? 0.0
                                            : double.parse(
                                                budgetController.text,
                                              ),
                                        (_selectedOption == ExpenseType.option1)
                                            ? "Daily"
                                            : (_selectedOption ==
                                                    ExpenseType.option2)
                                                ? "Weekly"
                                                : (_selectedOption ==
                                                        ExpenseType.option3)
                                                    ? "Monthly"
                                                    : "NA");
                                  }
                                  if (mounted)
                                    setState(() {
                                      isLoading = false;
                                    });

                                  if (resp['message'] == 'success') {
                                    emojiController.text = "";
                                    nameController.text = "";
                                    budgetController.text = "";
                                    _selectedOption = null;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text((widget.isEdit)
                                            ? "Updated Successfully"
                                            : 'Added Successfully'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(resp['message']),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: InkWell(
                                    child: AppButton(
                                        (widget.isEdit) ? "Update" : "Add"))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

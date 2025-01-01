import 'package:expensetracker/models/category_model.dart';
import 'package:expensetracker/models/transaction_model.dart';
import 'package:expensetracker/providers/globals.dart';
import 'package:expensetracker/screens/category/add_category.dart';
import 'package:expensetracker/styles/styles.dart';
import 'package:expensetracker/widgets/errorText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AddTransactionPage extends StatefulWidget {
  AddTransactionPage(
      {required this.transaction,
      required this.isEdit,
      required this.i,
      required this.j});
  Transaction transaction;
  bool isEdit;
  int i;
  int j;

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

enum Options { option1, option2 }

class _AddTransactionPageState extends State<AddTransactionPage> {
  Options? _selectedOption;
  Category? selectedCategory;
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode amountFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  String categoryError = "";
  String typeError = "";
  String amountError = "";
  String descriptionError = "";
  bool isLoading = false;

  var resp;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      selectedCategory = catPro.categories
          .firstWhere((element) => element.id == widget.transaction.categoryId);
      amountController.text = widget.transaction.amount.toString();
      descriptionController.text = widget.transaction.description;
      if (widget.transaction.type == "debit") {
        _selectedOption = Options.option1;
      } else {
        _selectedOption = Options.option2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        toolbarHeight: 70,
        leading: (widget.isEdit)
            ? InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              )
            : null,
        title: Padding(
          padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: Text(
            (widget.isEdit) ? "Edit Transaction" : 'Add Transaction',
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
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Choose Category",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),

                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    if (catPro.categories.length == 0 ||
                        catPro.categories
                            .every((element) => element.active == false)) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("No Categories"),
                              content:
                                  Text("Please add a category to continue"),
                              actions: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: CancelButton("Cancel"),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () async {
                                            Navigator.pop(context);
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCategory(
                                                          isEdit: false,
                                                          category: Category(
                                                              active: true,
                                                              categoryName: "",
                                                              id: "",
                                                              userId: "",
                                                              emoji: ""),
                                                        )));
                                            if (mounted) setState(() {});
                                          },
                                          child: AppButton("Add"),
                                        ),
                                      )
                                    ])
                              ],
                            );
                          });
                    }
                    return;
                  },
                  child: Container(
                    child: DropdownButtonFormField<String>(
                        value: (selectedCategory != null)
                            ? selectedCategory!.categoryName
                            : null,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            selectedCategory = catPro.categories.firstWhere(
                                (category) =>
                                    category.categoryName == newValue);
                          }
                          if (selectedCategory != null) {
                            if (mounted)
                              setState(() {
                                categoryError = "";
                              });
                          }
                        },
                        hint: const Text(
                          "Select one",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8))),
                        icon: Transform.rotate(
                            angle: 3.14 / 2,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 20,
                            )),
                        items: catPro.categories
                            .where((category) => category.active)
                            .map((category) => category.categoryName)
                            .toList()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()),
                  ),
                ),
                ErrorText(categoryError),
                SizedBox(height: 20),
                Text("Type",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Radio<Options>(
                            value: Options.option1,
                            groupValue: _selectedOption,
                            onChanged: (Options? value) {
                              if (mounted)
                                setState(() {
                                  _selectedOption = value;
                                });
                              if (typeError.length > 0) {
                                if (mounted)
                                  setState(() {
                                    typeError = "";
                                  });
                              }
                            },
                          ),
                          Text("Debit",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3C3C3C),
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          Radio<Options>(
                            value: Options.option2,
                            groupValue: _selectedOption,
                            onChanged: (Options? value) {
                              if (mounted)
                                setState(() {
                                  _selectedOption = value;
                                });
                              if (typeError.length > 0) {
                                if (mounted)
                                  setState(() {
                                    typeError = "";
                                  });
                              }
                            },
                          ),
                          Text("Credit",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3C3C3C),
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      )
                    ]),
                ErrorText(typeError),
                // SizedBox(height: 20),
                // Text("Date",
                //     style: TextStyle(
                //       fontSize: 16,
                //       color: Color(0xFF3C3C3C),
                //       fontWeight: FontWeight.w500,
                //     )),
                // SizedBox(height: 10),
                // Container(
                //   color: lightAppColor,
                //   child: TextFormField(
                //     onTap: () async {
                //       DateTime? date = await showDatePicker(
                //         context: context,
                //         initialDate: DateTime.now(),
                //         firstDate: DateTime(2000),
                //         lastDate: DateTime(2025),
                //       );
                //       if (date != null)
                //         dateController.text = date.toString().substring(0, 10);
                //     },
                //     readOnly: true,
                //     controller: dateController,
                //     decoration: InputDecoration(
                //       hintText: "Select Date",
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Colors.black,
                //           width: 1,
                //         ),
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       suffixIcon: Icon(Icons.calendar_today),
                //     ),
                //   ),
                // ),
                SizedBox(height: 20),
                Text("Amount",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                Container(
                  child: TextFormField(
                    onChanged: (value) {
                      if (amountError.length > 0) {
                        if (mounted)
                          setState(() {
                            amountError = "";
                          });
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]*\.?[0-9]*$')),
                    ],
                    controller: amountController,
                    focusNode: amountFocus,
                    decoration: InputDecoration(
                      hintText: "Enter Amount",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                ErrorText(amountError),
                SizedBox(height: 20),
                Text("Description",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C3C3C),
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 10),
                Container(
                  child: TextFormField(
                    onChanged: (value) {
                      if (descriptionError.length > 0) {
                        if (mounted)
                          setState(() {
                            descriptionError = "";
                          });
                      }
                    },
                    controller: descriptionController,
                    focusNode: descriptionFocus,
                    inputFormatters: [LengthLimitingTextInputFormatter(40)],
                    decoration: InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                ErrorText(descriptionError),
                SizedBox(height: 20),
                (isLoading)
                    ? Center(child: CircularProgressIndicator(color: appColor))
                    : Center(
                        child: InkWell(
                            onTap: () async {
                              amountFocus.unfocus();
                              descriptionFocus.unfocus();
                              if (selectedCategory == null) {
                                if (mounted)
                                  setState(() {
                                    categoryError = "Select category";
                                  });
                                return;
                              }
                              if (_selectedOption == null) {
                                if (mounted)
                                  setState(() {
                                    typeError = "Select type";
                                  });
                                return;
                              }
                              if (amountController.text.trim().length == 0 ||
                                  double.parse(amountController.text.trim()) ==
                                      0) {
                                if (mounted)
                                  setState(() {
                                    amountError = "Enter amount";
                                  });
                                return;
                              }
                              if (double.parse(amountController.text.trim()) >
                                  10000000) {
                                if (mounted)
                                  setState(() {
                                    amountError =
                                        "Should be less than 1,00,00,000";
                                  });
                                return;
                              }
                              if (double.parse(amountController.text.trim()) +
                                      totalAmount >
                                  99999999) {
                                if (mounted)
                                  setState(() {
                                    amountError =
                                        "Total balance should be less than 10,00,00,000";
                                  });
                                return;
                              }
                              if (descriptionController.text.trim().length ==
                                  0) {
                                if (mounted)
                                  setState(() {
                                    descriptionError = "Enter Description";
                                  });
                                return;
                              }
                              if (mounted)
                                setState(() {
                                  isLoading = true;
                                });
                              if (!widget.isEdit) {
                                resp = await transPro.addTransaction(
                                    prefs!.getString('id')!,
                                    selectedCategory!.id,
                                    double.parse(amountController.text.trim()),
                                    descriptionController.text.trim(),
                                    (_selectedOption == Options.option1)
                                        ? "debit"
                                        : 'credit');
                              } else {
                                resp = await transPro.editTransaction(
                                    widget.transaction.id,
                                    selectedCategory!.id,
                                    double.parse(amountController.text.trim()),
                                    prefs!.getString('id')!,
                                    descriptionController.text.trim(),
                                    (_selectedOption == Options.option1)
                                        ? "debit"
                                        : 'credit',
                                    widget.i,
                                    widget.j);
                              }
                              if (mounted)
                                setState(() {
                                  isLoading = false;
                                });
                              if (resp['message'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${(widget.isEdit) ? "Updated" : "Added"} Successfully"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                amountController.text = "";
                                descriptionController.text = "";
                                selectedCategory = null;
                                _selectedOption = null;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(resp['message']),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                              if (widget.isEdit) {
                                Navigator.pop(context);
                              }
                            },
                            child:
                                AppButton((widget.isEdit) ? "Update" : "Save")),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

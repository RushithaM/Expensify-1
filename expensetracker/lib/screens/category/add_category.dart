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

class _AddCategoryState extends State<AddCategory> {
  TextEditingController emojiController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FocusNode emojiFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  String emojiError = "";
  String nameError = "";
  bool isLoading = false;

  void initState() {
    super.initState();
    if (widget.isEdit) {
      emojiController.text = widget.category.emoji;
      nameController.text = widget.category.categoryName;
    }
    if (mounted) {
      setState(() {
        emojiError = "";
        nameError = "";
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
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
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
                                    LengthLimitingTextInputFormatter(20)
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
                        SizedBox(height: 50),
                        (isLoading)
                            ? CircularProgressIndicator(color: appColor)
                            : InkWell(
                                onTap: () async {
                                  emojiFocus.unfocus();
                                  nameFocus.unfocus();
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
                                  if (mounted)
                                    setState(() {
                                      isLoading = true;
                                    });
                                  if (widget.isEdit) {
                                    resp = await catPro.editcategory(
                                        widget.category.id,
                                        nameController.text.trim(),
                                        emojiController.text.trim(),
                                        prefs!.getString('id')!);
                                  } else {
                                    resp = await catPro.addcategory(
                                        prefs!.getString('id')!,
                                        nameController.text.trim(),
                                        emojiController.text.trim());
                                  }
                                  if (mounted)
                                    setState(() {
                                      isLoading = false;
                                    });

                                  if (resp['message'] == 'success') {
                                    emojiController.text = "";
                                    nameController.text = "";
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

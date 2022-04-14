// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:to_do_app/models/my_color.dart';
import 'package:to_do_app/models/my_color_name.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:fluttertoast/fluttertoast.dart';

const double corner_radius = 10.0;

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ColorName? selectedColorName;
  int? selectedColor;
  TextEditingController edit_title = TextEditingController();
  List<MyToDoModel> todoList = [];

  final List<MyColorModel> listOfColors = [
    MyColorModel(0xFF219653, ColorName.GREEN),
    MyColorModel(0xFFEB5757, ColorName.RED),
    MyColorModel(0xFFF2C94C, ColorName.YELLOW),
    MyColorModel(0xFF2F80ED, ColorName.BLUE),
    MyColorModel(0xFFF2994A, ColorName.ORANGE),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To do app',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Container(
        color: Color(0xFFFAFAFA),
        padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: getListData()),
            SizedBox(
              height: 4.0,
            ),
            Container(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(listOfColors.length, (index) {
                  return customRadioBtn(
                      listOfColors[index].colorName, listOfColors[index].color);
                }),
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Container(
                height: 40.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: TextFormField(
                          controller: edit_title,
                          maxLines: 1,
                          // textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(corner_radius),
                                bottomLeft: Radius.circular(corner_radius),
                              ),
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              bottom: 0.0,
                              top: 0.0,
                            ),
                            hintText: "Enter the title...",
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF333333),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(corner_radius),
                              bottomRight: Radius.circular(corner_radius),
                            )),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                addNewToDo(edit_title.text);
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget customRadioBtn(ColorName colorName, int circleColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColorName = colorName;
          selectedColor = circleColor;
        });
      },
      child: Container(
        width: selectedColorName == colorName ? 50 : 40,
        height: selectedColorName == colorName ? 50 : 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(circleColor),
        ),
      ),
    );
  }

  Widget itemToDo(BuildContext context, int index) {
    int selectedColor = todoList[index].color;
    String title = todoList[index].title;

    return Container(
      child: Card(
        elevation: 0.0,
        color: Color(0xFFEEEEEE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(corner_radius),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 12.0),
                    Container(
                      width: 15.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                        color: Color(selectedColor),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    SizedBox(width: 22.0),
                    Expanded(child: Text(title)),
                  ],
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    color: Color(0xFF6FB88E),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(corner_radius),
                      bottomRight: Radius.circular(corner_radius),
                    )),
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      todoList.removeAt(index);
                    });
                  },
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ), // Container
      ),
    );
  }

  void addNewToDo(String title) {
    if (selectedColorName == null) {
      createErrorToast("Choose a color!");
    } else if (title.isEmpty) {
      createErrorToast("Enter the text!");
    } else {
      MyToDoModel todo = MyToDoModel(selectedColor!, title);
      todoList.insert(0, todo);
      edit_title.clear();
    }
  }

  void createErrorToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Color(0xFFF44336),
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT);
  }

  Widget getListData() {
    if (todoList.isEmpty) {
      return Center(
        child: Text(
          "List is empty",
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 18.0,
          ),
        ),
      );
    }

    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 12.0),
        itemCount: todoList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) =>
            itemToDo(context, index),
      ),
    );
  }
}

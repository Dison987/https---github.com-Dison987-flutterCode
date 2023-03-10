import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

final List<String> items = [
  'Beginner',
  'Advanced',
  'Intermediate',
];

String? selectedValue = items.first;

List<String> itemLang = [];

String? selectedLanguage;

class editLanguagePage extends StatefulWidget {
  // const editLanguagePage({super.key});
  final int id;
  editLanguagePage({required this.id});

  @override
  State<editLanguagePage> createState() => _editLanguagePageState();
}

class _editLanguagePageState extends State<editLanguagePage> {
  late FocusNode myFocusNode;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController languageName = TextEditingController();
  TextEditingController languageProfiency = TextEditingController();

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    getLanguage();
    print(itemLang);
    print("ITEMS FIRST");
    print(items.first);
    languageProfiency.text = items.first;
    selectedValue = items.first;
    // print("ItemLANG");
    // print(itemLang);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: AppBar(
                      title: Text('Language'),
                      centerTitle: true,
                      backgroundColor: Colors.grey[700],
                      elevation: 0,
                    ),
                  ),
                  //Title

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ListTile(
                      leading: Icon(Icons.lightbulb),
                      title: Text(
                        'Languages',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //languages
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Text(
                      'Languages',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: SizedBox(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        menuMaxHeight: 200.0,
                        value: selectedLanguage,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedLanguage = value!;
                            languageName.text = selectedLanguage.toString();
                          });
                        },
                        items: itemLang
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  //optimized language's API:
                  //-when selected language name from dropdown gets its id

                  //Profiency
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Text(
                      'Profiency',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: SizedBox(
                      child: DropdownButton<String>(
                        hint: Text("Profiency"),
                        isExpanded: true,
                        menuMaxHeight: 200.0,
                        value: selectedValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedValue = value!;
                            languageProfiency.text = selectedValue.toString();
                          });
                        },
                        items:
                            items.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  //BUTTON
                  TextButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(languageName.text);
                        print(languageProfiency.text);
                        editLanguage(widget.id);
                        // getLanguage();
                        print("done");
                        popup();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  //language function
  void popup() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Languages Edited !"),
              content: Row(
                children: [
                  Icon(Icons.check, color: Colors.green),
                  SizedBox(width: 8.0),
                  Text("Language is changed !"),
                ],
              ),
              actions: [
                TextButton(
                    child: Text('Ok'),
                    onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
              ],
            ));
  }

//Language Function
  Future<void> editLanguage(var languageID) async {
    print("THIS IS LANGUAGE ID");
    print(languageID);
    var getLangTypeID =
        await http.post(Uri.parse("http://10.0.2.2:8080/langTypeID"),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
            },
            body: jsonEncode({'language_name': languageName.text}));

    if (getLangTypeID.statusCode == 200) {
      print("Success");
      print(getLangTypeID.body);
    } else
      print("WRONG");
    Map<String, dynamic> map2 = jsonDecode(getLangTypeID.body);
    print(map2['language_type_id']);
    var langTypeID = map2['language_type_id'];

    var getLangProfID = await http.post(
        Uri.parse("http://10.0.2.2:8080/langProfID"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body:
            jsonEncode({'language_proficient_level': languageProfiency.text}));

    if (getLangProfID.statusCode == 200) {
      print("Success");
      print(getLangProfID.body);
    } else
      print("WRONG");
    Map<String, dynamic> map = jsonDecode(getLangProfID.body);
    print(map['language_proficient_id']);
    var langProfID = map['language_proficient_id'];
    print("THIS IS langProfID");
    print(langProfID);

    var response3 = await http.post(Uri.parse("http://10.0.2.2:8080/editLang"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode({
          "language_id": languageID,
          "language_type_id": langTypeID,
          "language_proficient_id": langProfID,
        }));

    if (response3.statusCode == 200) {
      print("nice");
    } else
      print("Invalid controller");
  }

  Future<void> getLanguage() async {
    var response = await http.get(
      Uri.parse("http://10.0.2.2:8080/Languages"),
    );
    if (response.statusCode == 200) {
      print("Success");
      print(response.body);

      List list = jsonDecode(response.body);
      List<String> temp = [];
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> map = list[i];
        print(map["language_name"]);

        temp.add(map["language_name"]);
      }
      setState(() {
        itemLang.clear();
        itemLang.addAll(temp);
        selectedLanguage = itemLang.first;
        languageName.text = itemLang.first;
      });
    } else
      print("failed");

    print("done response body");
  }
}

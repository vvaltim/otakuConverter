import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=fb6cbde5";
//Parei na aula 60

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.deepPurpleAccent,
        primaryColor: Colors.deepPurple,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)))),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Otaku Conversor"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando dados...",
                  style:
                      TextStyle(color: Colors.deepPurpleAccent, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar dados :/",
                    style: TextStyle(
                        color: Colors.deepPurpleAccent, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.asset(
                        "images/money.png",
                      ),
                      Divider(),
                      _builderTextView(
                          "Reais", "R\$", realController, _realChanged),
                      Divider(),
                      _builderTextView(
                          "Dolares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      _builderTextView(
                          "Euros", "€", euroController, _euroChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget _builderTextView(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    onChanged: f,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepPurpleAccent),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 25.0),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
//  print(json.decode(response.body)["results"]["currencies"]["USD"]);
}

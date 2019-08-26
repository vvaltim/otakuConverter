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
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
        )
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dolar;
  double euro;

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
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(
                            color: Colors.deepPurpleAccent
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "R\$"
                        ),
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 25.0
                        ),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Dolares",
                            labelStyle: TextStyle(
                                color: Colors.deepPurpleAccent
                            ),
                            border: OutlineInputBorder(),
                            prefixText: "US"
                        ),
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 25.0
                        ),
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                            labelText: "Euros",
                            labelStyle: TextStyle(
                                color: Colors.deepPurpleAccent
                            ),
                            border: OutlineInputBorder(),
                            prefixText: "€"
                        ),
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 25.0
                        ),
                      )
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

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
//  print(json.decode(response.body)["results"]["currencies"]["USD"]);
}

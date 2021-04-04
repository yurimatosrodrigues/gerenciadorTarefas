import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Home> {
  List _toDoList = [];
  TextEditingController _tarefaController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _readTarefa().then((data){
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addTarefa() {
    setState(() {
      Map<String, dynamic> newToDo = new Map();
      newToDo["title"] = _tarefaController.text;
      newToDo["ok"] = false;
      _tarefaController.text = "";
      _toDoList.add(newToDo);
      _saveTarefa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _tarefaController,
                    decoration: InputDecoration(
                        labelText: "Nova tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                  child: Text("ADD"),
                  onPressed: _addTarefa,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_toDoList[index]["title"]),
                    value: _toDoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(
                          _toDoList[index]["ok"] ? Icons.check : Icons.error),
                    ),
                    onChanged: (click){
                      setState(() {
                        _toDoList[index]["ok"] = click;
                        _saveTarefa();
                      });
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/tarefas.json");
  }

  Future<File> _saveTarefa() async {
    String data = json.encode(_toDoList);
    File file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readTarefa() async {
    File file = await _getFile();
    return file.readAsString();
  }
}

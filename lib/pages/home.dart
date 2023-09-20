import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avanzado1/models/band.dart';
import 'package:flutter_avanzado1/services/socket_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Linkin Park', votes: 5),
    // Band(id: '2', name: 'The Script', votes: 8),
    // Band(id: '3', name: 'Soda Estereo', votes: 9),
    // Band(id: '4', name: 'Coldplay', votes: 7),
  ];
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', (payload) {
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.online)
                  ? Icon(Icons.check_circle, color: Colors.blue[300])
                  : const Icon(
                      Icons.offline_bolt,
                      color: Colors.red,
                    )) //Hacemos este ternario para cuando esta conectado estara azul, de caso contrario,rojo
        ],
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) => _bandTile(bands[i])
          //_bandTile es un metodo que extraje y se hace mas corto y comodo el codigo
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //Todo: llamar el borrado en el server
      },
      background: Container(
          padding: const EdgeInsets.only(left: 8.0),
          color: Colors.red,
          child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Delte Band',
                style: TextStyle(color: Colors.white),
              ))),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {},
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      //Android
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('New Band Name'),
              content: TextField(
                controller: textController,
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () => addBandToList(textController.text),
                  elevation: 5,
                  textColor: Colors.blue,
                  child: const Text('add'),
                )
              ],
            );
          });
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('New band name: '),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => addBandToList(textController.text),
              child: const Text('Add'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Dismiss'),
            ),
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}

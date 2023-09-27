import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart'
    as io; //siempre usar en minuscula

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  final io.Socket _socket = io.io('http://192.168.100.223:3000', {
    'transports': ['websockets'],
    'autoConnect': true
  });

  ServerStatus _serverStatus = ServerStatus.connecting;

  Function get emit => _socket
      .emit; // Haciendo esto podemos utilizarlo en status.dart para emitir

  ServerStatus get serverStatus =>
      _serverStatus; //Hacemos esto para evitar que serverStatus sea dynamics

  io.Socket get socket => _socket;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      socket.emit('mensaje', 'test');
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   debugPrint('nuevo-mensaje: ');
    //   debugPrint('nombre :   ${payload['nombre']}');
    //   debugPrint('mensaje:   ${payload['mensaje']}');
    //   debugPrint(
    //       payload.contaisKey('mensaje2') ? payload('mensaje2') : 'no hay');
    // });
  } //Esto es lo que necesito para conectarme y ver toda la informacion
}

import 'dart:convert';
import 'dart:core';
import 'package:dbsync_app/Model/NameModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';

import '../database_helper.dart';

class SendNameProvider with ChangeNotifier {
  String url = '192.168.1.72';
  List<NameModel> _items = [];
  final dbHelper = DatabaseHelper.instance;
  List<NameModel> get items {
    return [..._items];
  }

  Future<void> addName(text, _connectionStatus) async {
    print(text.toString());
    int status = 1;
    print(_connectionStatus.toString());
    try {
      if (_connectionStatus == true) {
        Response response = await Dio().post(
          'http://$url/SqliteSync/saveName.php',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(
              <String, dynamic>{"name": text.toString(), "status": status}),
        );
        if (response.statusCode == 200) {
          String body = response.statusMessage;
          print(body);
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: text.toString(),
            DatabaseHelper.status: 1,
          };
          await dbHelper.insert(row);
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } else {
        Map<String, dynamic> row = {
          DatabaseHelper.columnName: text.toString(),
          DatabaseHelper.status: 0,
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> sync(text, _connectionStatus) async {
    print(text.toString());
    int a = 1;
    print(_connectionStatus.toString());
    try {
      if (_connectionStatus == true) {
        Response response = await Dio().post(
          'http://$url/SqliteSync/saveName.php',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(
              <String, dynamic>{"name": text.toString(), "status": a}),
        );
        if (response.statusCode == 200) {
          String body = response.statusMessage;
          print(body);
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } else {}

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}

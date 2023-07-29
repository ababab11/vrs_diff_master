import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:vrs_diff_master/function/hasher.dart';

import '../function/getDate.dart';
import '../function/writeArrayToFile.dart';

class ChangeExtractor extends StatefulWidget {

  final List<FileSystemEntity> csvFilesA;
  final List<FileSystemEntity> csvFilesB;
  ChangeExtractor({required this.csvFilesA,required this.csvFilesB});

  @override
  State<ChangeExtractor> createState() => _ChangeExtractorState();
}



class _ChangeExtractorState extends State<ChangeExtractor> {
  double valueOfProgress = 0.0;
  bool processingComplete = false;  // フラグを追加
  String date = "";  //日
  Directory currentDirectory = Directory.current;
  int denominator = 0;  //分母
  int numerator = 0; //分子
  Map<String, String> hash = {};
  List<String> outputArray = []; //書き出し用配列
  String filename = "";
  int count = 0 ;//抽出対象件数



  void initState() {
    super.initState();
    firstDo();
  }
  Future<void> firstDo() async {
    valueOfProgress = 0.0;
    String directoryPath = currentDirectory.path;
    date = GetDate.getCurrentDateTime();
    filename = date +"【hennkou分】.csv";
    denominator = getCsvFilesCount(); //分母取得
    hash = await createCsvMap(widget.csvFilesA);
    printHashTable(hash);
    outputArray = await compareAndWriteChanges(hash,widget.csvFilesB);
    await FileWriter.writeArrayToFile(outputArray,directoryPath, filename);

    numerator = numerator + 1;
    updateProgress(denominator,numerator);

    /////////ここから後処理
    hash = {}; //初期化
    outputArray = []; //書き出し用配列初期化
    processingComplete = true;  // 処理が終わったらフラグを真にす
  }

  int getCsvFilesCount() {
    return widget.csvFilesA.length + widget.csvFilesB.length +1 ;
  }

  Future<Map<String, String>> createCsvMap(List<FileSystemEntity> csvFiles) async {
    Map<String, String> csvMap = {};

    for (var file in csvFiles) {
      String csvContent = await File(file.path).readAsString();
      List<List<dynamic>> csvRows = CsvToListConverter().convert(csvContent);

      for (var row in csvRows) {
        String key = row[0].toString(); // キャストは不要

        String value = Hasher.hashStringTo128Bit(row[0].toString()); // 値のキャストが必要
        csvMap[key] = value;
      }
      numerator = numerator + 1;
      updateProgress(denominator,numerator);

    }

    return csvMap;
  }

  void printHashTable(Map<String, String> hashMap) {
    int count = 0;
    for (var entry in hashMap.entries) {
      print('${entry.key}: ${entry.value}');
      count++;
      if (count >= 10) {
        break; // 10個までの表示に制限
      }
    }
  }

  void updateProgress(int denominator, int numerator) {
    setState(() {
      valueOfProgress = denominator > 0 ? numerator / denominator : 0.0;
    });}

  Future<List<String>> compareAndWriteChanges(Map<String, String> hash, List<FileSystemEntity> csvFilesB) async {
    List<String> outputArray = [];

    for (var file in csvFilesB) {
      String csvContent = await File(file.path).readAsString();
      List<List<dynamic>> csvRows = CsvToListConverter().convert(csvContent);

      for (var row in csvRows) {
        String key = row[0].toString();
        String? value = hash[key];

        if (value != null && value != Hasher.hashStringTo128Bit(row.toString())) {
          // ハッシュの値と行を比較し、違う場合は書き込み用配列に追加
          outputArray.add(csvContent);
          count = count +1;
        }
      }
      numerator = numerator + 1;
      updateProgress(denominator,numerator);
    }

    return outputArray;
  }


  @override
  Widget build(BuildContext context) {

    if (processingComplete) {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Processing Completed'),
              content:  Text(currentDirectory.path+"\\\nに"+filename+"のファイル名で保存しました(対象は"+count.toString()+"件)"),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });}

    return  LinearProgressIndicator(
      value: valueOfProgress,
    );
  }
}

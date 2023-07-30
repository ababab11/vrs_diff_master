import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vrs_diff_master/function/getDate.dart';
import 'package:csv/csv.dart';

import '../function/writeArrayToFile.dart';

class FindDeletedPersonalNumbers extends StatefulWidget {
  //const FindDeletedPersonalNumbers({super.key});
  final List<FileSystemEntity> csvFilesA;
  final List<FileSystemEntity> csvFilesB;
  const FindDeletedPersonalNumbers({super.key, required this.csvFilesA,required this.csvFilesB});

  @override
  State<FindDeletedPersonalNumbers> createState() => _FindDeletedPersonalNumbersState();
}

class _FindDeletedPersonalNumbersState extends State<FindDeletedPersonalNumbers> {
  double valueOfProgress = 0.0;
  bool processingComplete = false;  // フラグを追加
  String date = "";  //日
  Directory currentDirectory = Directory.current;
  int denominator = 0;  //分母
  int numerator = 0; //分子
  Map<String, int> hash = {};
  List<String> outputArray = []; //書き出し用配列
  String filename = "";
  int count = 0 ;//抽出対象件数



  @override
  void initState() {
    super.initState();
    firstDo();
  }
  Future<void> firstDo() async {
    valueOfProgress = 0.0;
    date = GetDate.getCurrentDateTime();
    filename = "$date【削除個人識別番号分】.csv";
    denominator = getCsvFilesCount(); //分母取得
    String directoryPath = currentDirectory.path;
    await processCsvFiles(widget.csvFilesB); //ハッシュ作成


    ///////////////////ここから追加
    await processAndCompareCsvFiles(widget.csvFilesA);
    await FileWriter.writeArrayToFile(outputArray,directoryPath, filename);
    numerator = numerator + 1;
    updateProgress(numerator, numerator);

    /////////ここから後処理
    hash = {}; //初期化
    outputArray = []; //書き出し用配列初期化
    processingComplete = true;  // 処理が終わったらフラグを真にする



  }

  int getCsvFilesCount() {
    return widget.csvFilesA.length + widget.csvFilesB.length ;
  }

  void updateProgress(int denominator, int numerator) {
    setState(() {
      valueOfProgress = denominator > 0 ? numerator / denominator : 0.0;
    });}

  Future<void> processCsvFiles(List<FileSystemEntity> csvFiles) async {  //ファイルAをハッシュに入れる
    for (var file in csvFiles) {
      final input = new File(file.path).openRead();
      final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();

      for (var row in fields) {
        String key = row[0].toString();
        hash[key] = 1;
      }
      numerator = numerator +1;
      updateProgress(getCsvFilesCount()+1, numerator);
    }

  }


  Future<void> processAndCompareCsvFiles(List<FileSystemEntity> csvFiles) async {//ファイルAを読み、存在しなければ書き出し用配列に入れる
    for (var file in csvFiles) {
      print("hhhh");
      final input = File(file.path).openRead();
      final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();

      for (var row in fields) {
        String key = row[0].toString();
        if (hash.containsKey(key) == false) {
          outputArray.add(row.join(",")); // Assuming row is List<String>, join elements with a comma
          count = count +1;
        }
      }
      numerator = numerator +1;
      updateProgress(getCsvFilesCount()+1, numerator);

    }
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
              content:  Text("${currentDirectory.path}\\\nに$filenameのファイル名で保存しました(対象は$count件)"),
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

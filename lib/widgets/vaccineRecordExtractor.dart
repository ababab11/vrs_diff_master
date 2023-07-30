import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vrs_diff_master/function/writeArrayToFile.dart';
import 'package:csv/csv.dart';

import '../function/countColumnsInFirstFile.dart';
import '../function/getDate.dart';

class VaccineRecordExtractor extends StatefulWidget {
  final List<FileSystemEntity> csvFilesA;
  final List<FileSystemEntity> csvFilesB;
  VaccineRecordExtractor({required this.csvFilesA, required this.csvFilesB});

  @override
  State<VaccineRecordExtractor> createState() => _VaccineRecordExtractorState();
}

class _VaccineRecordExtractorState extends State<VaccineRecordExtractor> {
  double valueOfProgress = 0.0;
  bool processingComplete = false;  // フラグを追加
  String date = "";  //日
  Directory currentDirectory = Directory.current;
  int denominator = 0;  //分母
  int numerator = 0; //分子
  Map<String, String> resultMapA = {}; // 正しいハッシュテーブルの宣言
  List<String> outputArray = []; //書き出し用配列
  String filename = "";
  int count = 0 ;//抽出対象件数
  int vaccineRecordIndexOld = 0;//何回目まで記録されているか（古い方のデータ）
  int vaccineRecordIndexNew = 0;//何回目まで記録されているか（新しい方のデータ）
  late Directory directoryPath;

  @override
  void initState() {
    super.initState();
    firstDo();
  }

  Future<void> firstDo() async {
    valueOfProgress = 0.0;
    date = GetDate.getCurrentDateTime();
    filename = date + "【接種記録が削除されている分】.csv";
    denominator = getCsvFilesCount(); // 分母取得
    // String directoryPath = currentDirectory.path; // この行を削除
    directoryPath = currentDirectory;
    //まず時期による差分をなくす　,　の数をそろえる
    vaccineRecordIndexOld = await FileColumnCounter.countColumnsInFirstFile(widget.csvFilesA) as int;
    vaccineRecordIndexNew = await FileColumnCounter.countColumnsInFirstFile(widget.csvFilesB) as int;
    resultMapA = await _createHashTable(widget.csvFilesA, vaccineRecordIndexOld);
    await _hikakuAndWrite(widget.csvFilesB, vaccineRecordIndexOld);

    resultMapA = {}; //初期化
    outputArray = []; //書き出し用配列初期化
    processingComplete = true;  // 処理が終わったらフラグを真にする
  }


  int getCsvFilesCount() {
    return widget.csvFilesA.length + widget.csvFilesB.length ;
  }

  void updateProgress(int denominator, int numerator) {
    setState(() {
      valueOfProgress = denominator > 0 ? numerator / denominator : 0.0;
    });
  }

  Future<Map<String, String>> _createHashTable(List<FileSystemEntity> csvFilesA, int n) async {
    Map<String, String> hashTable = {};

    for (var file in csvFilesA) {
      final csvContent = await File(file.path).readAsString();
      final csvRows = const CsvToListConverter().convert(csvContent);

      for (var row in csvRows) {
        if (row.length >= 3) {
          final key = row[0].toString();
          var value = ""; // 値を空の文字列として初期化

          if (n == 1) {
            // 3列目の値を文字列に連結
            value = _parseValue(row[2]);
          } else if (n >= 2) {
            // 3 + (n * 8) 列目までの値を合計して文字列に連結
            final sumValue = StringBuffer();
            for (int i = 0; i < n; i++) {
              value = _parseValue(row[2 + i * 8]);
              sumValue.write(value);
            }
            value = sumValue.toString();
          }

          // 正しくハッシュテーブルに値を追加
          hashTable[key] = value; // 値はすでにString型なのでそのまま代入
        }
      }
      numerator = numerator + 1;
      updateProgress(getCsvFilesCount() + 1, numerator);
    }

    return hashTable;
  }

  String _parseValue(dynamic value) {
    // NULLかどうかを判定し、"1"または"0"を返す
    return (value == "") ? "0" : "1";
  }

  Future<void> _hikakuAndWrite(List<FileSystemEntity> csvFilesB, int n) async {
    String key = "";
    List<String> valuesList = []; // 値をListで蓄積
    int mycount = 0;

    // 順番にCSVファイルを読み込む
    for (var file in csvFilesB) {
      final csvContent = await File(file.path).readAsString();
      final csvRows = const CsvToListConverter().convert(csvContent);

      for (var row in csvRows) {
        key = row[0].toString();
        if (row.length >= 3) {
          // 値をListに追加
          List<String> values = [];
          for (int i = 0; i < n; i++) {
            values.add(_parseValue(row[2 + i * 8]));
          }
          valuesList.add(values.join()); // Listを文字列に結合して追加
          _updateCombination(resultMapA, key, values.join(), row.toString());
        }
        mycount = mycount + 1;
        // if (mycount % 1000 == 0) {
        //   print(mycount.toString());
        // }
      }
      numerator = numerator + 1;
      updateProgress(getCsvFilesCount() + 1, numerator);
    }

    await FileWriter.writeArrayToFile(outputArray, currentDirectory.path, filename);
    numerator = numerator + 1;
    updateProgress(getCsvFilesCount() + 1, numerator);
  }


  void _updateCombination(Map<String, String> dataMap, String stringA, String stringB, String additionalString) {
    String? valueA = dataMap[stringA];

    if (valueA == null || valueA.length != stringB.length) {
      // 無効な組み合わせの場合は処理を終了
      return;
    }

    bool isExtracted = false;

    for (int i = 0; i < valueA.length; i++) {
      if (valueA[i] == '1' && stringB[i] == '0') {
        isExtracted = true;
        break;
      }
    }

    if (isExtracted) {
      // 抽出対象なら書き込み用配列に追加
      outputArray.add(additionalString);
      count = count +1;
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
              content:  Text(currentDirectory.path+"\\\nに" + filename + "のファイル名で保存しました(対象は"+count.toString()+"件)"),
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
      });
    }

    return  LinearProgressIndicator(
      value: valueOfProgress,
    );
  }
}


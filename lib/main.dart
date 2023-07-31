import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vrs_diff_master/Page/2ndPage.dart';
import 'package:vrs_diff_master/function/CsvFilePicker.dart';
import 'package:vrs_diff_master/widgets/myDrawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '予防接種向け台帳差分抽出ツール'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'STEP1 古い日の方のフォルダを選択して ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                CsvFilePicker csvFilePicker = CsvFilePicker();
                List<FileSystemEntity> csvFiles = await csvFilePicker.pickCsvFiles();
                try {
                  for (var file in csvFiles) {
                    // パスが長すぎる場合にエラーをキャッチして表示
                    if (file.path.length > 250) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('エラー'),
                            content: const Text('選択したファイルのパスが長すぎます。パスを短くしてください。(250文字以内に)'),
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
                      return; // エラーメッセージを表示したら処理を中断
                    }
                  }
                } catch (e) {
                  print(e);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage(csvFilesA: csvFiles)),
                );
              },
              child: Text("選択して次へ"),
            ),
          ],
        ),
      ),
      endDrawer: CustomDrawer(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

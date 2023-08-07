
import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/myDrawer.dart';
import '3rdPage.dart';
import '../function/CsvFilePicker.dart';
import '../main.dart';

class SecondPage extends StatefulWidget {
  //const SecondPage({super.key});
  final List<FileSystemEntity> csvFilesA;
  SecondPage({required this.csvFilesA});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("予防接種向け台帳差分抽出ツール",
          style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'STEP2 新しい日の方のフォルダを選択して ',
              style: TextStyle(
                fontSize: 16, // テキストのサイズ
                fontWeight: FontWeight.bold, // テキストの太さ
                fontFamily: 'Arial', // テキストのフォントファミリー
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: ()async{
              CsvFilePicker csvFilePicker = CsvFilePicker();
              List<FileSystemEntity> csvFilesB = await csvFilePicker.pickCsvFiles();
              try {

                for (var file in csvFilesB) {
                  //print(file.path);
                }
              } catch (e) {
                print(e);
              };

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThirdPage(csvFilesA: widget.csvFilesA, csvFilesB: csvFilesB,)),
              );

            },
                child:Text("選択して次へ")
            )

          ],

        ),
      ),
      endDrawer: CustomDrawer(),
    );
  }
}

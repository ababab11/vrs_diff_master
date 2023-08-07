import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vrs_diff_master/Page/explainPage1.dart';
import 'package:vrs_diff_master/Page/explainPage2.dart';
import 'package:vrs_diff_master/Page/explainPage3.dart';
import 'package:vrs_diff_master/Page/explainPage4.dart';
import 'package:vrs_diff_master/widgets/changeExtractor.dart';
import 'package:vrs_diff_master/widgets/findNewPersonalNumbers.dart';

import '../widgets/findDeletedPersonalNumbers.dart';
import '../testFunction/majorFunction01.dart';
import '../widgets/myDrawer.dart';
import '../widgets/vaccineRecordExtractor.dart';

class ThirdPage extends StatefulWidget {
  //const ThirdPage({super.key});
  final List<FileSystemEntity> csvFilesA;
  final List<FileSystemEntity> csvFilesB;
  ThirdPage({required this.csvFilesA,required this.csvFilesB});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  double valueOfProgress = 0;
  int showIndex = 0;

  void openOutputFolder() async {
    Directory outputDirectory = Directory.current;
    if (await outputDirectory.exists()) {
      // フォルダが存在する場合の処理
      if (Platform.isWindows) {
        Process.run('explorer', [outputDirectory.path]);
      } else if (Platform.isMacOS) {
        // MacOSの場合はFinderを開くなど
      } else if (Platform.isLinux) {
        // Linuxの場合はファイルマネージャーを開くなど
      }
    } else {
      // フォルダが存在しない場合の処理
      print('指定されたフォルダは存在しません。');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("予防接種向け台帳差分抽出ツール",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),),


      ),


      body:  Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'STEP3 処理を選択して ',
              style: TextStyle(
                fontSize: 20, // テキストのサイズ
                fontWeight: FontWeight.bold, // テキストの太さ
                fontFamily: 'Arial', // テキストのフォントファミリー
              ),
            ),
            SizedBox(height: 16,),

            Container(
              width: 250,
              height: 5,
              child: (showIndex == 1)
                  ? ChangeExtractor(csvFilesA: widget.csvFilesA, csvFilesB: widget.csvFilesB)
                  : (showIndex == 2)
                  ? VaccineRecordExtractor(csvFilesA: widget.csvFilesA, csvFilesB: widget.csvFilesB)
                  : (showIndex == 3)
                  ? FindNewPersonalNumbers(csvFilesA: widget.csvFilesA, csvFilesB: widget.csvFilesB)
                  : (showIndex == 4)
                  ? FindDeletedPersonalNumbers(csvFilesA: widget.csvFilesA, csvFilesB: widget.csvFilesB)
                  : Container(), // カッコの後にデフォルトのコンテンツを追加することができます
            ),
            SizedBox(height: 16),
            Container(
              width: 450,
              height: 40,
              child:
            ElevatedButton(onPressed: (){
              showIndex = 1;
              setState(() {
              });
            },
              child:Text("変更のあったデータを抽出",
                style: TextStyle(
                  fontSize: 17, // ここで文字サイズを指定
                ),),
            ),),

            SizedBox(height: 16),
            Container(
              width: 450,
              height: 40,
              child: ElevatedButton(onPressed: (){
                showIndex = 2;
                setState(() {

                });
              },
                  child:Text("接種記録の削除があるデータを抽出",
                      style: TextStyle(
                        fontSize: 17, // ここで文字サイズを指定
                      )),
              ),
            ),
            SizedBox(height: 16,),
            Container(
              width: 450,
              height: 40,
              child: ElevatedButton(onPressed: (){
                showIndex = 3;
                valueOfProgress = valueOfProgress - 0.1;
                setState(() {

                });
              },
                child:Text("新出の個人番号に対応するデータを抽出",
                    style: TextStyle(
                      fontSize: 17, // ここで文字サイズを指定
                    )),
              ),
            ),
            SizedBox(height: 16,),
            Container(
              width: 450,
              height: 40,
              child: ElevatedButton(onPressed: () async {
                 showIndex = 4;
                 setState(() {
                 });
              },
                child:Text("削除された個人番号に対応するデータを抽出",
                    style: TextStyle(
                      fontSize: 17, // ここで文字サイズを指定
                    )),
              ),
            ),
            SizedBox(height: 16,),



          ],
        ),
      ),


      endDrawer:CustomDrawer(),
    );
  }
}


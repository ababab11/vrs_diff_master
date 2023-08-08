import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Page/explainAboutApp.dart';
import '../Page/explainPage1.dart';
import '../Page/explainPage2.dart';
import '../Page/explainPage3.dart';
import '../Page/explainPage4.dart';
import '../Page/questionTo.dart';


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

class CustomDrawer extends StatelessWidget {

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
    return Container(
      width: 400,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.grey,
              padding: EdgeInsets.all(16),
              child: Text(
                'MENU',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.folder_open_outlined),
              title: Text('出力フォルダを開く'),
              onTap: () {
                // フォルダを開く関数を呼び出す
                openOutputFolder();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(CupertinoIcons.info),
              title: Text('本アプリについて'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExplainAboutApp()),
                );

              },
            ),
            Divider(),

            ListTile(
              leading: Text('↓↓↓各機能の説明は下記をクリック ↓↓↓'),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.info),
              title: Text('【変更のあったデータを抽出】'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExplainPageOne()),
                );
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.info),
              title: Text('【接種記録の削除があるデータを抽出】'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExplainPageTwo()),
                );
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.info),
              title: Text('【新出の個人番号に対応するデータを抽出】'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExplainPageThree()),
                );
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.info),
              title: Text('【削除された個人番号に対応するデータを抽出】'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExplainPageFour()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.mail_outline),
              title: Text('開発者への質問'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuestionTo()),


                );
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

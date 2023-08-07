import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExplainAboutApp extends StatefulWidget {
  const ExplainAboutApp({Key? key}) : super(key: key);

  @override
  State<ExplainAboutApp> createState() => _ExplainAboutAppState();
}

class _ExplainAboutAppState extends State<ExplainAboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('【変更のあったデータの抽出】の説明',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            )),

      ),
      body: Center(
        child: Image.asset('assets/images/本アプリについて.png'),
      ),
    );
  }
}

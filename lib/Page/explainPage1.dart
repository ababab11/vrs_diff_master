import 'package:flutter/material.dart';

class ExplainPageOne extends StatefulWidget {
  const ExplainPageOne({Key? key}) : super(key: key);

  @override
  State<ExplainPageOne> createState() => _ExplainPageOneState();
}

class _ExplainPageOneState extends State<ExplainPageOne> {
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
        child: Image.asset('assets/images/新規 ビットマップ イメージ.jpg'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ExplainPageFour extends StatefulWidget {
  const ExplainPageFour({Key? key}) : super(key: key);

  @override
  State<ExplainPageFour> createState() => _ExplainPageFourState();
}

class _ExplainPageFourState extends State<ExplainPageFour> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('【削除された個人番号に対応するデータを抽出】の説明',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            )),

      ),
      body: Center(
        child: Image.asset('assets/images/個人CD削除.jpg'),
      ),
    );
  }
}

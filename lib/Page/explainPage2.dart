import 'package:flutter/material.dart';

class ExplainPageTwo extends StatefulWidget {
  const ExplainPageTwo({Key? key}) : super(key: key);

  @override
  State<ExplainPageTwo> createState() => _ExplainPageTwoState();
}

class _ExplainPageTwoState extends State<ExplainPageTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('【接種記録の削除があるデータを抽出】の説明',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            )),

      ),
      body: Center(
        child: Image.asset('assets/images/記録削除.jpg'),
      ),
    );
  }
}

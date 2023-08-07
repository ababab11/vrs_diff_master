import 'package:flutter/material.dart';

class ExplainPageThree extends StatefulWidget {
  const ExplainPageThree({Key? key}) : super(key: key);

  @override
  State<ExplainPageThree> createState() => _ExplainPageThreeState();
}

class _ExplainPageThreeState extends State<ExplainPageThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('【新出の個人番号に対応するデータを抽出】の説明',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            )),

      ),
      body: Center(
        child: Image.asset('assets/images/新出個人CD分.png'),
      ),
    );
  }
}

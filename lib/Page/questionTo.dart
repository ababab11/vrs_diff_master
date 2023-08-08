import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionTo extends StatefulWidget {
  const QuestionTo({Key? key}) : super(key: key);

  @override
  State<QuestionTo> createState() => _QuestionToState();
}

class _QuestionToState extends State<QuestionTo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('開発者への質問',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            )),

      ),
      body: Center(
        child: Image.asset('assets/images/開発者について.png'),
      ),
    );
  }
}

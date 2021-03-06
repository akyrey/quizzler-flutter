import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:quizzler_flutter/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];
  QuizBrain quizBrain = QuizBrain();
  String animation = 'idle';
  Icon iconCorrect = Icon(Icons.check, color: Colors.green);
  Icon iconWrong = Icon(Icons.close, color: Colors.red);

  void checkAnswer(bool result) {
    setState(() {
      if (result == quizBrain.question.answer) {
        scoreKeeper.add(iconCorrect);
        animation = 'success';
      } else {
        scoreKeeper.add(iconWrong);
        animation = 'fail';
      }
    });
    quizBrain.nextQuestion();

    if (quizBrain.isFinished) {
      Alert(
          context: context,
          type: AlertType.success,
          style: AlertStyle(
            isCloseButton: false,
            isOverlayTapDismiss: false,
          ),
          title: 'Complete!',
          desc: 'You have answered to all the questions',
          buttons: [
            DialogButton(
                child: Text(
                  'Play again',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    quizBrain.reset();
                    scoreKeeper.clear();
                    animation = 'idle';
                  });
                })
          ]).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CircleAvatar(
          radius: 150,
          child: ClipOval(
            child: FlareActor(
              'assets/Teddy.flr',
              alignment: Alignment.center,
              fit: BoxFit.fitWidth,
              animation: animation,
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
                child: Text(
              quizBrain.progress,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ))
          ],
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.question.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Colors.white)),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: FlatButton(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Colors.white)),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            ...scoreKeeper
          ],
        ),
      ],
    );
  }
}

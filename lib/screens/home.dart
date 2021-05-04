import 'package:flutter/material.dart';
import 'package:multilanguageandvoice/localization/language/languages.dart';
import 'package:multilanguageandvoice/localization/language/locale_constant.dart';
import 'package:multilanguageandvoice/model/language_data.dart';
import 'package:speech_recognition/speech_recognition.dart';
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";
  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }
  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
    );
  }






  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.language,
            color: Colors.white,
          ),
          title: Text(Languages
              .of(context)
              .appName),
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                Text(
                  Languages
                      .of(context)
                      .labelWelcome,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  Languages
                      .of(context)
                      .labelInfo,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,

                ),
                SizedBox(
                  height: 70,
                ),
                _createLanguageDropDown(),
                SizedBox(
                  height: 70,
                ),
                _cretaespechtotext(),
              ],
            ),
          ),
        ),
      );

  _createLanguageDropDown() {
    return DropdownButton<LanguageData>(
      iconSize: 30,
      hint: Text(Languages
          .of(context)
          .labelSelectLanguage),
      onChanged: (LanguageData language) {
        changeLanguage(context, language.languageCode);
      },
      items: LanguageData.languageList()
          .map<DropdownMenuItem<LanguageData>>(
            (e) =>
            DropdownMenuItem<LanguageData>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    e.flag,
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(e.name)
                ],
              ),
            ),
      )
          .toList(),
    );
  }


  _cretaespechtotext(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            child: Icon(Icons.cancel),
            mini: true,
            backgroundColor: Colors.deepOrange,
            onPressed: (){
              if (_isListening)
                _speechRecognition.cancel().then(
                      (result) => setState(() {
                    _isListening = result;
                    resultText = "";
                  }),
                );
            },

          ),


          FloatingActionButton(
            child: Icon(Icons.mic),
            onPressed: () {
              if (_isAvailable && !_isListening)
                _speechRecognition
                    .listen(locale: "tr_TR")
                    .then((result) => print('$result'));
            },
            backgroundColor: Colors.pink,
          ),
          FloatingActionButton(
            child: Icon(Icons.stop),
            mini: true,
            backgroundColor: Colors.deepPurple,
            onPressed: () {
              if (_isListening)
                _speechRecognition.stop().then(
                      (result) => setState(() => _isListening = result),
                );
            },
          ),
        ],
      ),

        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.cyanAccent[100],
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          child: Text(
            resultText,
            style: TextStyle(fontSize: 24.0),
          ),

        )
      ],
    );


  }
}
import 'dart:convert';
import 'package:assistant/openAI_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'feature_box.dart';
import 'pallette.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final SpeechToText speechToText = SpeechToText();
  String lastWords = '';
  bool isListening = false;
  final OpenAIService openAiService = OpenAIService();

  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    bool available = await speechToText.initialize(
      onError: (error) {
        print("Error initializing SpeechToText: $error");
      },
    );
    if (available) {
      setState(() {});
    } else {
      print("Speech recognition not available.");
    }
  }

  Future<void> startListening() async {
    try {
      await speechToText.listen(onResult: onSpeechResult);
      setState(() {
        isListening = true;
      });
    } catch (e) {
      print("Error starting listening: $e");
    }
  }

  Future<void> stopListening() async {
    try {
      await speechToText.stop();
      setState(() {
        isListening = false;
      });
    } catch (e) {
      print("Error stopping listening: $e");
    }
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EchoIntellect'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: pallette.asistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/virtualAssistants.png'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 30,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: pallette.borderColor),
                borderRadius:
                    BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  isListening ? 'Listening...' : 'Hello, How can I help you?',
                  style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: pallette.mainfontcolor,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            if (lastWords.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 22, top: 10),
                child: Text(
                  'Recognized Words: $lastWords',
                  style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    fontSize: 20,
                    color: pallette.mainfontcolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                left: 22,
                top: 10,
              ),
              child: const Text(
                'Here are a few commands',
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 20,
                  color: pallette.mainfontcolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Column(
              children: [
                FeatureBox(
                  color: pallette.firstSuggestionBoxColor,
                  headerText: 'ChatGPT',
                  descriptionText:
                      'Smarter way to stay organized and informed with ChatGPT',
                ),
                FeatureBox(
                  color: pallette.secondSuggestionBoxColor,
                  headerText: 'Dall-E',
                  descriptionText:
                      'From Words to Wonders: DALL-E Unleashes Imagination',
                ),
                FeatureBox(
                  color: pallette.thirdSuggestionBoxColor,
                  headerText: 'Smart Voice Assistant',
                  descriptionText: 'Unlock Echo: Where Words Shape Tomorrow!',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: pallette.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && !speechToText.isListening) {
            await startListening();
          } else if (speechToText.isListening) {
            openAiService.isArtPromptAPI(lastWords);
            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
}

import 'package:allen/colors.dart';
import 'package:allen/feature_box.dart';
import 'package:allen/screts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTTS = FlutterTts();
  String lastWords = '';
  final model = GenerativeModel(model: 'gemini-pro', apiKey: geminiApi);
  // final OpenAIService openAIService = OpenAIService();
  // final GeminiServices geminiServices = GeminiServices();
  String? generatedContent;
  String? generatedImageURL;

// Map<String, String> hard_responses = {
//   "hello how are you": "I am well, thank you for asking. I am a large language model, trained by Google.",
//   "नमस्ते": "नमस्ते, आपका दिन कैसा चल रहा है? क्या मैं आपकी किसी चीज़ में मदद कर सकता हूँ?",
//   "how are you in french": "Comment allez-vous ?",
//   "": "",
//   "": "",
// };

  @override
  void initState() {
    super.initState();
    initSpeech();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTTS.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeech() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      debugPrint("Lastwords: $lastWords");
    });
  }

  Future<void> speak(String content) async {
    flutterTTS.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTTS.stop();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "A.L.L.E.N.",
          style: TextStyle(
            fontFamily: "ProductSans",
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
          ),
        ),
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
                    decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/image/virtual-assistant.png",
                      ),
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
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: generatedImageURL == null
                    ? Text(
                        generatedContent == null
                            ? "Hello! My name is A.L.L.E.N. How can I help you today?"
                            : generatedContent!,
                        style: TextStyle(
                          color: isDark
                              ? Pallete.whiteColor
                              : Pallete.mainFontColor,
                          fontFamily: "ProductSans",
                          fontSize: generatedContent == null ? 20 : 18,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          generatedImageURL!,
                        ),
                      ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageURL == null,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10, left: 22),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Here are a few features...",
                  style: TextStyle(
                    fontFamily: "ProductSans",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Pallete.whiteColor : Pallete.mainFontColor,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageURL == null,
              child: const Column(
                children: [
                  FeatureBox(
                    color: Pallete.firstSuggestionBoxColor,
                    title: "Chat-GPT",
                    text:
                        "A smarter way to stay organized and informed with Chat-GPT",
                  ),
                  FeatureBox(
                    color: Pallete.secondSuggestionBoxColor,
                    title: "DALL-E",
                    text:
                        "Get inspired and stay connected with your personal assistant powered by DALL-E",
                  ),
                  FeatureBox(
                    color: Pallete.thirdSuggestionBoxColor,
                    title: "Smart voice assistant",
                    text:
                        "Get the best of both worlds with a voice assistant powered by DALL-E and Chat-GPT",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          }
          if (speechToText.isListening) {
            final speech =
                await model.generateContent([Content.text(lastWords)]);
            if (speech.text!.contains('https')) {
              generatedImageURL = speech.text!;
              generatedContent = null;
              setState(() {});
            } else {
              generatedImageURL = null;
              generatedContent = speech.text!;
              setState(() {});
              await speak(speech.text!);
            }
          } else {
            initSpeech();
          }
        },
        child: const Icon(
          Icons.mic,
          color: Pallete.blackColor,
        ),
      ),
    );
  }
}

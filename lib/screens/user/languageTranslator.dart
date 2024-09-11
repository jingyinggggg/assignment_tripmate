import 'package:assignment_tripmate/language_service.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:assignment_tripmate/screens/user/homepage.dart';

class LanguageTranslatorScreen extends StatefulWidget {
  final String userId;

  const LanguageTranslatorScreen({super.key, required this.userId});

  @override
  State<LanguageTranslatorScreen> createState() => _LanguageTranslatorScreenState();
}

class _LanguageTranslatorScreenState extends State<LanguageTranslatorScreen> {
  final outputController = TextEditingController(text: "Result here...");
  final translator = GoogleTranslator();
  final languageService = LanguageService();  // Create an instance of LanguageService

  String inputText = '';
  String? inputLanguage;
  String? outputLanguage;
  List<Map<String, String>> languages = []; // Store the fetched languages

  @override
  void initState() {
    super.initState();
    fetchLanguages();  // Fetch available languages when the screen loads
  }

  Future<void> fetchLanguages() async {
    List<Map<String, String>> fetchedLanguages = await languageService.fetchSupportedLanguages();
    setState(() {
      languages = fetchedLanguages;
      inputLanguage = languages.isNotEmpty ? languages.first['code'] : null;
      outputLanguage = languages.isNotEmpty ? languages.first['code'] : null;
    });
  }

  Future<void> translateText() async {
    if (inputLanguage != null && outputLanguage != null) {
      final translated = await translator.translate(
        inputText,
        from: inputLanguage!,
        to: outputLanguage!,
      );
      setState(() {
        outputController.text = translated.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Language Translator"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomepageScreen(userId: widget.userId),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                    ),
                    hintText: "Enter text to translate...",
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (value) {
                    setState(() {
                      inputText = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (languages.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: inputLanguage,
                        onChanged: (newValue) {
                          setState(() {
                            inputLanguage = newValue!;
                          });
                        },
                        items: languages.map<DropdownMenuItem<String>>((lang) {
                          return DropdownMenuItem<String>(
                            value: lang['code'],
                            child: Text(lang['name']!),
                          );
                        }).toList(),
                      ),
                      const Icon(Icons.arrow_forward_rounded),
                      DropdownButton<String>(
                        value: outputLanguage,
                        onChanged: (newValue) {
                          setState(() {
                            outputLanguage = newValue!;
                          });
                        },
                        items: languages.map<DropdownMenuItem<String>>((lang) {
                          return DropdownMenuItem<String>(
                            value: lang['code'],
                            child: Text(lang['name']!),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                else
                  const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: translateText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF467BA1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(55),
                  ),
                  child: const Text("Translate"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: outputController,
                  readOnly: true,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF467BA1), width: 1.5),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

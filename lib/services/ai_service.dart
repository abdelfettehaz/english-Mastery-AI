import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static String get _apiKey => dotenv.get('GROQ_API_KEY', fallback: '');
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> getCompletion(String message, List<Map<String, String>> history) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama3-8b-8192',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a friendly, expert English language tutor called "Linguist AI". You help learners improve their English through clear explanations, examples, and encouragement. Your responses should be concise, practical, and engaging. Focus on the learner\'s specific question. Use simple formatting if helpful. Use emoji to be friendly.',
            },
            ...history,
            {'role': 'user', 'content': message},
          ],
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "I'm sorry, I'm having trouble connecting to my brain right now. Please try again later! (Error: ${response.statusCode})";
      }
    } catch (e) {
      return "Oops! Something went wrong: $e";
    }
  }
}

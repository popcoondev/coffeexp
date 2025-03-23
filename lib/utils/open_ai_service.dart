import 'dart:convert';
import 'dart:io';
import 'package:coffeexp/open_ai_options.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  // OpenAI APIエンドポイント
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  // あなたのOpenAI APIキー
  final String _apiKey = openai_apikey;

  // 会話履歴を保持するリスト
  List<Map<String, String>> _messages = [];

  String buildMessageContent(String text, String imageUrl) {
    return jsonEncode([
      {
        "type": "text",
        "content": text,
      },
      if (imageUrl.isNotEmpty) {
        "type": "image_url",
        "image_url": {
            "url": imageUrl,
          },
      }
    ]);
  }

  // 会話履歴にメッセージを追加する関数
  void addUserMessage(String message) {
    _messages.add({
      "role": "user",
      "content": message,
    });
  }

  // AIからの応答を履歴に追加する関数
  void addAssistantMessage(String message) {
    _messages.add({
      "role": "assistant",
      "content": message,
    });
  }

  // OpenAIとの通信を行う関数
  Future<String> sendMessageToOpenAI(String message) async {
    // messageは次のようにimageを含むリクエストを送信することも可能
    // {
    //   "type": "image_url",
    //   "image_url": {"url": imageUrls[0]},  // 1つ目の画像のURL
    // },

    addUserMessage(message);  // ユーザーのメッセージを履歴に追加

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };

      final body = jsonEncode({
        "model": "gpt-4o-mini",  // 使用するモデル
        "messages": _messages,  // 会話履歴を含めてリクエスト
        "max_tokens": 300, // 応答の最大トークン数
        // "temperature": 0.7, // 生成されるテキストの多様性を制御
      });

      print('Request body: $body');
      final response = await http.post(Uri.parse(_apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final replyMessage = jsonResponse['choices'][0]['message']['content'];

        addAssistantMessage(replyMessage);  // AIの応答を履歴に追加

        return replyMessage;
      } else {
        print('Error: Failed to get a response from OpenAI');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 'Error: Failed to get a response from OpenAI (status code: ${response.statusCode})';

      }
    } catch (error) {
      return 'Error: $error';
    }
  }


  // 会話履歴をリセットする関数（必要な場合）
  void resetConversation() {
    _messages = [];
  }
}

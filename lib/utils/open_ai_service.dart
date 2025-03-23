import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:coffeexp/open_ai_options.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  // OpenAI APIエンドポイント
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  // APIキーを保持する変数
  late String _apiKey;
  bool _isInitialized = false;

  // 会話履歴を保持するリスト
  List<Map<String, dynamic>> _messages = [];

  // サービスの初期化
  Future<void> initialize() async {
    if (!_isInitialized) {
      _apiKey = await getOpenAIApiKey();
      _isInitialized = true;
    }
  }

  // メッセージ内容を構築するメソッド
  Map<String, dynamic> buildMessageMap(String text, String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return {
        "role": "user",
        "content": [
          {
            "type": "text",
            "text": text,
          },
          {
            "type": "image_url",
            "image_url": {
              "url": imageUrl,
            },
          }
        ]
      };
    } else {
      return {
        "role": "user",
        "content": text,
      };
    }
  }

  // 画像付きメッセージの内容を構築する（レガシーサポート用）
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

  // 会話履歴にユーザーメッセージを追加する関数
  void addUserMessage(String message) {
    _messages.add({
      "role": "user",
      "content": message,
    });
  }

  // 会話履歴に画像付きユーザーメッセージを追加する関数
  void addUserMessageWithImage(String message, String imageUrl) {
    _messages.add({
      "role": "user",
      "content": [
        {
          "type": "text",
          "text": message,
        },
        {
          "type": "image_url",
          "image_url": {
            "url": imageUrl,
          }
        }
      ]
    });
  }

  // AIからの応答を履歴に追加する関数
  void addAssistantMessage(String message) {
    _messages.add({
      "role": "assistant",
      "content": message,
    });
  }

  // OpenAIとの通信を行う関数（テキストのみ）
  Future<String> sendMessageToOpenAI(String message) async {
    await initialize();
    addUserMessage(message);
    return _sendRequest();
  }

  // OpenAIとの通信を行う関数（画像付き）
  Future<String> sendMessageWithImageToOpenAI(String message, String imageUrl) async {
    await initialize();
    addUserMessageWithImage(message, imageUrl);
    return _sendRequest();
  }

  // 実際のAPI通信を行う内部メソッド
  Future<String> _sendRequest() async {
    try {
      // APIキーが有効かどうかをチェック
      if (_apiKey == 'missing-api-key-please-set-in-firebase-remote-config' || 
          _apiKey.isEmpty || 
          !_apiKey.startsWith('sk-')) {
        print('Invalid API key format: $_apiKey');
        return 'Error: Invalid API key format. Please check your OpenAI API key configuration.';
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };

      final body = jsonEncode({
        "model": "gpt-4o-mini", // 使用するモデル
        "messages": _messages,  // 会話履歴を含めてリクエスト
        "max_tokens": 1000,     // 応答の最大トークン数を増やした
        "temperature": 0.7,     // 生成されるテキストの多様性を制御
      });

      print('Sending request to OpenAI...');
      print('API Key (first 4 chars): ${_apiKey.substring(0, math.min(4, _apiKey.length))}...');
      print('Request body: $body');
      
      final response = await http.post(
        Uri.parse(_apiUrl), 
        headers: headers, 
        body: body
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final replyMessage = jsonResponse['choices'][0]['message']['content'];

        addAssistantMessage(replyMessage);  // AIの応答を履歴に追加
        return replyMessage;
      } else {
        print('Error: Failed to get a response from OpenAI');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        
        try {
          // レスポンスボディをJSONとしてパースしてエラーメッセージを取得
          final errorJson = jsonDecode(response.body);
          final errorMessage = errorJson['error']?['message'] ?? 'Unknown error';
          
          if (response.statusCode == 401) {
            return 'Error: Authentication failed. Please check your OpenAI API key. Details: $errorMessage';
          } else if (response.statusCode == 400) {
            return 'Error: Bad request. Details: $errorMessage';
          } else if (response.statusCode == 429) {
            return 'Error: Rate limit exceeded or quota reached. Details: $errorMessage';
          } else {
            return 'Error: Failed to get a response from OpenAI (status code: ${response.statusCode}). Details: $errorMessage';
          }
        } catch (e) {
          // JSONのパースに失敗した場合
          return 'Error: Failed to get a response from OpenAI (status code: ${response.statusCode})';
        }
      }
    } catch (error) {
      print('Exception during OpenAI request: $error');
      return 'Error: $error';
    }
  }

  // 会話履歴をリセットする関数
  void resetConversation() {
    _messages = [];
  }

  // APIキーが設定されているか確認
  bool isConfigured() {
    return _isInitialized && _apiKey != 'missing-api-key-please-set-in-firebase-remote-config';
  }
}

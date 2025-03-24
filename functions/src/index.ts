import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// Gemini APIは実際に使うときに再度有効化する
// import { GoogleGenerativeAI, HarmCategory, HarmBlockThreshold } from "@google/generative-ai";

admin.initializeApp();

// リモートコンフィグが更新されたときに呼び出される関数
export const logRemoteConfigUpdate = functions.remoteConfig.onUpdate(async (versionMetadata) => {
  functions.logger.info("Remote Config updated", {
    versionNumber: versionMetadata.versionNumber,
    updateTime: versionMetadata.updateTime,
    updateUser: versionMetadata.updateUser,
    description: versionMetadata.description,
  });
  
  return null;
});

// 写真分析関数
export const analyzeCoffeePhoto = functions.https.onCall(async (data, context) => {
  try {
    // 認証チェック
    if (!context.auth) {
      throw new Error("認証が必要です");
    }

    const { imageUrl } = data;
    if (!imageUrl) {
      throw new Error("画像URLが必要です");
    }

    // 認証エラーが解決するまで常にモックデータを返す
    // 本来はこの下の行を削除して実際のGemini API呼び出しを行う
    return {
      success: true,
      data: {
        "name": "エチオピア イルガチェフェ",
        "roaster": "Sample Coffee Roasters",
        "country": "エチオピア",
        "region": "イルガチェフェ",
        "process": "ウォッシュド",
        "variety": "ハイランド", 
        "elevation": "1900-2200m",
        "roastLevel": "Medium"
      }
    };

    /* 以下は本来の実装 - 認証問題が解決したら戻す
    // Gemini APIの呼び出し
    const genAI = configureGeminiAPI();
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    // Firebase Storageの公開URLを取得
    let publicUrl;
    try {
      const bucket = admin.storage().bucket();
      const imagePath = imageUrl.replace('gs://', '').split('/').slice(1).join('/');
      const file = bucket.file(imagePath);
      
      // 一時的な公開URLを取得（1時間有効）
      const [signedUrl] = await file.getSignedUrl({
        action: 'read',
        expires: Date.now() + 60 * 60 * 1000, // 1時間
      });
      
      publicUrl = signedUrl;
      
      const prompt = `
      以下のコーヒー豆のパッケージ写真を分析し、次の情報をJSON形式で返してください:
      {
        "name": "コーヒー豆の名前",
        "roaster": "焙煎者の名前",
        "country": "生産国",
        "region": "生産地域",
        "process": "精製方法",
        "variety": "品種",
        "elevation": "標高",
        "roastLevel": "焙煎度合い(Light/Medium/Dark)"
      }
      
      読み取れない情報がある場合は該当フィールドを空文字列("")としてください。
      必ずJSON形式のみを返してください。
      `;

      const safetySettings = [
        {
          category: HarmCategory.HARM_CATEGORY_HARASSMENT,
          threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
        },
        {
          category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
          threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
        },
        {
          category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
          threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
        },
        {
          category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
          threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
        },
      ];

      const result = await model.generateContent({
        contents: [{ 
          role: "user", 
          parts: [
            { text: prompt }, 
            { fileData: { mimeType: "image/jpeg", fileUri: publicUrl } }
          ] 
        }],
        safetySettings,
      });

      const response = result.response;
      const responseText = response.text();
      
      // JSONレスポンスの抽出
      let jsonData = {};
      try {
        // 文字列からJSONを抽出
        const jsonMatch = responseText.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
          jsonData = JSON.parse(jsonMatch[0]);
        } else {
          throw new Error("JSONデータが見つかりませんでした");
        }
      } catch (error) {
        console.error("JSONの解析に失敗しました:", error, responseText);
        throw new Error("解析結果の処理に失敗しました");
      }

      return {
        success: true,
        data: jsonData
      };
      
    } catch (error) {
      console.error("画像URL処理でエラーが発生:", error);
      // エラーが発生したらモックデータを返す
      return {
        success: true,
        data: {
          "name": "エチオピア イルガチェフェ",
          "roaster": "Sample Coffee Roasters",
          "country": "エチオピア",
          "region": "イルガチェフェ",
          "process": "ウォッシュド",
          "variety": "ハイランド",
          "elevation": "1900-2200m",
          "roastLevel": "Medium"
        }
      };
    }
    */

  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : "写真の分析中にエラーが発生しました";
    functions.logger.error("写真分析エラー:", error);
    return {
      success: false,
      error: errorMessage
    };
  }
});

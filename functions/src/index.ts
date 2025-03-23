import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { GoogleGenerativeAI, HarmCategory, HarmBlockThreshold } from "@google/generative-ai";

admin.initializeApp();

// Gemini APIの設定
const configureGeminiAPI = () => {
  const apiKey = functions.config().gemini?.api_key;
  if (!apiKey) {
    throw new Error("Gemini API key is not configured. Set it using: firebase functions:config:set gemini.api_key=YOUR_API_KEY");
  }
  return new GoogleGenerativeAI(apiKey);
};

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

    // 画像データの取得
    let imageData;
    try {
      // Firebase Storageから画像データを取得
      const bucket = admin.storage().bucket();
      const imagePath = imageUrl.replace('gs://', '').split('/').slice(1).join('/');
      const [file] = await bucket.file(imagePath).download();
      imageData = file.toString('base64');
    } catch (error) {
      console.error("画像の取得に失敗しました:", error);
      throw new Error("画像の取得に失敗しました");
    }

    // Gemini APIの呼び出し
    const genAI = configureGeminiAPI();
    const model = genAI.getGenerativeModel({ model: "gemini-pro-vision" });

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
      contents: [{ role: "user", parts: [{ text: prompt }, { inlineData: { data: imageData, mimeType: "image/jpeg" } }] }],
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
    const errorMessage = error instanceof Error ? error.message : "写真の分析中にエラーが発生しました";
    functions.logger.error("写真分析エラー:", error);
    return {
      success: false,
      error: errorMessage
    };
  }
});

#!/bin/bash
set -e

# プロジェクトディレクトリに移動
cd /Users/mn/development/coffeexp

# 1. Firestoreの設定
echo "Setting up Firestore..."
cat > firestore.rules << EOL
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // ユーザー認証があるユーザーは自分のデータのみ読み書き可能
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // コーヒーのサブコレクションは所有者のみアクセス可能
      match /coffees/{coffeeId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
        
        // コーヒーのテイスティングデータも所有者のみアクセス可能
        match /tastings/{tastingId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
    }
    
    // 認証されていない場合はテストユーザーとしてのみ読み書き可能
    match /users/test_user/{document=**} {
      allow read, write: if true;
    }
  }
}
EOL

cat > firestore.indexes.json << EOL
{
  "indexes": [
    {
      "collectionGroup": "coffees",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "isFavorite", "order": "ASCENDING" },
        { "fieldPath": "updatedAt", "order": "DESCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
EOL

# 2. Storageの設定
echo "Setting up Storage..."
cat > storage.rules << EOL
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    // デフォルトではアクセス禁止
    match /{allPaths=**} {
      allow read, write: if false;
    }
    
    // ユーザーのファイルは所有者のみアクセス可能
    match /user_files/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // テストユーザーのファイルは誰でもアクセス可能
    match /user_files/test_user/{allPaths=**} {
      allow read, write: if true;
    }
  }
}
EOL

# 3. Functionsの設定
echo "Setting up Functions..."
mkdir -p functions/src
cat > functions/package.json << EOL
{
  "name": "functions",
  "scripts": {
    "build": "tsc",
    "build:watch": "tsc --watch",
    "serve": "npm run build && firebase emulators:start --only functions",
    "shell": "npm run build && firebase functions:shell",
    "start": "npm run shell",
    "deploy": "firebase deploy --only functions",
    "logs": "firebase functions:log"
  },
  "engines": {
    "node": "18"
  },
  "main": "lib/index.js",
  "dependencies": {
    "firebase-admin": "^11.8.0",
    "firebase-functions": "^4.3.1"
  },
  "devDependencies": {
    "typescript": "^5.1.6"
  },
  "private": true
}
EOL

cat > functions/tsconfig.json << EOL
{
  "compilerOptions": {
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "outDir": "lib",
    "sourceMap": true,
    "strict": true,
    "target": "es2017",
    "skipLibCheck": true
  },
  "compileOnSave": true,
  "include": [
    "src"
  ]
}
EOL

# 基本的なFunctionsを作成
cat > functions/src/index.ts << EOL
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

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
EOL

# 4. Remote Configの設定
echo "Setting up Remote Config..."
cat > remoteconfig.template.json << EOL
{
  "parameters": {
    "openai_api_key": {
      "defaultValue": {
        "value": "sk-yourapikey"
      },
      "description": "OpenAI API Key for image analysis",
      "valueType": "STRING"
    }
  }
}
EOL

# 5. Firebase.jsonの作成
echo "Creating firebase.json..."
cat > firebase.json << EOL
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  },
  "functions": {
    "predeploy": "npm --prefix functions run build"
  },
  "remoteconfig": {
    "template": "remoteconfig.template.json"
  }
}
EOL

# 6. .firebasercの作成
echo "Creating .firebaserc..."
cat > .firebaserc << EOL
{
  "projects": {
    "default": "coffeexp-app"
  }
}
EOL

echo "Firebase setup completed! You can now deploy with: firebase deploy"
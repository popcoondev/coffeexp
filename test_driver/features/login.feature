# language: ja
機能: ユーザー認証
  アプリケーションはユーザーの認証を処理できるべきである
  
  シナリオ: ユーザーは有効な認証情報でログインできる
    前提 ユーザーはログイン画面にいる
    もし ユーザーが "test@example.com" と "password123" でログインする
    ならば ユーザーはログインできている
    
  シナリオ: ユーザーは無効な認証情報でログインできない
    前提 ユーザーはログイン画面にいる
    もし ユーザーが "invalid@example.com" と "wrongpassword" でログインする
    ならば エラーメッセージが表示される
# neon3

Flutter（Riverpod + go_router）と Firebase を使った、動画/音声の撮影・編集・エンコードを行うアプリケーションです。  
録画/取り込み → 編集 → トリミング → エンコード → 完了、というフローを想定した画面遷移で構成されています。

> NOTE: このリポジトリはアプリ開発用のプロジェクトです（pub.dev 公開は想定していません）。

---

## Getting started

### Prerequisites

- Flutter SDK（`pubspec.yaml` の `environment` より **Dart >=2.18.6 <3.0.0** 相当）
- Firebase プロジェクト（Auth / Firestore / Storage を使用）
- iOS/Android のビルド環境（必要に応じて）
  - iOS: Xcode
  - Android: Android Studio / SDK

### Setup

```shell
git clone https://github.com/maropook/neon3.git
cd neon3
flutter pub get
```

Firebase を初期化して起動します（`lib/main.dart` で `Firebase.initializeApp()` を呼んでいます）。

```shell
flutter run
```

---

## Fill with your own text / Project notes

この README は、プロジェクトの概要が分かりやすくなるように整備したものです。  
実際の仕様（どの画面で何ができるか、動画/音声の入出力形式、字幕やTTSの扱いなど）は `lib/` 配下の実装に合わせて随時追記してください。

---

## Features

- **Firebase 初期化**（`Firebase.initializeApp()`）
- **匿名ログイン**（Firebase Auth）
  - `authProvider` が `signInAnonymously()` を実行し `uid` を保持
- **画面ルーティング**（go_router）
  - 未ログイン（`uid.isEmpty`）の場合は `/login` にリダイレクト
- **動画/音声編集フロー**
  - 録画/取り込み → 編集 → トリミング → エンコード → 完了
- **Firestore による Avatar 管理**
  - `users/{uid}/avatars` 配下を中心に CRUD
  - `selectedAvatar` の選択状態を保持
  - グローバルな `avatars` コレクションからデフォルト取得
- **サムネ生成**
  - `video_thumbnail` を使ってタイムライン用のサムネを生成する `ThumbnailService`
- **カスタムパッケージ連携**
  - `neon_video_encoder`（GitHub 依存）
  - `neon_speech_to_text`（GitHub 依存）
- **アセット/フォント**
  - `assets/` 配下に画像・音声・動画など
  - `flutter_gen` で `lib/gen/assets.gen.dart` / `lib/gen/fonts.gen.dart` を生成

---

## App routes (go_router)

- `/login` : ログインページ
- `/` : RecordingPage（起点）
  - `/import` : ImportPage
- `/avatar/list` : AvatarListPage
  - `/avatar/list/detail` : AvatarDetailPage（`state.extra` で `Avatar` を受け取る）
- `/edit` : EditPage（`EditPageArgs` を受け取る）
- `/trim` : TrimPage（`EditPageArgs` を受け取る）
- `/encoding` : EncodePage（`EncodePageArgs` を受け取る）
- `/complete` : CompletePage（生成物の filePath を受け取る）

---

## Firebase / Data model (overview)

### Authentication

- 起動時に `authProvider` がログイン状態を確定します
  - 未ログインなら匿名ログイン
  - `uid` を state に保存

### Firestore collections (observed)

- `users/{uid}/avatars/{avatarId}`
- `users/{uid}/avatars/selectedAvatar`（`id` を保持）
- `avatars/*`（デフォルト Avatar 取得用）

---

## Development

### Code generation

このプロジェクトは `freezed` / `json_serializable` を利用しているため、モデル変更時は生成を実行します。

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```

### Lint / Analyze

```shell
flutter analyze
```

---

## Troubleshooting

### ログイン画面から先に進めない

`go_router` の `redirect` で `uid.isEmpty` の場合 `/login` に飛ばすようになっています。  
Firebase 初期化や Auth の疎通（匿名ログイン）ができているか確認してください。

### Firestore の読み書きが失敗する

Firebase の設定（`google-services.json` / `GoogleService-Info.plist`、ルール、プロジェクトID）が正しいか確認してください。

## 参考
### riverpod+camera
[【Flutter】Cameraライブラリを使用してインカメラ（内カメ）で写真を撮影する方法](https://qiita.com/pikatyu3/items/fedfa27ab889b0d07b37)
[【Flutter】cameraパッケージの基本とTips](https://docs.sakai-sc.co.jp/article/programing/flutter-camera-package.html)
### stateNotifierProviderでonDisposeを使う
[FlutterでQRコードを読み込む（riverpod 2)](https://qiita.com/t-yasukawa/items/897b1114b228844bf324)
https://zenn.dev/mkikuchi/articles/cc87c84e1404c4
https://github.com/flutter/flutter/issues/112915


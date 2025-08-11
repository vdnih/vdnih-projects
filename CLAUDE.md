# CLAUDE.md

このファイルは、Claude Code（claude.ai/code）がこのリポジトリで作業する際のガイドラインを示します。

## リポジトリ構成

このリポジトリは、Turborepoを用いて複数のプロダクトを管理するモノレポです。

- **apps/sakeflow-site**: Next.js 13+（App Router）で構築されたSSRブログサイト。microCMSをヘッドレスCMSとして利用。
- **apps/sakeflow-app**: 日本酒記録用Flutter Webアプリ。Firebase Auth、Firestore、Storageを利用。
- **packages/**: Firebase設定や共通型などの共有パッケージ（参照のみ、現状は空）
- **docs/**: 各アプリ・パッケージの設計指針やスタイルガイド（Copilot instructionsで参照）

## 主な技術

### sakeflow-site（Next.jsブログ）
- Next.js 13+（App Router構成）
- microCMSによるコンテンツ管理（ブログ、カテゴリ、執筆者）
- サーバーサイドレンダリングと静的生成
- TypeScriptによるCMSコンテンツの厳密な型定義
- CSS Modulesによるスタイリング

### sakeflow-app（Flutter Web）
- Flutter 3.7+（Webプラットフォーム対応）
- Firebase Auth（Google OAuth対応）
- Cloud Firestoreによるデータ保存
- Firebase Storageによる画像アップロード
- Material Designコンポーネント

## 開発コマンド

### ルート（Turborepo）
- `npm run dev` - 全アプリを開発モードで起動
- `npm run build` - Build all apps with dependency caching
- `npm run docs` - Run documentation-related tasks
- `turbo run dev --filter=apps/sakeflow-site` - Run specific app only
- `turbo run build` - Incremental builds across the monorepo

### sakeflow-site (Next.js)
- `npm run dev` - Development server (localhost:3000)
- `npm run build` - Production build
- `npm run start` - Start production server
- `npm run lint` - ESLint checking
- `npm run format` - Prettier formatting

Environment variables required:
- `MICROCMS_SERVICE_DOMAIN`
- `MICROCMS_API_KEY`

### sakeflow-app (Flutter)
- `flutter run -d chrome` - Run in Chrome browser
- `flutter build web` - Build for web deployment
- `flutter test` - Run tests
- `flutter pub get` - Install dependencies

Firebase configuration files:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

## Code Architecture Patterns

### sakeflow-site（Next.js）
- `npm run dev` - 開発サーバー起動（localhost:3000）
- `npm run build` - 本番ビルド
- `npm run start` - 本番サーバー起動
- `npm run lint` - ESLintによる静的解析
- `npm run format` - Prettierによる整形

必要な環境変数:
- `MICROCMS_SERVICE_DOMAIN`
- `MICROCMS_API_KEY`

### sakeflow-app（Flutter）
- `flutter run -d chrome` - Chromeブラウザで起動
- `flutter build web` - Web用ビルド
- `flutter test` - テスト実行
- `flutter pub get` - 依存パッケージインストール

Firebase設定ファイル:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

## コードアーキテクチャ

### Next.js サイト構成
- `app/` ディレクトリでApp Routerとネストレイアウト
- microCMSからのデータ取得はServer Componentで実装
- `components/` ディレクトリでコンポーネント分割＋CSS Modules
- `libs/`（microcms.ts, utils.ts）にユーティリティ関数
- APIクライアントと型定義は `libs/microcms.ts` に集約

### Flutterアプリ構成
- メインエントリでFirebase初期化
- firebase_ui_authによる認証フロー
- HomeScreen, AiLabelScreenなど画面単位でナビゲーション
- 認証・ストレージ・Firestore連携

## 重要ファイル

- `turbo.json` - モノレポのビルドパイプライン設定
- `apps/sakeflow-site/libs/microcms.ts` - CMS APIクライアントと型定義
- `apps/sakeflow-app/lib/main.dart` - Flutterアプリの初期化・ルーティング
- `.github/copilot-instructions.md` - AI開発ガイドライン

## 備考

- sakeflow-siteはPrettier設定に従い整形してください
- 各アプリの `docs/` ディレクトリを参照し、設計・スタイルガイドに従ってください
- 両アプリともFirebaseを利用しますが、サービス設定は異なります
- モノレポは共有パッケージ設計ですが、現状 `packages/` は空です
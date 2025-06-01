# 🚀vdnih projects

これは複数のプロダクトを一元管理するモノレポです。  
Next.js製のWebサイト、Flutterアプリ、共通ライブラリ、ドキュメントなどを含んでいます。


## 📁 ディレクトリ構成

```txt
.
├── apps/
│   ├── sakeflow-site/        # 日本酒ブログサイト (Next.js)
│   ├── sakeflow-app/         # 飲酒ログアプリ (Flutter Web)
│   ├── subtalk-site/         # 字幕ツールLP (Next.js)
│   └── subtalk-prototype/    # Streamlitプロトタイプ
├── packages/
│   ├── firebase-config/      # Firebase初期化共通コード
│   ├── shared-types/         # 型・定数の共通管理
├── docs/                     # 全体の方針やスタイルガイド
├── turbo.json                # Turborepo設定
└── package.json              # モノレポ全体の設定

```


## 📦 各アプリ・パッケージの説明

| パス | 説明 |
|------|------|
| `apps/sakeflow-site` | SSR対応のブログサイト。VercelまたはCloudflare Pagesにデプロイ。 |
| `apps/sakeflow-app` | Flutter製のWebアプリ。Firebase Hostingを利用。 |
| `packages/firebase-config` | 全アプリ共通のFirebase設定。 |
| `docs/` | 命名規則・設計方針・ユースケースを記載。CopilotやCursorなどAIの補助に使用。 |


## 🛠 開発環境構築

### 前提：
- Node.js `>=20`
- npm `>=8`
- Flutter SDK（Flutterアプリがある場合）

### 初期化手順：

```bash
git clone https://github.com/your-org/your-repo.git
cd your-repo
npm install
```


## 🚀 開発コマンド（Turborepo）

コマンド	説明
npm run dev	全体開発用（Next.js/Flutter）
turbo run dev --filter=apps/sakeflow-site	ブログだけを起動
turbo run build	差分ビルド
turbo run docs	ドキュメント関連タスク（例：Lint, 検証など）


## 📊 利用技術スタック
	•	Next.js
	•	Flutter Web
	•	Firebase Hosting, Auth, Firestore
	•	Cloudflare Pages or Vercel
	•	Turborepo
	•	OpenAI API / Whisper (一部プロジェクト)


## 🤖 Copilot / Cursorでの開発支援
	•	各アプリには docs/README.md を設置し、生成AIが仕様に沿ったコードを生成できるようにしています。
	•	ルートの .github/copilot-instructions.md によって、全体の設計ポリシーも明示。


## 📄 ライセンス

MIT License (c) 2025 vdnih

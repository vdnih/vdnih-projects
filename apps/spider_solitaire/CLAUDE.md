
# CLAUDE.md - Spider Solitaire（Flutter Flame版）

このファイルは、Claude Code（claude.ai/code）がFlutter Flameを用いたSpider Solitaireアプリで作業する際のガイドラインを示します。

## プロジェクト概要

Spider Solitaireは、10列のカード列を使い、スーツごとにK〜Aのシーケンスを完成させて除去するソリティアゲームです。

## 技術スタック

- **フレームワーク**: Flutter 3.7+（Dart）
- **ゲームエンジン**: Flame（https://flame-engine.org/）
- **デプロイ**: Web（Flutter Web）、モバイル（iOS/Android）
- **状態管理**: Riverpod または Provider

## ゲームルール

### 基本ルール
- 104枚のカード（2デッキ）
- 10列のカード列（tableau）に54枚配布
- 残り50枚は予備カード（stock）
- 同一スーツのK〜Aシーケンスを完成させて除去
- 8つのシーケンス完成でクリア

### カード配置
- 最初の4列に6枚ずつ（最上段は裏向き、最下段は表向き）
- 残り6列に5枚ずつ（最上段は裏向き、最下段は表向き）
- 予備カードは10枚ずつ5グループ

### 移動ルール
- 表向きカードのみ移動可能
- 数字の降順（K→Q→J→...→A）で配置
- 同一スーツの完成シーケンスは自動除去
- 空列には任意のカードを配置可能
- 予備カードは全列に1枚ずつ配布

## ディレクトリ構造（例）

```
apps/spider-solitaire/
├── CLAUDE.md
├── lib/
│   ├── main.dart           # エントリポイント
│   ├── game/
│   │   ├── game.dart      # ゲーム全体管理
│   │   ├── card.dart      # カードロジック
│   │   ├── tableau.dart   # カード列管理
│   │   ├── stock.dart     # 予備カード管理
│   │   ├── foundation.dart# 完成シーケンス管理
│   │   └── utils.dart     # ユーティリティ
│   ├── ui/
│   │   ├── game_screen.dart # ゲーム画面
│   │   ├── card_widget.dart # カード描画
│   │   └── ...
│   └── assets/
│       └── images/        # カード画像
├── pubspec.yaml           # 依存関係管理
└── README.md              # プロジェクト説明
```

## 開発方針

### コードスタイル
- Dart/Flutterのベストプラクティス遵守
- モジュール化・責務分離
- 型安全性（null safety）
- ドキュメンテーションコメント（///）

### ゲーム設計
- **State Management**: Riverpod/Providerで一元管理
- **Event Handling**: Flameのイベント（タップ、ドラッグ）
- **Animation**: FlameのSprite/Effectでカード移動アニメーション
- **Responsive Design**: 画面サイズに応じたレイアウト

### 主要コンポーネント
1. **GameState**: ゲーム状態管理
2. **Card**: カード表現・ロジック
3. **Tableau**: カード列管理
4. **Stock**: 予備カード管理
5. **Foundation**: 完成シーケンス管理
6. **GameScreen**: UI・描画

## 開発コマンド

```bash
# 依存パッケージインストール
flutter pub get

# Webで開発サーバー起動
flutter run -d chrome

# モバイルで実行
flutter run -d ios
flutter run -d android

# 本番ビルド（Web）
flutter build web

# テスト実行
flutter test
```

## 実装優先度

1. **Phase 1**: 基本ゲームロジック（カード配置、移動、ルール判定）
2. **Phase 2**: UI/UX（タップ・ドラッグ、アニメーション）
3. **Phase 3**: ゲーム機能（undo/redo, hint, statistics）
4. **Phase 4**: 拡張機能（難易度設定、テーマ切り替え）

## 重要な実装ポイント

- カードの重なり順（z-index）管理
- ドラッグ&ドロップ判定（Flameの座標系）
- ゲーム状態の保存・復元（ローカルストレージ等）
- パフォーマンス最適化（Flameの描画・アニメーション）
- アクセシビリティ対応（キーボード操作、スクリーンリーダー）
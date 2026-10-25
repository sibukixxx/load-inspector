# Migration audit — load-inspector

監査日: 2026-10-25。作業中の記録。未実施・未完了を成功扱いしない。

## 正本と比較対象

- 正本: sibukixxx/load-inspector, main `21bce80a19cd55a54868ede03f62b4a1767eaad3`
- 旧実装: sibukixxx/duckdb-load-testing-toolkit, main `ad4495e00fa0dc657284b0b8b3e29744ec8705be`
- 比較単位: 機能・API・入出力契約。名称変更後のファイルだけを機械的に欠落判定しない。

リクエスト単位metrics、DuckDB、baseline/endpoint回帰、latency、performance gate、分散統合、S3、Viewerの実装は名称正規化後に旧実装と対応。HTTP statsの永続化失敗処理とlint対応は作業中。

## 今回の修正と検証

Goの最低版を1.26.10へ更新。既知の標準ライブラリ脆弱性に対応。既存CIは保持し、startup_failureをコードテスト失敗と混同しない。Cloudflare CI移行はplatform #41/#60の検証後に別途確定する。

- テスト・vet・lint・build: 実行中。結果はこのファイルに追記する。
- govulncheck: 実行予定。
- 現行ツリー/公開予定全Git履歴のsecret scan、author表示名・メール確認: 公開前の再確認が必要。
- README Quick Start/外部consumer/ライセンス/リリースtag: 最終確認が必要。
- Public化、匿名clone、Release: 未実施。ゲート未完了のまま公開しない。
- 旧リポジトリ: 保全。削除・archive・force pushは行わない。

環境リセット前の検証結果は現在の作業ツリーの成功証拠として流用しない。

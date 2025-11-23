@~/.config/claude/CLAUDE.md
# Databricks.md

Databricksのコーディングを行う際に順守すべきルールを記載しています。

## アーキテクチャ構成

### データフロー
1. **Bronze層**: スプレッドシート読み込み・企業名寄せ・PDF収集・S3格納・テーブル更新
2. **Silver層**: 企業名寄せ・データ正規化・クレンジング
3. **Gold層**: Silverデータ集約、SNPF連携

### フォルダ構造
```
apps/
├── bronze/          # Bronze層処理
├── silver/          # Silver層処理
├── gold/           # Gold層処理
└── utils/
    ├── env_config.py      # 環境別設定
    ├── s3_client.py       # S3との連携
    └── rds_sources_direct.py  # RDS接続
sql/
└── ddl/table/      # DDL定義ファイル
```

## 技術スタック

- **Databricks**: メインプラットフォーム
- **Delta Lake**: ストレージ形式
- **AWS S3**: PDFファイルストレージ（Assume Role認証）
- **PostgreSQL**: 外部DB
- **SQLAlchemy**: DB接続ライブラリ
- **Google Sheets**: メタデータソース

## Databricksコーディング規約

### ノートブック構造の標準化

#### 必須ヘッダー
```python
# Databricks notebook source
# MAGIC %md
# MAGIC # ノートブックタイトル
# MAGIC
# MAGIC ノートブックの概要説明

# COMMAND ----------
# MAGIC %md
# MAGIC ## 1. 環境設定・初期化
# MAGIC 
# MAGIC Databricks環境の設定とライブラリのインポートを行います。

# COMMAND ----------
from databricks.sdk import WorkspaceClient
from databricks.sdk.dbutils import RemoteDbUtils
from pyspark.sql import SparkSession

dbutils: RemoteDbUtils = WorkspaceClient().dbutils
spark: SparkSession = SparkSession.getActiveSession()

dbutils.widgets.text("env", "dev")
env = dbutils.widgets.get("env")
```

#### 標準セクション構成
- セクション名には連番を付与しない（処理の追加・削除時に番号の振り直しが必要になるため）
```python
# COMMAND ----------
# MAGIC %md
# MAGIC ## セクション名
# MAGIC 
# MAGIC セクションの詳細説明
# MAGIC - 主要な処理内容
# MAGIC - 注意事項やポイント
# MAGIC - 前提条件や依存関係

# COMMAND ----------
# 実際の処理コード
```

#### 必須セクション順序
1. **環境設定・初期化** - Databricks SDK、widgets設定
2. **環境別設定読み込み** - utils/env_config読み込み
3. **処理固有セクション** - メイン処理（3-6セクション程度）
4. **結果確認** - データ表示、統計情報出力
5. **処理完了** - `dbutils.notebook.exit("ok")`

### コーディングスタイル

#### SQLスタイル
```sql
-- カンマを行頭に配置（必須）
SELECT
    corporate_number
    , title
    , doc_type
    , financial_year
FROM table_name
WHERE corporate_number IS NOT NULL
    AND title IS NOT NULL
GROUP BY
    corporate_number
    , title
```

#### Python importルール
```python
# 標準ライブラリ → サードパーティ → Databricks → PySpark の順序
import json
import re
from datetime import datetime

import gspread
from google.oauth2.service_account import Credentials

from databricks.sdk import WorkspaceClient
from databricks.sdk.dbutils import RemoteDbUtils

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, current_timestamp
```

#### 環境設定の統一
```python
# 必ず utils/env_config.py を使用
# MAGIC %run
# MAGIC ../utils/env_config

env_config = get_env_config(env)
catalog = env_config["catalog"]
```

### エラーハンドリングとログ出力

#### 基本原則
- **ノートブック実行前提**: 複雑なtry-catch, ログ出力は不要
- **printによる簡潔な出力**: 処理進捗の把握に必要最小限
- **display()関数の活用**: DataFrameの内容確認

```python
# Good: シンプルな進捗表示
print(f"処理対象レコード数: {df.count()}")
display(df)

# Bad: 複雑なエラーハンドリング
try:
    df = spark.table(table_name)
    logger.info(f"Successfully loaded {df.count()} records")
except Exception as e:
    logger.error(f"Error: {e}")
    raise
```

### テーブル操作の標準化

#### Delta Lake テーブル作成
```python
# DDLファイルを使用（必須）
with open("../../sql/ddl/table/table_name.sql", "r", encoding="utf-8") as f:
    ddl_content = f.read().replace("${catalog}", catalog)

spark.sql(ddl_content)
```

#### テーブル保存
```python
# Delta Lake最適化オプション（必須）
(df.write
 .format("delta")
 .option("delta.autoOptimize.optimizeWrite", "true")
 .option("delta.autoOptimize.autoCompact", "true")
 .mode("overwrite")
 .saveAsTable(table_name))
```

### ファイル命名規約

#### ファイル名パターン
- **オペレーション用（番号付き）**: `NN_ProcessName.py` (例: `01_Setup_CreateTable.py`, `02_ExportSNPF.py`)
- **開発・検証用（番号なし）**: `ProcessName.py` (例: `ValidateMidTermManagementPlan.py`, `ExportIntegratedReport.py`)
- **年度別処理**: `2024/NN_ProcessName.py`

### SQL DDL定義ルール

#### Databricks用DDL
```sql
-- sql/ddl/table/table_name.sql
CREATE TABLE IF NOT EXISTS ${catalog}.schema_name.table_name (
    corporate_number BIGINT COMMENT '法人番号'
    , title STRING COMMENT 'タイトル'
    , created_at TIMESTAMP COMMENT '作成日時'
)
USING DELTA
PARTITIONED BY (partition_column)
TBLPROPERTIES (
    'delta.autoOptimize.optimizeWrite' = 'true',
    'delta.autoOptimize.autoCompact' = 'true'
)
COMMENT 'テーブルの説明';
```

#### PostgreSQL用DDL
```sql
CREATE TABLE IF NOT EXISTS table_name (
    id serial NOT NULL
    , corporate_number bigint NOT NULL
    , title text NULL
    , created_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL
    , updated_at timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL
);

COMMENT ON TABLE table_name IS 'テーブル説明';
COMMENT ON COLUMN table_name.corporate_number IS '法人番号';
```

### パフォーマンス最適化

#### DataFrame操作の最適化
```python
df.cache()  # 複数回参照時
df.createOrReplaceTempView("temp_view")  # SQL使用時
```

**Note**: Delta Lake自動最適化設定は「テーブル操作の標準化」セクションを参照

## 重要な実装パターン

### 環境別テーブル名の動的生成
```python
env_config = get_env_config(env)
catalog = env_config["catalog"]
table_name = f"{catalog}.schema.table"
```

### UDF定義の標準化
```python
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType

def normalize_text(text):
    if text is None:
        return None
    return text.strip().upper()

normalize_udf = udf(normalize_text, StringType())
df = df.withColumn("normalized_column", normalize_udf(col("column")))
```

### 結果確認の標準化
```python
# データ件数と統計
total_count = df.count()
print(f"総件数: {total_count}")

# グループ別統計
stats_df = df.groupBy("category").count().orderBy("category")
display(stats_df)

display(df)
```
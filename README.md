# README #

### What is this repository for? ###

 OpsworksのTimebaseインスタンスの設定を反映する

 ```
lib/runner key, secret, config
lib/runner key, secret, config --dry-run
 ```

## Abstract

### 前提
* azは均一に設定されている
* 設定ファイルに定義されているインスタンス数より多いインスタンスがOpsworksに登録されている

### 仕様
* 各AZ内にて定義上必要となるインスタンス数が対象レイヤーに登録されていない場合
  * レイヤー名、必要とされているインスタンス数をログ出力して処理を終了
* 各AZ内にて既に定義上必要となるインスタンス数以上のTimebaseインスタンスが登楼されている場合
  * Timebase設定を行ったインスタンス以外のTimebase設定はすべて削除する
* レイヤー内の同一時間に対して複数の設定がある場合
  * それぞれ別の設定として処理する(それぞれの設定で定義しているインスタンス数を足した数起動する)

### 例外
* 設定反映をするとダウンタイムが発生する場合(レイヤー内に起動中の24/7 or Timebaseインスタンスがなくなる場合)
  * 設定反映を中断、対象レイヤー名を出力して終了

### そのうち
* 24/7インスタンスの設定
* レイヤー内に登録されているインスタンス数が定義上必要とされる数に満たない場合の自動インスタンス登録

## 実装
Aws::OpsWorks::Client#set_time_based_auto_scaling(instance_id: String, auto_scaling_schedule: Types::WeeklyAutoScalingSchedule)

* 設定ファイルを読み込んでConfigオブジェクトにする
* ConfigをオブジェクトをUTCベースに変換する
* レイヤーに登録されているインスタンス一覧を取得する
* Configオブジェクトからインスタンスに対応付ける

```
{
  "time_zone": '+09:00',
  "stack_name": 'example.com',
  "layers" : {
    "api-server": {
      "mon": [
        {
          "count": 1,
          "time_range": 0-9
        },
        {
          "count": 2,
          "time_range": 22-23
        }
      ],
      "tue": [
        {
          "count": 4,
          "time_range": 18-23
        }
      ]
    }
  }
}

```

# メモ
## Timezone付きのTimebase設定を -> UTCに変換するあたり
入力形式
```
input = { wday: [{time_range(jst): instance_count}], ...}
```
※time_rangeは年月月日までの精度でそれ以下は00:00:00固定

 wdayのキーをすべてばらして配列にする
 ```
 [ {time_range(jst): instance_count}...]
 ```

 1時間単位のインスタンス数の連想配列にする(時間が重複しているものはインスタンス数を合算する)
 ```
 [{time_range(jst): instance_count}...]
 ```

timezoneを UTCに変換
 ```
 [{time_range(utc): instance_count}...]
 ```

 wday毎をキーとした配列にする
 ```
 [ 0: [{time_range(utc): instance_count}...], 1: [...]}
 ```

# README #

### What is this repository for? ###

 OpsworksのTimebaseインスタンスの設定を反映する

 ```
lib/runner key, secret, config
lib/runner key, secret, config --dry-run
 ```

## Config Format

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

## WeeklyScheduleからInstance毎のスケジュールにするあたり

WeeklySchedule
```
{
  mon: {
    '2017-02-14 00:00:00' => 4,
    '2017-02-14 01:00:00' => 4,
    '2017-02-14 02:00:00' => 2,
  },
  tue : {
  }
}
```

インスタンスに優先順位をつけた上でスケジュールに紐付ける
```
{
  mon: {
    '2017-02-14 00:00:00' => [i000, i001, i002, i003],
    '2017-02-14 01:00:00' => [i000, i001, i002, i003],
    '2017-02-14 02:00:00' => [i000, i001],
  },
  tue : {
  }
}
```

1日内でインスタンス毎に時刻を紐付けるように変換

```
{
  mon: {
    i000 => ['2017-02-14 00:00:00', '2017-02-14 01:00:00', '2017-02-14 02:00:00'],
    i001 => ['2017-02-14 00:00:00', '2017-02-14 01:00:00', '2017-02-14 02:00:00'],
    i002 => ['2017-02-14 00:00:00', '2017-02-14 01:00:00'],
    i003 => ['2017-02-14 00:00:00', '2017-02-14 01:00:00'],
  },
  tue {
  }
```
キーをhourのみに変更して24時間単位にする
(aws sdkの仕様上、明示的にofflineに変更したいときはoffを指定する必要がある)
```
{
  mon: {
    i000 => {0 => 'on', 1 => 'on', 2 => 'on', 3 => 'off'...},
    i001 => {0 => 'on', 1 => 'on', 2 => 'on', 3 => 'off'...},
    i002 => {0 => 'on', 1 => 'on', 2 => 'off', 3 => 'off'...},
    i003 => {0 => 'on', 1 => 'on', 2 => 'off', 3 => 'off'...},
  },
```

# TODO
* instance_mapperの戻り値型
* ↑からAws::OpsWorks::Clientset_time_based_auto_scalingが食えるHashに変換するプログラム

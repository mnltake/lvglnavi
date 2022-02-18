# lvglnavi
lvgl GUI guidance navigation
農業用のRTK-GPS / GNSS直進ガイダンス

![image](https://github.com/mnltake/lvglnavi/blob/main/img/01.png?raw=true)

![image](https://github.com/mnltake/lvglnavi/blob/main/img/system.png?raw=true)

# 用意するもの

・ラズパイ3以上（3B,3A+で動作確認済み）

・microSDカード 16GB以上

・simpleRTK2B - Basic Starter Kit based on u-blox ZED-F9P  

https://www.ardusimple.com/product/simplertk2b-basic-starter-kit-ip65/

・電源5V2.4A以上

・3x4キーパッド Navi 操作用

https://www.aitendo.com/product/3644

・1x3スイッチ Shutdown Button
 
https://www.aitendo.com/product/11784

・スマホ テザリング用

・タブレット解像度1024*600以上(amazon Fire7で動作確認)

・RTK基準局補正情報

http://rtk.silentsystem.jp/

http://rtk2go.com:2104/

・(オプション 作業記録用）LINE Notify アクセストークン 
 
https://notify-bot.line.me/ja/

・(オプション 降雨予測用）Yahoo API ID

https://developer.yahoo.co.jp/start/

・(オプション 外部ライトバー）NeopixelLED

https://www.switch-science.com/catalog/5208/

https://qiita.com/m_take/items/e80735e860ce235c1a74

# Raspberry Pi 設定

## Raspberry Pi OS(Legasy) buster

    最新のBullseye だとDisplayなしでVNCを使うときは /boot/config.xtの設定が必要
https://forums.raspberrypi.com/viewtopic.php?t=323294&start=25

## raspi-config

### Wifi /Locate

    jp utf-8

### 解像度- 1024*720

### Interface

    SSH - enable 
    VNC - enable 
    Serial Port - enable 
    Serial Console - disable

## Install Script

```
~$ git clone https://github.com/mnltake/lvglnavi.git
cd lvglnavi/
chmod +x *.sh
chmod +x *.py
./install.sh
nano config.ini.template
# 変更して config.ini で保存
nano str2str-in.sh.template
# 変更して str2str-in.sh で保存
sudo reboot
```

### VNCのアイドルタイムを無効にする

https://help.realvnc.com/hc/en-us/articles/360002251297#server-idletimeout



# F9P u-center setting　(WindowsPC上で)
## download u-center for Windows, v.21.09
https://www.u-blox.com/sites/default/files/u-centersetup_v21.09.zip

### シリアルポートが認識されないとき
https://www.ardusimple.com/com-ports-disappear-after-latest-windows-10-update-and-how-to-resolve-it/
## Firmware Update 
    Tools - Firmware Update - Firmwera image（HPG1.30) - go
https://www.u-blox.com/en/ubx-viewer/view/UBX_F9_100_HPG130.aa1ce2137147f95bbde5532f1b495848.bin?url=https%3A%2F%2Fwww.u-blox.com%2Fsites%2Fdefault%2Ffiles%2FUBX_F9_100_HPG130.aa1ce2137147f95bbde5532f1b495848.bin

## Receiver configurasion 
    Tools - Receiver configurasion -Load configuration -Transferfile ->GNSS
[ubx_f9p_HPG130_posned_pvt_5Hz.txt](https://raw.githubusercontent.com/mnltake/lvglnavi/main/ubx_f9p_HPG130_posned_pvt_5Hz.txt)

    View - Configuration View(Ctrl+F9) 
    - CFG(Configuration) - [0-BBR 1-FLASH 2-I2C-EEPROM 4-SPI-FLASH] - Send
# 配線

## ラズパイ-F9P

|  | RaspberryPi| ←（ubx-relposned pvt)| simpleRTK2B(F9P) || RaspberryPi| （RTCM）→| simpleRTK2B(F9P) |
|:--------|-|-----------:|-|-----------:|------------:|-|-----------:|
|**Default**|USB(ttyACM0)|←(ubx)|USB-POWER||USB(ttyUSB0)|(RTCM)→|USB-XBEE|
|[HAT](https://github.com/mnltake/simpleRTK2BpiHAT) [注] |USB(ttyACM0)|←(ubx)|USB-POWER||GPIO14-15 UART0(ttyAMA0)|(RTCM)→|UART1|
|RPi4|GPIO8-9 UART4(ttyAMA1)|←(ubx)|UART1||GPIO14-15 UART0(ttyAMA0)|(RTCM)→|UART2|

[注]: ヒント　このときF9P　URAT2は空くのでUART2-OUT-NMEA を設定して[Bluetooth モジュール](https://akizukidenshi.com/catalog/g/gM-08690/)を挿すことで他のアプリでも測位データを使用できます（[AgribusNAVI](https://agri-info-design.com/agribus-navi/),[AGOpenGPS](https://github.com/farmerbriantee/AgOpenGPS/)）
  ## 3x4キーパッド

    key_y = BoardPin No.(37 ,35 ,33 ,31 ) =GPIO No.(26 ,19 ,13, 6)
    key_x = BoardPin No. (29 ,23 ,21 )    =GPIO No.(5 ,11 ,9 )
## 1x3スイッチ
    BoardPin No. (9 ,5 ,7 ,11 )    =GPIO No.(GND ,3 ,4 ,17 )

## 電源
    車載の場合キーON やACCでなくバッテリー直結でヒューズ-スイッチ-DC-DC降圧-USBコネクタ
## アンテナ
    前輪軸上中心がベスト
## タブレット取り付け
    VNC Viewer install
https://www.realvnc.com/en/connect/download/viewer/

https://play.google.com/store/apps/details?id=com.realvnc.viewer.android&hl=ja

FireタブレットにGoogle Playをインストールする方法【2022年版】
https://ygkb.jp/6312

    目線やや上
## ワークスイッチ
    作業面積計測用
    BoardPin No. (25 ,19 )    =GPIO No.(GND ,10 )
# 圃場SHP
    圃場SHP読み込み 
    [QGIS](https://qgis.org/ja/site/)などを使って圃場ポリゴンを作り
    座標参照系 EPSG:4326 WGS84
    文字コード UTF-8
    属性テーブルに以下のフィールドを追加します。
    .dbfファイルを直接書き換えても可
    [0]連番[1]面積[2]ID[3]圃場名[5]A-lat[6]A-lon[7]B-lat[8]B-lon

# 起動確認

```
cd ~/lvglnavi
DISPLAY=:0 ./gpsnavi-server.sh
```

実行してメーター画面が表示されたあとでclientを実行

```
./gpsnavi-client.sh
```

成功したら自動起動を設定します

```
 cd ~/lvglnavi
 ./autostartGUI.sh
```

# Q & A

### これはなんですか？
・**A点**「A」(1) ボタン　**B点**「B」(2)ボタン　を登録するとその**基準線**に作業幅分の平行線が引かれます。そのガイダンス線に対してアンテナの位置がどれだけ離れているかを表示します。
### メーターは何？

・***右（赤色）に針があるとき***ガイド線より左に寄っているので **ハンドルを右に回します**

・***左（青色）に針があるとき***ガイド線より右に寄っているので **ハンドルを左に回します**

・1目盛りが1cmで左右50cm以内で針が動きます。

### 中央の数字は何？
・ガイド線から基準線方向に近いときはマイナス、離れているときはプラスの距離を表示しています

### 数字の下の矢印は何？

・基準線の方向を示しています。もし逆をむいているときは「D」(6) ボタンを押して反転させます（Direction)

・機体の方位センサーは使っていないので手動で合わせます。通常のUターン作業では初めに合わせるだけです

・仕様上、工程：0　つまり基準線上では矢印がどちらを向くと正しいかわかりません。動いてみて逆のときは反転させてください

### c は何？
・基準線を平行にオフセットさせた数字です。「C」(3) ボタンを押すとその位置がガイダンス0cmにオフセットされます
### 「P」(SHP)ボタン、「E」ボタン、圃場面積とは何？

・圃場内に入ってから「P（SHP）」(#) ボタンを押すと 圃場SHPファイルに登録してある場合h圃場名と圃場面積が表示されます。/SHP/sample.shpでは現在地の都道府県名が表示されます

・圃場にAB点が登録してある場合、基準線が変更されます。

・手動の基準線に替えたいたい場合は「E」(9)ボタンを押すと切り替わります（Exchange）

・LINE Notify API トークンが登録してある場合、LINEに圃場名と機体名の作業開始のメッセージを送ります

### 作業面積とは何？
・作業機下降を感知するスイッチを付けた場合、作業中の面積が加算されます。「M」(*) ボタンを押すとリセットされます(㎡)

### 左上のXマークは何？
・シャットダウンスイッチです

### 「S」 「W」 「H」 ボタンは何？
・「W」(5)を押すと作業幅が二倍にSを押すともとに戻ります

・隣接耕のときは「S」(4) 一本飛ばしの時は「W」を使います。(Single)(double)

・端までいったら「H」(0)を押すと2倍のHalf つまり作業幅分オフセットされ残りの工程を作業します。


### 「R」ボタンは何？
・Yahoo API IDを登録してある時、その場所の1時間後までの降雨予想を表示します(Rain fall)

### 「V」ボタンは何？
・GUI（メーター）とCUI（レベルバー）の表示切り替えです。レベルバーはデフォルトでは1本4cmです

### 外部ライトバーとは何？
・WS2812BやSK6812内蔵のフルカラーシリアルLEDを繋ぐことでガイダンスを表示できます。
ダブレット画面が直射日光下で見えづらいときに有効です。


### 画面上のボタンを押すとたまに動きがおかしくなります
・改良中です

### WindowsPC以外でu-centerを使うには？
・WINEを使います

https://www.ardusimple.com/question/running-u-center-on-mac-osx-wine/


# トラブルシュート

### ./install.sh 中にエラーが出る

- エラーメッセージをコピーしてIssuesに送ってください
### simpleRTK2Bの [NO RTK] LEDが点灯したまま
・RTK出来ていません。

- 基準局は稼働していますか？
- str2str-in.sh の設定は正しいか？ パーミッションは変更したか？
- sudo sytemctrl status str2str-in.service  でruningになっているか？
- アンテナは受信できるところにあるか？
- u-centerにつないでReceiver - NTRIP Client で補正情報を送ってみる
- XBEE TX-XBEE RXをジャンパーでつないであるか?

https://www.ardusimple.com/simplertk2b-hack-1-unleash-the-usb-power-of-simplertk2b/

### ./gpsnavi-server.sh を実行してメーター画面が出ない

- micropythonが正しくインストール出来ていない
  
### ./gpsnavi-client.sh を実行してレベルバー画面が出ない

- ubx 出力が正しくない。USBケーブルはデータ通信用か？
- config.ini の設定は正しいか？

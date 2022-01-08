# lvglnavi
lvgl GUI guidance navigation

![image](https://github.com/mnltake/lvglnavi/blob/main/img/01.png?raw=true)

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

### 解像度- 1280*720

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
|[HAT](https://github.com/mnltake/simpleRTK2BpiHAT)|USB(ttyACM0)|←(ubx)|USB-POWER||GPIO14-15 UART0(ttyAMA0)|(RTCM)→|UART2|
|RPi4|GPIO8-9 UART4(ttyAMA1)|←(ubx)|UART1||GPIO14-15 UART0(ttyAMA0)|(RTCM)→|UART2|
## 3x4キーパッド

    key_y = BoardPin No.(37 ,35 ,33 ,31 ) =GPIO No.(26 ,19 ,13, 6)
    key_x = BoardPin No. (29 ,23 ,21)    =GPIO No.(5 ,11 ,9 )
## 1x3スイッチ
    BoardPin No. (9 ,5 ,7 ,11)    =GPIO No.(GND ,3 ,4 ,17 )

## 電源
    車載の場合キーON やACCでなくバッテリー直結でヒューズ-スイッチ-DC-DC降圧-USBコネクタ
## アンテナ
    前輪軸上中心がベスト
## タブレット取り付け
    VNC Viewer install
https://www.realvnc.com/en/connect/download/viewer/

    目線やや上
## ワークスイッチ
    作業面積計測用
    BoardPin No. (25 ,19)    =GPIO No.(GND ,10)
# 圃場SHP
    圃場SHP読み込み 
    座標参照系 EPSG:4326 WGS84
    文字コード UTF-8
    [0]連番[1]面積[2]ID[3]圃場名[5]A-lat[6]A-lon[7]B-lat[8]B-lon


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

・基準線の方向を示しています。もし逆をむいているときは「D」(6) ボタンを押して反転させます

・機体の方位センサーは使っていないので手動で合わせます。通常のUターン作業では初めに合わせるだけです

### c はなに？
・基準線を平行にオフセットさせた数字です。「C」(3) ボタンを押すとその位置がガイダンス0cmにオフセットされます
### 「P」(SHP)ボタン、「E」ボタン、圃場面積とは？
・圃場内に入ってから「P（SHP）」(#) ボタンを押すと　圃場SHPファイルに登録してある場合圃場面積が表示されます
・圃場にAB点が登録してある場合基準線が変更されます。
・手動の基準線に替えたいたい場合は「E」(9)ボタンを押すと切り替わります（Exchange）

### 作業面積とは？
・作業機下降を感知するスイッチを付けた場合、作業中の面積が加算されます。「M」(*) ボタンを押すとリセットされます

### 左上のXマークは？
・シャットダウンスイッチです

### 「S」 「W」 「H」 ボタンはなに？
・「W」(5)を押すと作業幅が二倍にSを押すともとに戻ります

・隣接耕のときは「S」(4) 一本飛ばしの時は「W」を使います。
端までいったら「H」(0)を押すと2倍のHalf　つまり作業幅分オフセットされ残りの工程を作業します。


### 「R」ボタンは何？
・Yahoo API IDを登録してある時、その場所の1時間後までの降雨予想を表示します



### 画面上のボタンを押すとたまに動きが変です
・改良中です

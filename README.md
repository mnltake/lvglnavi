# lvglnavi
lvgl GUI guidance navigation

# 用意するもの

・ラズパイ3以上（3B,3A+で動作確認済み）

・microSDカード 16GB以上

・simpleRTK2B - Basic Starter Kit based on u-blox ZED-F9P  

    https://www.ardusimple.com/product/simplertk2b-basic-starter-kit-ip65/

・電源5V2.4A以上

・3x4キーパッド 

    https://www.aitendo.com/product/3644

・1x3スイッチ 
 
    https://www.aitendo.com/product/11784

・スマホ テザリング用

・タブレット解像度1024*600以上(amazon Fire7で動作確認)

・RTK基準局補正情報

    http://rtk.silentsystem.jp/

・(オプション 作業記録用）LINE Notify アクセストークン 
 
    https://notify-bot.line.me/ja/

・(オプション 降雨予測用）Yahoo API ID 

    https://developer.yahoo.co.jp/start/

・(オプション 外部ライトバー）NeopixelLED

    https://www.switch-science.com/catalog/5208/ 
    https://qiita.com/m_take/items/e80735e860ce235c1a74

# Raspberry Pi

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
変更して config.ini で保存
nano str2str-in.sh.template
変更して str2str-in.sh で保存
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

# 配線

## ラズパイ-F9P

|  | RaspberryPi| ←（ubx-relposned pvt)| simpleRTK2B(F9P) || RaspberryPi| （RTCM）→| simpleRTK2B(F9P) |
|:-----------|-|-----------:|-|-----------:|------------:|-|-----------:|
|**Default**|USB(ttyACM0)|←(ubx)|USB-POWER||USB(ttyUSB0)|(RTCM)→|USB-XBEE|
|[HAT](https://github.com/mnltake/simpleRTK2BpiHAT)|USB(ttyACM0)|←(ubx)|USB-POWER||GPIO UART0(ttyAMA0)|(RTCM)→|UART2|
|RPi4|GPIO UART4(ttyAMA1)|←(ubx)|UART1||GPIO UART0(ttyAMA0)|(RTCM)→|UART2|
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
    目線やや上
## 作業機上昇リミットスイッチ
    作業面積計測用
    BoardPin No. (25 ,19)    =GPIO No.(GND ,10)
# 圃場SHP
    圃場SHP読み込み 
    [0]連番[1]面積[2]ID[3]圃場名[5]A-lat[6]A-lon[7]B-lat[8]B-lon


# lvglnavi
lvgl GUI guidance navigation

# 用意するもの

・ラズパイ3以上（3B,3A+で動作確認済み）

・microSDカード　16GB以上

・simpleRTK2B - Basic Starter Kit based on u-blox ZED-F9P  https://www.ardusimple.com/product/simplertk2b-basic-starter-kit-ip65/

・電源5V2.4A以上　車載の場合キーON やACCでなくバッテリー直結でヒューズ-スイッチ-DC-DC降圧-USBコネクタ

・3x4キーパッド　https://www.aitendo.com/product/3644　

・1x3スイッチ　　https://www.aitendo.com/product/11784

・スマホ　テザリング用

・タブレット解像度1024*600以上(amazon Fire7で動作確認）

・RTK基準局補正情報

・(オプション　作業記録用）LINE　Notify　アクセストークン　https://notify-bot.line.me/ja/

・(オプション　降雨予測用）Yahoo API ID https://developer.yahoo.co.jp/start/

・(オプション　外部ライトバー）NeopixelLED　https://www.switch-science.com/catalog/5208/ 
https://qiita.com/m_take/items/e80735e860ce235c1a74

# Raspberry Pi

## Raspberry Pi OS(Legasy) buster

## raspi-config

### Wifi /Locate /SSH /VNC 設定

### 解像度を1280*720

### Serial Port enable /Serial Console disable

## Script
```
~$ git clone https://github.com/mnltake/lvglnavi.git
cd lvglnavi/
chmod +x *.sh
chmod +x *.py
./install.sh
nano config.ini.template
変更して config.ini で保存
nano str2str-in.sh.template
変更して　str2str-in.sh で保存
sudo reboot
```

### vnc idoltime=0

https://help.realvnc.com/hc/en-us/articles/360002251297#server-idletimeout
### LXTerminal 設定

#F9P u-center setting(WindowsPC上でF9PとUSBでつないで)
## download u-center for Windows, v.21.09
https://www.u-blox.com/sites/default/files/u-centersetup_v21.09.zip

### シリアルポートが認識されないとき
## ファームウェアアップデート（HPG1.30)
https://www.u-blox.com/en/ubx-viewer/view/UBX_F9_100_HPG130.aa1ce2137147f95bbde5532f1b495848.bin?url=https%3A%2F%2Fwww.u-blox.com%2Fsites%2Fdefault%2Ffiles%2FUBX_F9_100_HPG130.aa1ce2137147f95bbde5532f1b495848.bin

##Tools - Receiver configurasion 
  -Load configuration -Transferfile ->GNSS
  ubx_f9p_HPG130_posned_pvt_5Hz.txt
# 配線

## ラズパイ-F9P

## 3x4キーパッド

## 1x3スイッチ

## 電源

## アンテナ

## タブレット取り付け

## 作業機上昇リミットスイッチ

# 圃場SHP





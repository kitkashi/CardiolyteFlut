This readme is for the hardware creation of a portable EKG for under 50$!

If you are more interested in __software__, feel free to click on the cardiolyte folder above in order to see the source code.

Otherwise, lets get started with the **DIY EKG monitor hardware tutorial**!

**PARTS**
- 
Here is a general list of what will be needed: 
1. Wet Electrodes 
2. Microcontroller with BLE capabilites, AnalogIN, 3.3V Out, and multiple grounds for battery and board (I would reccommend a raspberry pi pico)
4. Sparkfun AD8232 Signal Clarifier Board
5. 4X AA Battery Case Holder
6. 4X AA Batteries Rechargable NiMH (I recommend NIMH due to them being forgiving to shorting, however you can use whatever battery you'd like if you are electrically experienced) 

Here is a list of the things I bought for my own implementation, however I would recommend getting a better battery case holder, as they were falsely advertised as parallel (they are in series) 
and points of their connections often had contact point issues with the battery.

I also got an ESP32 in this list, but the bluetooth writing was a bit difficult for sending the electrical signals I later found out, and the ESP32 would not be found whenever I scanned with the application. 
https://www.amazon.com/hz/wishlist/ls/3PMYRZBDLZI0Q?type=wishlist&filter=all&sort=date-added&viewType=list


**ASSEMBLY**
-
First for the parts, I would reccomend following SparkFun's Tutorial online, 
https://learn.sparkfun.com/tutorials/ad8232-heart-rate-monitor-hookup-guide/all. 

WIP

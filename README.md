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
7. Solder/Waygos/JumperWires (I used SolidCore wire and solder, but there are other alternatives if you do not know how to solder)

https://www.amazon.com/hz/wishlist/ls/3PMYRZBDLZI0Q?type=wishlist&filter=all&sort=date-added&viewType=list


Above is a list of the things I bought for my own implementation, however I would recommend getting a better battery case holder, as they were falsely advertised as parallel (they are in series) 
and points of their connections often had contact point issues with the battery.

I also got an ESP32 in this list, but the bluetooth writing was a bit difficult for sending the electrical signals I later found out, and the ESP32 would not be found whenever I scanned with the application. 



**ASSEMBLY**
-
First for the parts, I would reccomend reading over SparkFun's Tutorial online, https://learn.sparkfun.com/tutorials/ad8232-heart-rate-monitor-hookup-guide/all.

**Step One** Testing the AD8232 Board:

Connect the ground, 3.3V and analog output on the AD8232 onto their respective pins on the pi pico/microcontroller you picked out. Reference a datasheet beforehand to ensure they are in the proper place!

Test the PiPico with the AD8232 using Arduino IDE 1.**.** version (very important! The new 2.0 IDE has issues with displaying multiple points at a time. Setup a serial read and print at the pin you assigned the output to on the AD8232 and open the plot/graph to see if you can get a proper signal with the clarifying board. 

**Step Two** Testing bluetooth:
Test sending the analogoutput and the time of the reading from the Microcontroller to the app.

You can utilize the Arduino IDE's BLE, platformIO, etc. just ensure that it works before the next step.

**Step Three** Connecting Batteries to Microcontroller:

Make sure to charge the batteries and test them with a multi meter at the output, and check the voltage output is okay for your microcontrollers voltage in range.

Test to see if your battery can power your microcontroller and AD8232 before soldering!

_**MAKE SURE YOU ARE ABSOLUTELY CERTAIN THE SIGNAL IS CLEAR AND THE BLE WORKS BEFOREHAND!**
_
_**YOU WILL BE UNABLE TO PLUG INTO YOUR MICROCONTROLLER ONCE THE BATTERY POWERS IT**
_
My device schematic ended up looking somewhat like this. 

<img width="554" height="354" alt="image" src="https://github.com/user-attachments/assets/9eaa6e13-e261-4e7e-a47f-e4e94b628b1d" />


You can optionally create a CAD case and 3d print it with PLA, there is no shorting with the plastic, and the signal is relatively clear. 


<img width="554" height="354" alt="image" src="https://github.com/user-attachments/assets/208af18b-beba-452e-bff7-c3a1d885aa50" />

Here is my finished product.

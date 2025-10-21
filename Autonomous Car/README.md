AV Car information 

 

Name of Jetson Desktop: MINDS 

Username: minds 

Password: 123456789 

Jetson Nano firmware update 

If version is under 36.3 using Jetson pack 5.1.3 

After done everything, in terminal enter “reboot” and press enter 

Then you will get to 5.0x version of firmware 

Open terminal, type in  “sudo nvbootctrl dump-slots-info" 

Check if its 36.3 

If not, type “sudo apt-get install nvidia-l4t-jetson-orin-nano-qspi-up" in terminal  

There would have a problem shows “failed” 

Type “sudo apt update” and then “sudo apt upgrade” 

Then run the install code again  

After down loading, reboot, you will see version 36.3 and go “ii” 

If 36.3, flash package 6 into the micro sd card 

 

Connecting the PCA9685 to Jetson using I2C pins the bus number is I2C Bus 7 

Connect GND to GND 

Connect VCC to pin #1 (3.3V) 

Connect SCL to pin #5 (I2C1_SCL) 

Connect SDA to pin #3 (I2C1_SDA) 

Connect the receiver or any 6V source through the green port 

Prerequisites: 

FOLLOW STEPS ON THIS VIDEO TO INSTALL REQUIRED LIBRARIES: https://youtu.be/8YKAtpPSEOk?si=rt2NcPVuAsHSgWNl  start at minute 19 to 31. (Might face trouble setting the rules doing the cp command in the video what I did is instead of the cp command I copied the file (99-gpio.rules)  manually into a file in etc/udev/rules.d) 

Steps: 

To Check for the right connection has been made type the command “sudo i2cdetect -y-r 7” you should see either 40 and 70 or 40.  

Connect the servo to one of the pca channels.(Max left turn = 80 degrees, max right turn = 140 degrees, mid position =  110 degrees)  

Connect the ESC power lines to the battery and the power pins to the receiver. Then connect the pwm pin to one of the pca Channels. 

Test codes Available on my github:  https://github.com/BilalMTaleb/Autonomous-Car.git  

It is now Ready! It receives I2C signals from Jetson and transforms it to pwm required for servo and ESC. 

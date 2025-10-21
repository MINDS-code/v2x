from adafruit_servokit import ServoKit
from time import sleep
my_kit = ServoKit(channels= 16,frequency= 100)


left_position = 80
right_position = 140
num_repeats = 5
channel = 0

for _ in range(num_repeats):
    # Move from left to right
    for i in range(left_position, right_position):
        my_kit.servo[channel].angle = i
        sleep(0.01)  # Adjust the sleep time as needed for smoother motion

    # Move from right to left
    for i in range(right_position, left_position, -1):
        my_kit.servo[channel].angle = i
        sleep(0.01)  # Adju

my_kit.servo[channel].angle=110 #set to mid at the end


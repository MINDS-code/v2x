from adafruit_servokit import ServoKit
from time import sleep

# Initialize the ServoKit instance for a 16-channel PWM driver
my_kit = ServoKit(channels=16, frequency=50)

# Define throttle positions
min_throttle = -0.2  # Full reverse (ESC dependent)
neutral_throttle = 0.0  # Neutral (stop)
max_throttle = 0.2  # Full forward
left_position = 80
right_position = 140
ServoCh = 3

# Function to set throttle (0 for stop, 1 for full forward, -1 for full reverse)
def set_throttle(throttle):
    my_kit.continuous_servo[0].throttle = throttle

try:
    while True:
        set_throttle(neutral_throttle)      #go forward
        sleep(5)    #5seconds forward
        for i in range(110, right_position): #turn right slowly
            my_kit.servo[ServoCh].angle = i
            sleep(0.01)  # Adjust the sleep time as needed for smoother motion
        
        set_throttle(neutral_throttle)
        sleep(1) #complete the turn throttle 1 second

        my_kit.servo[ServoCh].angle = 110 #adjust the wheels

# Loop to move forward and backward
except KeyboardInterrupt:
    print("Exiting...")
    set_throttle(neutral_throttle)  # Ensure the motor is stopped when exiting

def clear_all_channels():
    for i in range(16):
        my_kit._pca.channels[i].duty_cycle = 0  # Set duty cycle to 0 to disable the PWM signal

clear_all_channels()

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
    my_kit.continuous_servo[1].throttle = throttle

# Function to send commands
def send_command(command):
    if command == 'F':
        set_throttle(max_throttle)
    elif command == 'S':
        set_throttle(neutral_throttle)
    elif command == 'B':
        set_throttle(min_throttle)
    elif command == 'L':
        set_throttle(max_throttle)
        my_kit.servo[ServoCh].angle = left_position
    elif command == 'R':
        set_throttle(max_throttle)
        my_kit.servo[ServoCh].angle = right_position
    elif command == 'M':
        set_throttle(max_throttle)
        my_kit.servo[ServoCh].angle = 110

    else:
        print("Command not implemented.")

# Loop to move forward and backward
try:
    while True:
        command = input("Enter command (F: Forward, B: Backward, S: Stop): ")
        if command in ['F', 'B', 'S', 'L', 'R', 'M']:
            send_command(command)
        else:
            print("Invalid command. Please enter F, B, S, L, M, R.")
except KeyboardInterrupt:
    print("Exiting...")
    set_throttle(neutral_throttle)  # Ensure the motor is stopped when exiting

def clear_all_channels():
    for i in range(16):
        my_kit._pca.channels[i].duty_cycle = 0  # Set duty cycle to 0 to disable the PWM signal

clear_all_channels()

from adafruit_servokit import ServoKit
from time import sleep

# Initialize the ServoKit instance for a 16-channel PWM driver
my_kit = ServoKit(channels=16, frequency=50)

# Define throttle positions for the ESC
neutral_throttle = 0.0  # Neutral (stop)
max_throttle = 0.2  # Full forward
min_throttle = -0.2  # Full reverse

# Servo positions
left_position = 80
right_position = 140
mid_position = (left_position + right_position) // 2

def clear_all_channels():
    for i in range(16):
        my_kit._pca.channels[i].duty_cycle = 0  # Set duty cycle to 0 to disable the PWM signal



try:
    print("Running ESC and Servo control loop. Press Ctrl+C to terminate.")

    while True:
        # Move ESC forward
        my_kit.continuous_servo[0].throttle = max_throttle
        print("ESC forward")
        sleep(1)  # Move forward for 1 second

        # Move ESC backward
        my_kit.continuous_servo[0].throttle = min_throttle
        print("ESC backward")
        sleep(1)  # Move backward for 1 second

        # Set ESC to neutral
        my_kit.continuous_servo[0].throttle = neutral_throttle
        print("ESC stopped")

        # Move servo to left position
        my_kit.servo[1].angle = left_position
        print("Servo left")
        sleep(1)  # Move left for 1 second

        # Move servo to right position
        my_kit.servo[1].angle = right_position
        print("Servo right")
        sleep(1)  # Move right for 1 second

        # Set servo to mid position
        my_kit.servo[1].angle = mid_position
        print("Servo mid")

except KeyboardInterrupt:
    pass

finally:
    # Ensure both components are set to neutral positions
    my_kit.continuous_servo[0].throttle = neutral_throttle
    my_kit.servo[1].angle = mid_position
    clear_all_channels()
    print("Script terminated. Stopping ESC and setting servo to mid position.")

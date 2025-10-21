# Download measure_object_distance 


import pyrealsense2 as rs
import numpy as np
import cv2

# Configure depth and color streams
pipeline = rs.pipeline()
config = rs.config()
config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)
config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# Start streaming
pipeline.start(config)

def detect_color(hsv_image, lower_color, upper_color):
    mask = cv2.inRange(hsv_image, lower_color, upper_color)
    return mask

def detect_black(gray_image, threshold=30):
    _, mask = cv2.threshold(gray_image, threshold, 255, cv2.THRESH_BINARY_INV)
    return mask

try:
    while True:
        # Wait for a coherent pair of frames: depth and color
        frames = pipeline.wait_for_frames()
        depth_frame = frames.get_depth_frame()
        color_frame = frames.get_color_frame()
        if not depth_frame or not color_frame:
            continue

        # Convert images to numpy arrays
        depth_image = np.asanyarray(depth_frame.get_data())
        color_image = np.asanyarray(color_frame.get_data())

        # Apply colormap on depth image
        depth_colormap = cv2.applyColorMap(cv2.convertScaleAbs(depth_image, alpha=0.03), cv2.COLORMAP_JET)

        # Convert color image to HSV and grayscale
        hsv_image = cv2.cvtColor(color_image, cv2.COLOR_BGR2HSV)
        gray_image = cv2.cvtColor(color_image, cv2.COLOR_BGR2GRAY)

        # Define color ranges for detection
        colors = {
            'Blue': (np.array([100, 150, 0]), np.array([140, 255, 255])),
        }

        # Detect and process each color
        for color_name, (lower_color, upper_color) in colors.items():
            mask = detect_color(hsv_image, lower_color, upper_color)
            result = cv2.bitwise_and(color_image, color_image, mask=mask)

            # Find contours of the detected object
            contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
            print(f"Number of {color_name} contours found: {len(contours)}")

            for contour in contours:
                if cv2.contourArea(contour) > 500:  # Filter out small contours
                    (x, y, w, h) = cv2.boundingRect(contour)
                    # Draw the bounding box
                    cv2.rectangle(color_image, (x, y), (x + w, y + h), (0, 255, 0), 2)

                    # Calculate the center of the bounding box
                    cx = x + w // 2
                    cy = y + h // 2

                    # Get the depth value at the center of the bounding box
                    depth = depth_frame.get_distance(cx, cy)

                    # Display distance only if the object is within 1.5 meters
                    if depth < 1.5:
                        cv2.putText(color_image, f'{color_name} - {depth:.2f}m', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (36, 255, 12), 2)

        # Detect black objects
        black_mask = detect_black(gray_image)
        black_contours, _ = cv2.findContours(black_mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        print(f"Number of black contours found: {len(black_contours)}")

        for contour in black_contours:
            if cv2.contourArea(contour) > 500:  # Filter out small contours
                (x, y, w, h) = cv2.boundingRect(contour)
                # Draw the bounding box
                cv2.rectangle(color_image, (x, y), (x + w, y + h), (0, 0, 255), 2)  # Red for black objects

                # Calculate the center of the bounding box
                cx = x + w // 2
                cy = y + h // 2

                # Get the depth value at the center of the bounding box
                depth = depth_frame.get_distance(cx, cy)

                # Display distance only if the object is within 1.5 meters
                if depth < 1.5:
                    cv2.putText(color_image, f'Black - {depth:.2f}m', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (36, 255, 12), 2)

        # Stack both images horizontally
        images = np.hstack((color_image, depth_colormap))

        # Show images
        cv2.imshow('RealSense', images)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

finally:
    # Stop streaming
    pipeline.stop()
    cv2.destroyAllWindows()


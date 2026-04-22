import sys
import cv2
import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision

class HandGestureTracker:
    def __init__(self):
        self.cap = cv2.VideoCapture(0)
        base_options = python.BaseOptions(
            model_asset_path=".volumes/hand_landmarker.task"
        )
        options = vision.HandLandmarkerOptions(
            base_options=base_options,
            num_hands=1,
            min_hand_detection_confidence=0.7,
        )
        self.detector = vision.HandLandmarker.create_from_options(options)

    def get_finger_states(self, landmarks):
        buffer = []
        for landmark in landmarks:
            buffer.append(str(landmark.x))
            buffer.append(str(landmark.y))
        line = ','.join(buffer)

        with open(".volumes/hand.csv", "a") as hand_file:
            hand_file.write(line + '\n')

    def run(self):
        while True:
            ret, frame = self.cap.read()
            if not ret:
                break
            rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb)
            result = self.detector.detect(mp_image)
            if result.hand_landmarks:
                for hand_landmarks in result.hand_landmarks:
                    self.get_finger_states(hand_landmarks)
            if cv2.waitKey(1) & 0xFF == 27:
                break
        self.cap.release()
        cv2.destroyAllWindows()

if __name__ == "__main__":
    tracker = HandGestureTracker()
    tracker.run()
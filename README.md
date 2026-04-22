# 🖐 Hand Tracker

Real-time hand landmark renderer using **MediaPipe**, **WebSockets**, and **HTML Canvas**. Move your hand in front of your webcam and see it drawn live in the browser.

---

## How It Works

```
Webcam → MediaPipe (Python) → hand.csv → Node.js fs.watch → WebSocket → Browser Canvas
```

- **Python** captures webcam frames and detects 21 hand landmarks using MediaPipe
- **Node.js** watches `.volumes/hand.csv` for changes and streams the latest frame over WebSocket
- **Browser** receives the data and draws the hand skeleton on an HTML canvas in real time

---

## Requirements

- Node.js 18+
- Python 3.8+
- pip3
- wget
- A webcam

---

## Quick Start

```bash
git clone https://github.com/ojhaanmol/hand-skeleton.git
cd hand-skeleton
./test-it-for-yourself.sh
```

Then open `modules/index-coordinates.html` in your browser.

That's it. One command does everything:
- Creates `.volumes/` folder
- Installs Node.js dependencies
- Downloads the MediaPipe hand landmark model
- Installs Python dependencies
- Starts Python and WebSocket server in parallel

---

## Project Structure

```
hand-tracker/
├── test-it-for-yourself.sh                                      # one-click setup and start
├── package.json
└── .volumes/
    ├── hand_landmarker.task                                     # downloaded on first run
    └── hand.csv                                                 # written each frame, watched by server
└── modules
    ├── hand_gesture_tracker_single_hand_file.py                 # mediapipe webcam → hand.csv
    ├── ws-server-l1.js                                          # fs.watch → websocket server
    ├── index-coordinates.html                                   # canvas renderer

```

---

## Hand Landmarks

MediaPipe detects 21 landmarks per hand. This project maps them to fingers as follows:

| Points | Finger  |
|--------|---------|
| 0–4    | Thumb   |
| 5–8    | Index   |
| 9–12   | Middle  |
| 13–16  | Ring    |
| 17–20  | Pinky   |

---

## Controls

| Key      | Action          |
|----------|-----------------|
| `Ctrl+C` | Stop everything |
| `Esc`    | Stop webcam     |

---

## Configuration

**Change number of hands tracked** — in `hand.py`:
```python
options = vision.HandLandmarkerOptions(
    num_hands=2,  # default is 1
    ...
)
```

**Mirror the hand** — in `index.html` `drawLine()`:
```js
ctx.moveTo((1 - x1) * 1000, y1 * 1000);
ctx.lineTo((1 - x2) * 1000, y2 * 1000);
```

**Change WebSocket port** — in `server.js`:
```js
server.listen(3000); // change to any free port
```
And update the browser to match:
```js
const ws = new WebSocket('ws://localhost:3000');
```

---

## Stopping

`Ctrl+C` in the terminal kills both the Python and Node processes cleanly.

---

## .gitignore

```
.volumes/
node_modules/
```

---

## License

MIT

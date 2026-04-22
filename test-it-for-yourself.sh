#!/bin/bash
set -e  # stop on any error

echo "🚀 Starting hand tracker setup..."

# ── 1. Create volumes folder ──────────────────────────────────────────
mkdir -p .volumes
echo "✅ .volumes/ ready"

# ── 2. Install JS dependencies ────────────────────────────────────────
npm install
echo "✅ Node deps installed"

# ── 3. Download model (skip if exists) ───────────────────────────────
MODEL=".volumes/hand_landmarker.task"
if [ -f "$MODEL" ]; then
  echo "✅ Model already exists, skipping download"
else
  wget -q --show-progress \
    https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task \
    -O "$MODEL"
  echo "✅ Model downloaded"
fi

# ── 4. Install Python dependencies ───────────────────────────────────
pip3 install mediapipe opencv-python
echo "✅ Python deps installed"

# ── 5. Start both processes ───────────────────────────────────────────
echo "🖐  Starting hand tracker..."
python3 -u ./modules/hand_gesture_tracker_single_hand_file.py &
PYTHON_PID=$!

node modules/ws-server-l1.js &
NODE_PID=$!

echo "✅ Running — Python PID: $PYTHON_PID | Node PID: $NODE_PID"
echo "   Press Ctrl+C to stop both"

# ── 6. Kill both on exit ──────────────────────────────────────────────
trap "echo '🛑 Stopping...'; kill $PYTHON_PID $NODE_PID 2>/dev/null; exit" SIGINT SIGTERM

wait
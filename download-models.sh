#!/usr/bin/env sh
# Downloads the face recognition library and models into ./vendor so the app works offline.
# Run once from this folder:  sh download-models.sh
set -e
V=1.7.12
B="https://cdn.jsdelivr.net/npm/@vladmandic/face-api@$V"
mkdir -p vendor/models
curl -fL "$B/dist/face-api.js" -o vendor/face-api.js
for f in tiny_face_detector_model face_landmark_68_model face_recognition_model; do
  curl -fL "$B/model/$f-weights_manifest.json" -o "vendor/models/$f-weights_manifest.json"
  curl -fL "$B/model/$f.bin" -o "vendor/models/$f.bin"
done
echo "Done. Serve this folder (see README) and reload the page."

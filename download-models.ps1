# Downloads the face recognition library and models into .\vendor so the app works offline.
# Run once from this folder in PowerShell:  .\download-models.ps1
$ErrorActionPreference = "Stop"
$v = "1.7.12"
$b = "https://cdn.jsdelivr.net/npm/@vladmandic/face-api@$v"
New-Item -ItemType Directory -Force -Path "vendor\models" | Out-Null
Invoke-WebRequest "$b/dist/face-api.js" -OutFile "vendor\face-api.js"
foreach ($f in "tiny_face_detector_model","face_landmark_68_model","face_recognition_model") {
  Invoke-WebRequest "$b/model/$f-weights_manifest.json" -OutFile "vendor\models\$f-weights_manifest.json"
  Invoke-WebRequest "$b/model/$f.bin" -OutFile "vendor\models\$f.bin"
}
Write-Host "Done. Serve this folder (see README) and reload the page."

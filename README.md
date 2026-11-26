# OJT Face Punch

A shared time in / time out kiosk for OJT students. The webcam recognizes each student's face and records **Time in, Lunch out, Lunch in, Time out** on that student's own record automatically. No accounts, no logins, no supervisor approval. It also generates each student's **Civil Service Form No. 48 (Daily Time Record)** in the DAR style, two copies per A4 page.

It is a static site: one `index.html`, no server, no build step.

## How it works

1. **Students tab:** type a name, tick the consent box, and press *Add student and enroll face*. The camera takes 5 samples while the student turns their head a little.
2. **Punch tab:** leave the camera running on a shared computer. When a student steps up and holds still for about a second, the app picks the next slot for them (Time in, Lunch out, Lunch in, Time out), saves a small photo, and shows a confirmation with a beep.
3. **Month log:** shows each student's times, hours and punch photos, and lets you correct a time by hand.
4. **DTR form:** prints or saves the form as PDF, or downloads Excel / CSV.

Hours rules, work days, required hours and end date are in Settings. By default time before 6:00 AM is recorded but counted from 6:00 AM, and overtime is counted.

## Run it

The camera only works on **https** or **localhost**. Pick one:

**A. GitHub Pages (easiest)**
1. Create a repository and upload these files.
2. Settings, Pages, set **Source** to **GitHub Actions**, then push to `main`.
3. Open `https://<your-username>.github.io/<repository>/` on the kiosk computer.

**B. Locally**
```
cd ojt-face-punch
python -m http.server 8000
```
Then open `http://localhost:8000` in Chrome or Edge.

On first start the app downloads the face library and models (about 7 MB) from the jsDelivr CDN, so it needs internet once.

### Offline copy (optional)

Run `sh download-models.sh` (macOS / Linux) or `.\download-models.ps1` (Windows PowerShell) once. It saves the library and models into `vendor/`, which the app tries first. Serve the folder with option B.

## Important: one shared device

There is no server and no account, so **all records live in the browser of the computer you use** (`localStorage` plus IndexedDB for photos). Every student must punch on that same computer and browser. Use *Settings, Backup* to download a backup file regularly. Clearing browser data erases everything.

## Settings worth knowing

- **Punch automatically:** on by default. Turn it off to show a confirm button instead.
- **Match strictness:** lower is stricter. If the right person is not recognized, raise it a little. If the wrong person is matched, lower it.
- **Seconds before the same person can punch again:** 60 by default, so a student standing in front of the camera does not punch twice.
- **Require one blink:** helps against a photo held up to the camera. Test it on your own camera before relying on it.
- **PIN lock:** with a PIN set, editing times, enrolling or deleting students, and changing settings need the PIN. Punching and printing stay open. It re-locks after 5 minutes without activity.

## Privacy

A face is biometric, sensitive personal information (in the Philippines, see the Data Privacy Act, RA 10173). Before using this with real students:

- Get their consent. The app asks the student to agree before enrolling.
- Tell them what is stored (a numeric face template and a small photo per punch), where (this browser only), and how it is deleted (Students tab, Delete).
- Nothing is uploaded anywhere by this app. The only network requests are for the face library, models, fonts and the Excel library.
- Backup files contain face templates. Keep them private.

## Limits you should know about

- It uses the device clock. Someone with access to the computer can change the clock or the browser data.
- Face recognition is not perfect. Twins, poor light, or a very low-quality camera can cause misses or wrong matches. A photo held to the camera can fool it unless the blink option is on, and even then it is not a strong anti-spoofing system.
- Without a server, a determined person at the kiosk can edit stored data with the browser's developer tools. The PIN is a simple guard, not strong security. For stronger protection you would add a small backend that stamps the time and stores photos.

## Troubleshooting

- *Camera blocked or not found:* allow camera access for the site in the address bar and make sure it is `https` or `localhost`.
- *Face recognition could not load:* check the internet connection, or use the offline copy. The manual punch box appears so work can continue without face matching.
- *Not recognized:* enroll again in good light, add more samples with *Add samples*, or raise Match strictness slightly.

## Credits

Face detection and recognition use [`@vladmandic/face-api`](https://github.com/vladmandic/face-api), a maintained fork of face-api.js. Excel export uses SheetJS. Both load from a CDN.

## License

MIT. See `LICENSE`.

## Admin page (register students first)

1. Open the app and click **Admin login**. Default login: username `BEBEBOYS`, password `BEBEBOYKO`.
2. Go to **Students**. Enter name, school, course, required hours and end date, tick the consent box, and **upload 3–5 clear face photos** (front-facing, good light, no mask or cap), or use the camera.
3. Log out. The kiosk now recognizes registered students and punches them in automatically. Faces are stored in the browser's memory (localStorage).
4. Change the admin username/password in **Settings → Admin account**. Only a hash is stored, never the plain password.

**Security note:** the login is a client-side gate, not real security. The default password is visible to anyone who can read this repo, so change it right away and keep the repo private. Data stays in one browser on one computer.

## Punch type boxes
On the Punch tab, pick **Auto**, **Time in**, **Lunch out**, **Lunch in** or **Time out**. Auto records each student's next step. A chosen type is applied to every face recognized until you change it, and the app blocks out-of-order steps (for example, Lunch out before Time in).

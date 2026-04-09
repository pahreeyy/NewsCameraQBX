# 🎥 IME News Camera (v1.2.0)
**Professional News Camera System for FiveM (QBX Core)**

> 🔒 **EXCLUSIVE SCRIPT:** This script is custom-built and exclusively designed for **IME Roleplay**. Unauthorized use, distribution, modification, or resale of this resource outside of the intended server is strictly prohibited.

A high-quality reporter camera feature equipped with a satellite signal system and a **Web-Based Iframe Overlay**. Developed by **Motion Line Media** to bring a realistic, TV-style broadcasting experience to the server.

---

## 🏆 Credits
- **Original Feature by:** Motion Line Media
- **Developed by:** [pahreeyy#2747](https://github.com/pahreeyy)
- **Framework:** QBX Core

---

## ✨ Features
- **🌐 Web-Based Control Room Overlay:** No more typing in-game! The UI is directly linked to an external website (`motionlinemedia.my.id`). Tickers, headlines, and animations are controlled in real-time by operators outside the game.
- **🛰️ Satellite Signal System:** Dynamic signal indicator with audible beeps and a blinking HUD based on the distance to media vehicles or transmitters.
- **📡 Transmitter System:** Deploy a portable satellite transmitter in the field to boost signal range in remote areas.
- **📺 Multi-UI Toggle (G Key):** Switch instantly between:
  1. **Custom Web Overlay** (Motion Line Media Broadcast)
  2. **Cinematic Letterbox** (Movie style)
  3. **Clear HUD** (No UI)
- **💼 Job Restricted:** Fully integrated with the QBX job system (Reporter job).

---

## ⚙️ Configuration
You can easily customize the script behavior in the `config.lua` file:
- **Signal Range:** Adjust `MaxDistance` and `WarningDistance` for satellite reception.
- **Media Vehicles:** Define which vehicle models provide a satellite signal.
- **Job Settings:** Change the required job name (default: `reporter`).
- **Web URL:** To change the overlay source, simply edit the `iframe src` link inside `ui/index.html`.

---

## 🛠 Installation
1. Download the `ime_newscam` folder.
2. Place it into your server's `resources` folder.
3. Ensure your file structure includes the `ui` folder with the web iframe:
   ```text
   /ime_newscam
   ├── client.lua
   ├── server.lua
   ├── config.lua
   ├── fxmanifest.lua
   └── /ui
       ├── index.html
       ├── style.css
       └── script.js
    ```
4. Register the items in `ox_inventory/data/items.lua`:
   ```lua
   ['newscamera'] = {
       label = 'News Camera',
       weight = 500,
       stack = false,
       close = true,
       description = 'A professional camera for live news reporting.',
   },
   ['newstransmitter'] = {
       label = 'News Transmitter',
       weight = 1000,
       stack = true,
       close = true,
       description = 'A portable satellite signal transmitter.',
   },
   ```
5. Add `ensure ime_newscam` to your `server.cfg`.

---

## 🎮 How to Use
1. Equip the **News Camera** item.
2. If the signal is weak, deploy a **News Transmitter** for good signal.
3. Use the camera item to open the **Config Dialog**.
4. Fill in the **Category**, **Main Headline**, and **Summary Text**.
5. Press **[G]** to cycle through UI modes and **[Mouse Wheel]** to zoom.
6. Press **[Backspace]** to exit the camera.

---
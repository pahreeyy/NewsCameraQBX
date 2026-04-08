# 🎥 IME News Camera (v1.0.0)
**Professional News Camera System for FiveM (QBX Core)**

A high-quality reporter camera feature equipped with a satellite signal system. Developed by **Motion Line Media** to enhance the news-reporting roleplay experience on server.

---

## 🏆 Credits
- **Original Feature by:** Motion Line Media
- **Developed by:** [pahreeyy#2747](https://github.com/pahreeyy)
- **Framework:** QBX Core

---

## ✨ Features
- **🛰️ Satellite Signal System:** Dynamic signal indicator with audible beeps and a blinking HUD based on the distance to media vehicles or transmitters.
- **📡 Transmitter System:** Deploy a portable satellite jammer/transmitter in the field to boost signal range in remote areas.
- **🎒 Inventory Integration:** Automatically removes the item when the transmitter is deployed and returns it when picked up.
- **📺 Dynamic UI (G Toggle):** Instant UI switching: Weazel News Overlay, Cinematic Letterbox, or Clear UI.
- **💼 Job Restricted:** Fully integrated with the QBX job system (Reporter job).

---

## ⚙️ Configuration
You can easily customize the script behavior in the `config.lua` file without touching the core logic:

- **Signal Range:** Adjust `MaxDistance` and `WarningDistance` for satellite reception.
- **Media Vehicles:** Define which vehicle models provide a satellite signal (default: `rumpo`).
- **Job Settings:** Change the required job name (default: `reporter`) to match your server's database.

---

## 🛠 Installation
1. Download the `ime_newscam` folder.
2. Place it into your server's `resources` folder.
3. Register the following items in `ox_inventory/data/items.lua`:
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
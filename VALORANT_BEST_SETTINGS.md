# 🎯 VALORANT — BEST SETTINGS GUIDE
> **System:** Dell G5 5505 | AMD Ryzen 5 4600H | AMD RX 5600M | 1920×1080 @ 120Hz  
> **Goal:** Maximum FPS + Competitive Advantage

---

## 📺 VIDEO → GENERAL

| Setting | Best Value | Your Current | Why |
|---|---|---|---|
| Display Mode | **Fullscreen** | ✅ Fullscreen | Lowest input latency, exclusive GPU access |
| Resolution | **1920×1080** | ✅ 1920×1080 | Native = clearest image, no scaling overhead |
| Aspect Ratio Method | **Fill** | ❌ Letterbox | Fill uses full screen, slightly better visibility |
| Limit FPS on Battery | **OFF** | ✅ OFF | Don't cap FPS while gaming on AC |
| Limit FPS in Menus | **ON → 60** | ❌ OFF | Saves GPU heat when in menu, not in match |
| Limit FPS in Background | **ON → 30** | ❌ OFF | Huge temp reduction when alt-tabbed |
| Limit Framerate Always | **OFF** | ✅ OFF | Never cap in-game FPS |

> **💡 Tip:** Setting menu FPS to 60 reduces GPU temp by ~15°C while not affecting gameplay.

---

## 🎨 VIDEO → GRAPHICS QUALITY

| Setting | Best Value | Your Current | Why |
|---|---|---|---|
| Multithreaded Rendering | **ON** | ✅ ON | Uses all 6 cores of your Ryzen 5 4600H — massive FPS gain |
| Material Quality | **LOW** | ❌ (check) | Removes surface detail, big FPS boost |
| Texture Quality | **LOW** | ❌ (check) | Lower VRAM usage, more stable FPS |
| Detail Quality | **LOW** | ❌ (check) | Removes environment clutter |
| UI Quality | **LOW** | ❌ (check) | Minimal gain but every bit counts |
| Vignette | **OFF** | ✅ OFF | Removes screen darkening at edges — better visibility |
| VSync | **OFF** | ✅ OFF | VSync adds 1–2 frames of delay — never use in comp |
| Anti-Aliasing | **MSAA 2x** | ❌ None | 2x gives cleaner edges with minimal FPS cost on your RX 5600M |
| Anisotropic Filtering | **4x** | ✅ 4x | Sweet spot — textures look decent, minimal performance hit |
| Improve Clarity | **OFF** | — | Post-process filter, wastes GPU cycles |
| Experimental Sharpening | **OFF** | — | Can cause visual artifacts |
| Bloom Quality | **OFF** | ✅ OFF | Removes glow effects that obscure enemies |
| Distortion | **OFF** | ✅ OFF | Removes screen distortion from abilities — better clarity |
| Cast Shadows | **OFF** | ✅ OFF | Shadows are the #1 FPS killer — always OFF for competitive |

> **⚡ Anti-Aliasing Note:**
> - `None` = Maximum FPS, but jagged edges (enemies harder to spot at distance)
> - `MSAA 2x` = Recommended balance — cleaner image, ~5% FPS cost
> - `FXAA` = Blurry, avoid
> - `MSAA 4x` = Overkill, not worth it

---

## 🔊 AUDIO (Recommended)

| Setting | Best Value | Why |
|---|---|---|
| Sound Device | Default | Use your main output |
| Master Volume | 75–85% | Balanced |
| Sound Effects Volume | 100% | Hear footsteps clearly |
| Voice-over Volume | 50% | Agent callouts, not critical |
| Music Volume | **0%** | Zero distraction, zero CPU overhead |
| VOIP Volume | 80% | Team comms |

---

## ⚙️ GENERAL (Key Settings)

| Setting | Best Value | Why |
|---|---|---|
| Show Blood | ON | Confirms hits visually |
| Streamer Mode | OFF | Unless streaming |
| Hardware Cursor | ON | Reduces cursor input lag |

---

## 🖱️ MOUSE / CONTROLS (Competitive Standard)

| Setting | Recommended | Why |
|---|---|---|
| Mouse Sensitivity | **0.3 – 0.4** | Low sens = more accurate aim |
| ADS Sensitivity | **1.0** (same) | Consistent muscle memory |
| Raw Input Buffer | **OFF** | Can add subtle delay |
| Scope Sensitivity | **1.0** | Keep consistent |

> **eDPI Formula:** Mouse DPI × In-game Sensitivity
> Most pros use **200–400 eDPI** (e.g., 800 DPI × 0.35 = 280 eDPI)

---

## 🎯 CROSSHAIR (Pro-Style)

```
Color:             White or Cyan (high contrast on all maps)
Outlines:          ON | Opacity 0.5 | Thickness 1
Center Dot:        OFF
Inner Lines:       ON | Length 4 | Thickness 1 | Offset 2 | Opacity 1
Outer Lines:       OFF
Movement Error:    OFF
Firing Error:      OFF
```

> **Why no outer lines?** Static crosshair removes visual noise. Firing error indicators are distracting in comp.

---

## 📊 STATS (Recommended ON)

| Stat | Show? | Why |
|---|---|---|
| Client FPS | ✅ Yes | Monitor performance |
| Server Tick Rate | ✅ Yes | Detect server lag |
| Network RTT (Ping) | ✅ Yes | Know your latency |
| Packet Loss | ✅ Yes | Detect drops early |
| Network Errors | ✅ Yes | Diagnose issues |
| Clock | Optional | — |

---

## 🏆 QUICK REFERENCE — BEST COMPETITIVE SETTINGS

```
✅ Fullscreen | 1920x1080 | Fill
✅ Multithreaded Rendering: ON
✅ All Quality Settings: LOW
✅ VSync: OFF | Vignette: OFF
✅ Anti-Aliasing: MSAA 2x
✅ Anisotropic Filtering: 4x
✅ Bloom: OFF | Distortion: OFF | Cast Shadows: OFF
✅ Limit FPS Battery: OFF
✅ Limit FPS Menus: ON → 60
✅ Limit FPS Background: ON → 30
✅ Limit Framerate Always: OFF
```

---

## 🔧 SYSTEM-LEVEL TIPS (Already in your GAMING_BOOST.bat)

- ✅ Set Valorant process priority to **High** in Task Manager
- ✅ Disable Xbox Game Bar (hampers performance)
- ✅ Use **AMD High Performance** power plan
- ✅ Close Discord overlay if consistently below 144 FPS
- ✅ Keep GPU drivers updated via AMD Adrenalin

---

*Generated for: chamuthu sarahas • CFX Guild*
*Last Updated: April 2026*

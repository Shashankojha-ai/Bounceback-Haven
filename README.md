# Bounceback

> A high-speed 2D endless side-scroller built in Godot 4 that turns collision hazards into kinetic momentum.

---

## Game Overview
In classic endless runners, touching the floor, ceiling, or obstacles ends your run. In **Bounceback**, collisions are your primary survival and scoring tool:
* **Elastic Rebound**: Hitting the floor or ceiling triggers an upward or downward kinetic bounceback with procedural squash-and-stretch.
* **Bounce Combo Multiplier**: Chaining consecutive bounces off surfaces or bumpers builds a **Bounce Combo** (up to **5×**) that multiplies your coin values and distance score.
* **Kinetic Bumpers**: High-tech neon bumpers scattered through the cyber lab that deflect Bouncy-Bot safely at high speed, granting $+150$ bonus points and preserving your combo streak.
* **Hazards**: Multi-angle pulsing electric laser zappers and high-speed tracking missiles.

---

## Controls

| Action | Primary Input | Alternative Inputs |
| :--- | :--- | :--- |
| **Engage Jet Thruster** | `Spacebar` (Hold) | `Left Mouse Button` / `W` / `Up Arrow` |
| **Descend / Gravity** | Release Input | Gravity automatically pulls bot downward |
| **Bounceback** | Automatic | Elastic rebound upon touching Floor, Ceiling, or Bumper |
| **Restart Game** | `Spacebar` / Click Button | Restarts scene immediately upon Game Over |

---

## Project Structure

```
bounceback/
├── project.godot                  # Godot 4 engine configuration & input mappings
├── scenes/
│   ├── main.tscn                  # Main game loop, boundaries, and dynamic spawner
│   ├── player.tscn                # Bouncy-Bot CharacterBody2D entity with particle systems
│   ├── hud.tscn                   # Cyberpunk HUD with meters, coins, and combo badges
│   ├── coin.tscn                  # Collectible energy coin
│   ├── bounce_bumper.tscn         # Kinetic Bumper obstacle with deflection impulse
│   ├── laser_obstacle.tscn        # Electric zapper laser beam hazard
│   └── missile.tscn               # Tracking warning hazard and rocket
├── scripts/
│   ├── main.gd                    # Endless scrolling, spawner loop, and difficulty scaling
│   ├── player.gd                  # Flight physics, bounceback recoil, and combo logic
│   ├── scrolling_background.gd    # Parallax cyberpunk lab grid and boundary rails
│   ├── hud.gd                     # HUD statistics and Game Over screen bindings
│   ├── coin.gd                    # Coin collection and score multipliers
│   ├── bounce_bumper.gd           # Elastic collision trajectory calculations
│   ├── laser_obstacle.gd          # Electric beam rendering and player hit detection
│   └── missile.gd                 # Player tracking and rocket flight
└── assets/
    └── sprites/                   # Custom SVG vector assets for characters, items, and hazards
```

---

## How to Play
1. Open **Godot 4.3+**.
2. Click **Import** and choose this project directory (`project.godot`).
3. Press **F5** (or the Play ▶ button) to launch the game.

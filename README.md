# 🛹 Skater - Ruby Skateboarding Game

A side-scrolling skateboarding game built with Ruby and Gosu where you automatically perform tricks when jumping on rails and ramps!

## 🎮 Gameplay

Watch your stick figure skater cruise through an urban environment, performing automatic tricks on obstacles:
- **Automatic Grinds** - Land on rails to grind with dynamic animations and sparks
- **Air Tricks** - Hit ramps to launch into the air with flips and board spins
- **Combo System** - Chain tricks together for score multipliers
- **Progressive Difficulty** - Speed increases as you travel further

## 🎯 Features

- **Dynamic Animations**
  - Stick figure with articulated limbs
  - Crouching and balancing during grinds
  - Full rotations and kickflips during air tricks
  - Spark effects when grinding rails

- **Parallax Scrolling Background**
  - Moving cityscape with buildings
  - Animated clouds
  - Smooth scrolling ground with lane markers

- **Obstacle Variety**
  - Rails for grinding
  - Ramps for launching
  - Boxes as obstacles

- **Scoring System**
  - Points for distance traveled
  - Bonus points for tricks
  - Combo multipliers for consecutive tricks

## 🚀 Getting Started

### Prerequisites

- Ruby (2.7 or higher recommended)
- Bundler gem

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Tortured-Metaphor/Skater.git
cd Skater
```

2. Install dependencies:
```bash
bundle install
```

3. Run the game:
```bash
ruby main.rb
```

## 🎮 Controls

- **SPACE** - Jump (hold for higher jumps)
- **ESC** - Quit game

The skater moves automatically from left to right. Time your jumps to land on rails and ramps!

## 🏆 Scoring

- **Distance** - Continuous points for traveling
- **Grind Tricks** - 500 points (varies by trick)
- **Air Tricks** - 300 points (varies by trick)
- **Combos** - Multiplier increases with consecutive tricks

## 🛠️ Technical Details

### Dependencies

- **Gosu** (~> 1.4) - 2D game development library for Ruby

### Project Structure

```
Skater/
├── main.rb                 # Entry point
├── lib/
│   ├── game_window.rb     # Main game loop and window
│   ├── skateboarder.rb    # Player character and physics
│   ├── obstacle.rb        # Rails, ramps, and boxes
│   ├── background.rb      # Parallax scrolling scenery
│   └── trick_system.rb    # Trick detection and scoring
├── Gemfile                # Ruby dependencies
└── README.md
```

### Game Architecture

The game uses object-oriented design with separate classes for each game component:
- `GameWindow` manages the game loop, collision detection, and rendering
- `Skateboarder` handles player physics, animations, and trick states
- `Obstacle` defines different obstacle types and their behaviors
- `Background` creates the parallax scrolling environment
- `TrickSystem` manages trick detection, naming, and scoring

## 🎨 Visual Style

- Minimalist stick figure aesthetic
- Vibrant colors for tricks and effects
- Urban skateboarding environment
- Smooth 60 FPS animations

## 🔧 Development

To modify the game:

1. Edit the Ruby files in the `lib/` directory
2. Run `ruby main.rb` to test changes
3. The game window is 1024x768 pixels by default

### Adding New Tricks

Tricks are randomly selected from arrays in `TrickSystem#perform_trick`. Add new trick names to the appropriate arrays:
- Grind tricks: Boardslide, 50-50, Nosegrind, etc.
- Air tricks: Kickflip, Heelflip, 360 Flip, etc.

### Customizing Obstacles

Modify `Obstacle` class to add new obstacle types or adjust existing ones:
- Change dimensions in the `initialize` method
- Add new types to the `random` method
- Customize appearance in the `draw` method

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Add new trick animations
- Create additional obstacle types
- Improve the scoring system
- Add sound effects and music
- Enhance visual effects

## 🐛 Known Issues

- Windows may require additional setup for Gosu gem installation
- Performance may vary on older systems

## 📮 Contact

For issues and suggestions, please use the GitHub issue tracker.

---

Built with ❤️ using Ruby and Gosu

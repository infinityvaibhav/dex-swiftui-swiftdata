# Dex - A Modern Pokedex App

A beautiful and feature-rich Pokedex application built with SwiftUI, allowing users to browse, search, and manage their favorite Pokemon with detailed statistics and information.

## 🎯 Overview

Dex is an iOS/macOS application that provides an intuitive interface to explore and manage Pokemon data. The app leverages the [PokéAPI](https://pokeapi.co/) to fetch comprehensive Pokemon information including stats, types, and sprites.

## ✨ Features

### Core Functionality
- **Browse Pokemon**: View all Pokemon with pagination support (up to Gen 1 - 151 Pokemon)
- **Search & Filter**: Search Pokemon by name with real-time filtering
- **Favorites**: Mark and filter Pokemon as favorites for quick access
- **Detailed View**: Access comprehensive Pokemon information including:
  - Base stats visualization using Swift Charts
  - Multiple type classifications
  - Normal and shiny sprite variants
  - HP, Attack, Defense, Special Attack, Special Defense, and Speed stats

### User Interface
- **Clean List View**: Browse Pokemon in a scrollable list with card-style display
- **Type-based Coloring**: Dynamic color coding based on Pokemon types
- **Sprite Display**: Load and cache both regular and shiny Pokemon sprites
- **Stats Visualization**: Interactive bar charts displaying Pokemon base stats
- **Dark Mode Support**: Full dark mode compatibility

### Data Management
- **Local Persistence**: SwiftData integration for offline access
- **Image Caching**: Cache Pokemon sprites for faster loading
- **Smart Loading**: Load Pokemon sprites on demand with async image loading

### Additional Features
- **Widget Support**: Home screen widget extension (DexWidget)
- **Accessibility**: Full support for system accessibility features
- **Responsive Design**: Optimized for various screen sizes

## 🛠️ Tech Stack

### Framework & Architecture
- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Type-safe, SwiftUI-integrated persistence
- **Combine**: Reactive programming patterns
- **Swift Charts**: Data visualization for Pokemon stats

### Networking & Data
- **URLSession**: HTTP requests with async/await
- **PokéAPI**: Free Pokemon data source
- **Codable**: JSON decoding with custom strategies

### Project Structure
- **DexApp**: Main app entry point and SwiftData configuration
- **Screen/**: UI views (ContentView, DetailView, PokedexCellView, StatsView)
- **APIServices**: Network layer for PokéAPI integration
- **Pokemon**: Data model with Decodable conformance
- **Persistence**: SwiftData configuration
- **Assets**: Pokemon type colors, sprites, and app icons
- **DexWidget**: Home screen widget extension

## 📋 Requirements

- iOS 17.0+ or macOS 14.0+
- Swift 5.9+
- Xcode 15+

## 🚀 Getting Started

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/dex.git
cd dex
```

2. Open the project in Xcode:
```bash
open Dex.xcodeproj
```

3. Build and run:
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### First Launch

- When you first launch the app, no Pokemon will be loaded
- Tap the "Fetch Pokemon" button to populate the database with Pokemon data
- The app will fetch Pokemon from the PokéAPI (this may take a moment on first run)

## 📱 Usage

### Browse Pokemon
1. Launch the app and fetch Pokemon data
2. Scroll through the list of Pokemon
3. Tap on any Pokemon to view detailed information

### Search Pokemon
1. Tap the search icon in the navigation bar
2. Type the Pokemon name to filter results
3. Results update in real-time as you type

### Mark Favorites
- **Quick Toggle**: Swipe left on a Pokemon in the list and tap the star icon
- **Detail View**: Tap the star icon in the Pokemon detail view
- **Filter Favorites**: Tap the star icon in the toolbar to show only favorited Pokemon

### View Pokemon Details
1. Select a Pokemon from the list
2. View comprehensive information:
   - Pokemon sprite (tap to toggle between normal and shiny)
   - Type badges with color coding
   - Base stats visualization chart
   - Favorite status and stats summary

## 📊 Project Structure

```
Dex/
├── Dex/
│   ├── DexApp.swift              # App entry point
│   ├── ContentView.swift         # Main list view
│   ├── Pokemon.swift             # Data model
│   ├── APIServices.swift         # Network layer
│   ├── Persistence.swift         # SwiftData setup
│   ├── Screen/                   # UI Views
│   │   ├── ContentView.swift     # Pokedex list
│   │   ├── PokedexCellView.swift # List item component
│   │   ├── PokemonDetailView.swift # Detail screen
│   │   └── StatsView.swift       # Stats chart view
│   ├── Assets.xcassets/          # Images and colors
│   │   ├── TypeColors/           # Dynamic type colors
│   │   └── [Pokemon sprites]
│   └── samplepokemon.json        # Sample data
├── DexWidget/                    # Widget extension
├── DexTests/                     # Unit tests
└── Dex.xcodeproj                 # Xcode project
```

## 🔄 Data Flow

1. **App Launch**: SwiftData initializes with Pokemon schema
2. **Fetch Pokemon**: APIServices requests data from PokéAPI
3. **JSON Decoding**: Custom decoder maps API response to Pokemon model
4. **Local Storage**: Pokemon stored in SwiftData persistent container
5. **UI Update**: SwiftUI @Query automatically updates views when data changes

## 🎨 Customization

### Pokemon Type Colors
Type-specific colors are stored in `Assets.xcassets/TypeColors/`. You can customize these colors by editing the respective `.colorset` files:
- Bug, Dark, Dragon, Electric, Fairy, Fighting, Fire, Flying, Ghost, Grass, Ground, Ice, Normal, Poison, Psychic, Rock, Steel, Water

### App Theming
Modify `DexApp.swift` to customize:
- SwiftData persistence configuration
- App window group settings

## 🐛 Known Limitations

- Currently supports Generation 1 Pokemon only (151 Pokemon)
- Requires internet connection for initial Pokemon fetch
- Image caching limited to available device storage

## 🔮 Future Enhancements

- [ ] Support for all Pokemon generations
- [ ] Pokemon evolution chains
- [ ] Move and ability information
- [ ] Comprehensive search filters (by type, stats range)
- [ ] Pokemon comparison tool
- [ ] Sync favorites across devices (iCloud)
- [ ] Push notifications for new Pokemon releases
- [ ] Dark mode specific theming

## 🧪 Testing

Run the test suite:
```bash
Cmd + U
```

Tests are located in `DexTests/DexTests.swift`

## 📦 Dependencies

All dependencies are built-in to the iOS/macOS SDKs:
- `SwiftUI`
- `SwiftData`
- `Combine`
- `Charts`
- `Foundation`

## 🌐 API Reference

This project uses the free [PokéAPI](https://pokeapi.co/):

**Base URL**: `https://pokeapi.co/api/v2/pokemon`

**Example Endpoint**:
```
GET https://pokeapi.co/api/v2/pokemon/{id}
```

**Response includes**:
- Basic info (name, ID, types)
- Sprites (normal, shiny, etc.)
- Stats (HP, Attack, Defense, etc.)
- Abilities and moves

## 📝 Code Examples

### Fetching a Pokemon
```swift
let apiService = APIServices()
let pokemon = try await apiService.fetchPokemon(1) // Fetch Bulbasaur
```

### Searching Pokemon
```swift
let query = "pikachu"
let filtered = pokedex.filter { $0.name.localizedStandardContains(query) }
```

### Viewing Pokemon Stats
```swift
let statValue = pokemon.hp  // Access individual stats
let allStats = pokemon.stats  // Access as array for chart
```

## 👤 Author

Created by वैभव उपाध्याय (Vaibhav Upadhyay)

## 📄 License

This project is open source and available under the MIT License. See the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss the proposed changes.

## 🙏 Acknowledgments

- [PokéAPI](https://pokeapi.co/) - For providing free Pokemon data
- Apple's Swift and SwiftUI teams for excellent frameworks
- The Pokemon Company for the beloved Pokemon franchise

## 📞 Support

If you encounter any issues or have suggestions, please open an issue on GitHub.

---

**Made with ❤️ using SwiftUI**

# UalaMap

**UalaMap** is a test application for Uala, enabling users to explore a list of cities, filter them through a search function, and mark cities as favorites for a personalized experience. The app features an adaptive interface that enhances usability by adjusting to device orientation.

## Features

- **City Filtering**: Quickly filters cities in real-time based on user input, showing only cities whose names start with the typed text (case-insensitive). Optimized for speed with a dataset of approximately 200,000 cities.
- **Favorites List**: Users can save cities as favorites, which are stored locally in an SQLite database to retain preferences across sessions. The favorites list supports independent filtering.
- **Responsive UI**: Built with SwiftUI, the app adapts to device orientation:
  - **Portrait Mode**: Displays the city list and map on separate screens.
  - **Landscape Mode**: Offers a split-screen view, showing the city list and map side-by-side for seamless navigation.
  
## Technical Details

- **Efficient Search**: Implements prefix filtering to match city names starting with user input. A pre-sorted, case-insensitive list is used for optimal performance.
- **Local Storage**: Favorites are saved in a SQLite database, ensuring they persist across sessions. The data is loaded on startup for fast access and consistency.
- **SwiftUI Interface**: Provides a dynamic layout that switches between single-screen and split-screen modes based on device orientation.

## Requirements

- **Platform**: iOS (latest version)
- **Language**: Swift (SwiftUI framework)
- **Dependencies**: No third-party libraries

## Usage

1. **Filter Cities**: Type in the search bar to instantly narrow down the list to cities whose names begin with the entered text.
2. **Mark as Favorite**: Tap a city to add it to the favorites list, which can be viewed separately and filtered independently.
3. **View on Map**: Select a city to center the map on its location.
4. **Split-Screen View**: In landscape mode, use the split-screen layout to view the city list and map at the same time.

## Design Decisions

1. **Optimized Data Structure**: A dictionary-based structure supports fast prefix filtering with a large dataset.
2. **Persistent Favorites**: SQLManager handles saving and loading favorites from a local SQLite database, minimizing redundant operations and keeping data in sync.
3. **Thread Safety**: UI updates are managed asynchronously via `DispatchQueue.main` to ensure thread-safety when updating SwiftUI views.


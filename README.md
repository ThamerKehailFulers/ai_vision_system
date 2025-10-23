# AI Vision System

A comprehensive Flutter application built with Clean Architecture and Cubit state management for monitoring and managing camera streams with AI detection capabilities.

## Features

### 🏠 **Dashboard**

- Real-time system overview with key metrics
- Activity monitoring and alerts
- Camera status tracking
- Detection statistics

### 📹 **C4 Camera View**

- 4-camera grid layout display
- **Real internet video streaming** from sample URLs
- Live stream monitoring with auto-play
- Camera selection and interaction
- Multiple video sources:
  - Big Buck Bunny (Blender Foundation)
  - Elephants Dream (matching original design theme)  
  - For Bigger Blazes (action content)
  - Sintel Trailer (high-quality footage)
- Live/Offline status indicators
- Professional monitoring interface

### 👤 **Profile Management**

- User profile with avatar
- Settings and preferences
- Security configuration
- System information

## Architecture

This project follows **Clean Architecture** principles with three main layers:

### 📁 Project Structure

```
lib/
├── core/                      # Core utilities and shared code
│   ├── di/                    # Dependency injection
│   ├── error/                 # Error handling and failures
│   ├── network/               # Network utilities
│   └── usecases/              # Base use case classes
├── features/                  # Feature modules
│   ├── camera/               # Camera functionality
│   │   ├── data/             # Data sources, models, repositories
│   │   ├── domain/           # Entities, use cases, repository interfaces
│   │   └── presentation/     # UI, Cubit, widgets
│   ├── dashboard/            # Dashboard functionality
│   ├── profile/              # Profile functionality
│   └── home/                 # Navigation and main UI
```

### 🏗️ **Clean Architecture Layers**

#### **Data Layer**

- **Data Sources**: Remote and local data sources
- **Models**: Data transfer objects and API models
- **Repositories Implementation**: Concrete implementations of repository interfaces

#### **Domain Layer**

- **Entities**: Business objects
- **Use Cases**: Business logic and rules
- **Repository Interfaces**: Contracts for data access

#### **Presentation Layer**

- **Cubit**: State management using flutter_bloc
- **Pages**: UI screens
- **Widgets**: Reusable UI components

## State Management

### 🧩 **Cubit Implementation**

#### **NavigationCubit**

Manages bottom navigation state and tab switching.

#### **CameraCubit**

Handles camera stream loading, selection, and monitoring states:

- `CameraInitial`: Initial state
- `CameraLoading`: Loading camera streams
- `CameraLoaded`: Streams loaded successfully
- `CameraError`: Error state with message

## Dependencies

### 📦 **Core Dependencies**

- `flutter_bloc: ^8.1.3` - State management
- `equatable: ^2.0.5` - Value equality
- `dartz: ^0.10.1` - Functional programming
- `get_it: ^7.6.4` - Dependency injection
- `injectable: ^2.3.2` - Code generation for DI

### 🎨 **UI & Design**

- `shadcn_ui: ^0.38.5` - Modern UI components
- `camera: ^0.10.5+5` - Camera functionality
- `video_player: ^2.8.1` - Video playback

### 🌐 **Network & Storage**

- `dio: ^5.3.2` - HTTP client
- `shared_preferences: ^2.2.2` - Local storage
- `permission_handler: ^11.0.1` - Runtime permissions

### 🧪 **Testing**

- `bloc_test: ^9.1.5` - Testing for Cubit/Bloc
- `mocktail: ^1.0.1` - Mocking for tests

## Getting Started

### Prerequisites

- Flutter SDK (>=3.9.0)
- Dart SDK
- Android Studio / VS Code
- Device or emulator

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd ai_vision_system
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Generate dependency injection**

```bash
flutter packages pub run build_runner build
```

4. **Run the application**

```bash
flutter run
```

## Usage

### 🚀 **Running the App**

1. **Dashboard Tab**: View system overview, metrics, and recent activity
2. **C4 Camera Tab**: Monitor 4 camera streams in grid layout
3. **Profile Tab**: Manage user settings and view system information

### 🎯 **Key Features**

- **Bottom Navigation**: Switch between Dashboard, Camera, and Profile
- **Live Video Streaming**: Real internet video streams in C4 camera grid
- **Fullscreen Video**: Tap any camera for immersive fullscreen experience
- **Camera Grid**: 4-camera view with live status indicators  
- **Real-time Monitoring**: Live camera stream simulation with auto-play
- **Professional Interface**: Camera monitoring with overlays and selection
- **Modern UI**: Clean, responsive design with shadcn_ui components

## Development

### 🔧 **Code Generation**

Run code generation for dependency injection:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 🧪 **Testing**

```bash
flutter test
```

### 📊 **Code Analysis**

```bash
flutter analyze
```

## Configuration

### 🔑 **Environment Setup**

- Configure camera endpoints in data sources
- Set up API endpoints for dashboard data
- Configure notification settings

### 🎨 **Theming**

The app uses Material 3 design system with:

- Primary color: Blue
- Light theme with modern aesthetics
- Consistent spacing and typography

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Future Enhancements

- [ ] Real camera stream integration
- [ ] AI detection implementation
- [ ] Push notifications
- [ ] Advanced analytics
- [ ] Multiple user roles
- [ ] Cloud storage integration

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the repository.

---

**Built with ❤️ using Flutter and Clean Architecture**

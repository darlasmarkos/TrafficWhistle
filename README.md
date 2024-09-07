# Traffic Whistle/ Incident Reporting  Mobile IOS Application

Welcome to the **Traffic Whistle**, a SwiftUI-based mobile app designed for users to report incidents, upload images, and provide location details to law enforcement. This app leverages Firebase for backend services, including user authentication, Firestore database management, and Firebase Storage for storing images. It also uses CoreLocation and MapKit to manage and display location data. The app is ideal for communities or organizations looking to streamline incident reporting, documentation, and response management.

## Table of Contents

- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Usage](#usage)
- [Models](#models)
- [Screenshots](#screenshots)
- [Testing](#testing)
- [License](#license)

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture to separate the logic from the user interface, ensuring cleaner and more maintainable code. Key components:

 **View**: SwiftUI views that define the UI of the app. - **ViewModel**: Classes that handle data logic and communicate with the Firebase services. - **Model**: Data models (e.g., `User`, `ReportedIncident`) representing the structure of the data.

## Tech Stack

- **SwiftUI**: Frontend framework
- **Firebase**: Authentication, Firestore, and Storage
- **CoreLocation**: For managing user location
- **MapKit**: Interactive maps for geolocation services
- **Combine**: For handling asynchronous operations and observing changes

## Installation

### Prerequisites

- **Xcode 14 or later**
- **CocoaPods** (if you're using additional dependencies for Firebase)
- **Firebase account**: You’ll need to set up Firebase for Authentication, Firestore, and Storage.

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/incident-reporting-app.git
   cd incident-reporting-app
   ```

2. Install the Firebase SDK:
   - Open the project in Xcode.
   - Go to your `AppDelegate` or `SceneDelegate` and follow Firebase’s setup guide to configure your project with the Firebase SDK. 

3. Configure Firebase:
   - Add your `GoogleService-Info.plist` file into the project root.
   - Set up Firestore and Firebase Storage for your app.

4. Build the project in Xcode:
   - Open the `.xcodeproj` file in Xcode.
   - Build and run the project on the simulator or your device.

## Usage

1. **Authentication**: Users can register or log in using Firebase Authentication. Once authenticated, users can access the main app features.
   
2. **Report an Incident**: The user can report an incident by filling out a form, uploading an image, and tagging their location using the integrated map.
   
3. **Manage Reports**: Users can view a history of their reported incidents under the "Reports History" section and delete reports if needed.

4. **Account Settings**: Users can update their preferences, sign out, or delete their accounts from the settings page.

## Models

### User Model
The `User` model defines user attributes such as `id`, `fullname`, `email`, and `userRole`.

```swift
struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let userRole: String
}
```

### ReportedIncident Model
The `ReportedIncident` model contains incident report details such as `id`, `ownerUid`, `type`, `location`, `timestamp`, and `imageUrl`.

```swift
struct ReportedIncident: Identifiable, Codable {
    let id: String
    let ownerUid: String
    let type: String
    let imageUrl: String
    let timestamp: Timestamp
    let location: String
    let info: String
    let isAnonymous: Bool?
}
```

## Screenshots and Demo




## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


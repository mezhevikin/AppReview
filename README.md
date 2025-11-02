# AppReview

⭐️ A tiny library to request review on the AppStore.

This is wrapper around native SKStoreReviewController.

### Review after 3 launches
```swift
AppReview.requestIf(launches: 3)
```

### Review after 5 days
```swift
AppReview.requestIf(days: 5)
```

### Review after 3 launches and 5 days
```swift
AppReview.requestIf(launches: 3, days: 5)
```

### Review without conditions
```swift
AppReview().requestIfNeeded()
```

Use after positive user actions (e.g., completing a purchase).

### Using

```swift
import SwiftUI
import AppReview

@main struct ExampleApp: App {
    
    init() {
        AppReview.requestIf(launches: 5, days: 3)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Swift Package Manager

```
https://github.com/mezhevikin/AppReview.git
```

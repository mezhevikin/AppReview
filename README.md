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

### Review after purchase
```swift
AppReview().requestIfNeeded()
```

<p align="center">
    <img src="https://user-images.githubusercontent.com/973364/192087660-371f7b89-2159-4af6-adc1-a86f38066bd1.png" width="200">
</p>

### Using

You can call AppReview in
* SceneDelegate.sceneWillEnterForeground()
* AppDelegate.applicationDidFinishLaunching()
* ViewController.viewDidLoad()
* View.onAppear()

### Swift Package Manager

```
https://github.com/mezhevikin/AppReview.git
```

### CocoaPods

```
pod 'AppReview', :git => 'https://github.com/mezhevikin/AppReview.git'
```
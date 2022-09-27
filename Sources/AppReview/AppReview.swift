// Mezhevikin Alexey: https://github.com/mezhevikin/AppReview
import StoreKit

public class AppReview {
    
    public let minLaunches: Int
    public let minDays: Int

    public init(minLaunches: Int = 0, minDays: Int = 0) {
        self.minLaunches = minLaunches
        self.minDays = minDays
    }
    
    @discardableResult
    public static func requestIf(launches: Int = 0, days: Int = 0) -> Bool {
        AppReview(minLaunches: launches, minDays: days).requestIfNeeded()
    }
    
    private let ud = UserDefaults.standard
    
    public var launches: Int {
        get { ud.integer(forKey: "AppReviewLaunches") }
        set(value) { ud.set(value, forKey: "AppReviewLaunches") }
    }
    
    public var firstLaunchDate: Date? {
        get { ud.object(forKey: "AppReviewFirstLaunchDate") as? Date }
        set(value) { ud.set(value, forKey: "AppReviewFirstLaunchDate") }
    }
    
    public var lastReviewDate: Date? {
        get { ud.object(forKey: "AppReviewLastReviewDate") as? Date }
        set(value) { ud.set(value, forKey: "AppReviewLastReviewDate") }
    }
    
    public var lastReviewVersion: String? {
        get { ud.string(forKey: "AppReviewLastReviewVersion") }
        set(value) { ud.set(value, forKey: "AppReviewLastReviewVersion") }
    }
    
    public var daysAfterFirstLaunch: Int {
        if let date = firstLaunchDate {
            return daysBetween(date, Date())
        }
        return 0
    }
    
    public var daysAfterLastReview: Int {
        if let date = lastReviewDate {
            return daysBetween(date, Date())
        }
        return 0
    }
    
    public var isNeeded: Bool {
        launches >= minLaunches &&
        daysAfterFirstLaunch >= minDays &&
        (lastReviewDate == nil || daysAfterLastReview >= 125) &&
        lastReviewVersion != version
    }

    @discardableResult
    public func requestIfNeeded() -> Bool {
        if firstLaunchDate == nil { firstLaunchDate = Date() }
        launches += 1
        guard isNeeded else { return false }
        lastReviewDate = Date()
        lastReviewVersion = version
        request()
        return true
    }
    
    private func request() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            #if os(iOS)
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
            #else
            SKStoreReviewController.requestReview()
            #endif
        }
    }
    
    internal var version = Bundle.main.object(
        forInfoDictionaryKey: "CFBundleShortVersionString"
    ) as! String
    
    internal func daysBetween(_ start: Date, _ end: Date) -> Int {
        Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
}

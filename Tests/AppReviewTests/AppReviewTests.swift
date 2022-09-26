import XCTest
@testable import AppReview

final class AppReviewTests: XCTestCase {
    
    override func setUp() {
        UserDefaults.standard.clear()
    }
    
    func testReviewWithMinLaunches() throws {
        let review = AppReview(minLaunches: 3)
        
        // Before
        XCTAssertEqual(review.launches, 0)
        XCTAssertNil(review.firstLaunchDate)
        XCTAssertNil(review.lastReviewDate)
        XCTAssertNil(review.lastReviewVersion)
        
        // Launch 1
        XCTAssertFalse(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 1)
        XCTAssertNotNil(review.firstLaunchDate)
        
        // Launch 2
        XCTAssertFalse(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 2)
        
        // Launch 3 ✅
        XCTAssertTrue(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 3)
        XCTAssertNotNil(review.lastReviewDate)
        XCTAssertNotNil(review.lastReviewVersion)
        
        // Launch 4
        XCTAssertFalse(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 4)
    }
    
    func testReviewWithMinDays() throws {
        let now = Date()
        
        let review = AppReview(minLaunches: 3, minDays: 5)
        
        // Before
        XCTAssertEqual(review.launches, 0)
        XCTAssertNil(review.firstLaunchDate)
        XCTAssertNil(review.lastReviewDate)
        XCTAssertNil(review.lastReviewVersion)
        
        // Launch 1
        XCTAssertFalse(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 1)
        XCTAssertNotNil(review.firstLaunchDate)
        XCTAssertNil(review.lastReviewDate)
        XCTAssertNil(review.lastReviewVersion)
        XCTAssertEqual(review.daysAfterFirstLaunch, 0)
        
        // Launch 2 in 4 days after first launch
        review.firstLaunchDate = now.shiftDays(-4)
        XCTAssertFalse(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 2)
        XCTAssertEqual(review.daysAfterFirstLaunch, 4)
        
        // Launch 3
        XCTAssertFalse(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 3)
        
        // Launch 4 in 5 days after first launch ✅
        review.firstLaunchDate = now.shiftDays(-5)
        XCTAssertTrue(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 4)
        XCTAssertEqual(review.daysAfterFirstLaunch, 5)
        XCTAssertNotNil(review.lastReviewDate)
        XCTAssertNotNil(review.lastReviewVersion)
        
        // Launch 5 in 125 days after last review
        review.lastReviewDate = now.shiftDays(-125)
        XCTAssertFalse(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 5)
        XCTAssertEqual(review.daysAfterLastReview, 125)
        
        // Launch 6 in 125 days after last review and app update ✅
        review.version = "1.0.1"
        let lastReviewDate = review.lastReviewDate
        XCTAssertTrue(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 6)
        XCTAssertNotEqual(review.lastReviewDate, lastReviewDate)
        
        // Launch 7
        XCTAssertFalse(review.requestIfNeeded())
        XCTAssertEqual(review.launches, 7)
    }
    
    func testRequestIf() throws {
        XCTAssertFalse(AppReview.requestIf(launches: 3, days: 0))
        XCTAssertFalse(AppReview.requestIf(launches: 3))
        XCTAssertTrue(AppReview.requestIf(launches: 3))
    }
    
}

private extension UserDefaults {
    func clear() {
        for key in dictionaryRepresentation().keys {
            removeObject(forKey: key)
        }
    }
}

private extension Date {
    func shiftDays(_ shift: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: shift, to: self)!
    }
}

//
//  DietiDeals24Tests.swift
//  DietiDeals24Tests
//
//  Created by Antonio Abbatiello on 12/01/24.
//

import XCTest
@testable import DietiDeals24

final class DietiDeals24Tests: XCTestCase {
    
    var fieldChecker: FieldChecker!
    var descendingPriceChecker: DescendingPriceChecker!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        fieldChecker = FieldChecker()
        descendingPriceChecker = DescendingPriceChecker()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        fieldChecker = nil
        descendingPriceChecker = nil
        super.tearDown()
    }

    // MARK: - Registration tests
    
    
    //Test valid fields
    func testValidFields() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertTrue(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test empty username
    func testEmptyUsername() {
        // Arrange
        let username = ""
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test nil username
    func testNilUsername() {
        // Arrange
        let username: String? = nil
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertThrowsError(try fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test no @ username
    func testNoAtUsername() {
        // Arrange
        let username = "invalidemail.com"
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test no domain username
    func testNoDomainUsername() {
        // Arrange
        let username = "invalidemail@nodomain"
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test empty password
    func testEmptyPassword() {
        // Arrange
        let username = "test@example.com"
        let password = ""
        let confirmPassword = "Password123"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test nil password
    func testNilPassword() {
        // Arrange
        let username = "test@example.com"
        let password: String? = nil
        let confirmPassword = "Password123"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertThrowsError(try fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test password too short
    func testPasswordTooShort() {
            // Arrange
            let username = "test@example.com"
            let password = "1234"
            let confirmPassword = "1234"
            let iban = "AB1234567890123"
            
            // Act & Assert
            XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
        }
    
    //Test password not containing a number
    func testPasswordWithoutNumber() {
        // Arrange
        let username = "test@example.com"
        let password = "Password"
        let confirmPassword = "Password"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }

    //Test passwords not matching
    func testPasswordsNotMatching() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword = "DifferentPassword123"
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test empty confirm password
    func testEmptyConfirmPassword() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword = ""
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test nil confirm password
    func testNilConfirmPassword() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword : String? = nil
        let iban = "AB1234567890123"
        
        // Act & Assert
        XCTAssertThrowsError(try fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test empty iban
    func testEmptyIban() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = ""
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    //Test nil iban
    func testNilIban() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban: String? = nil
        
        // Act & Assert
        XCTAssertThrowsError(try fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }

    //Test IBAN length less than 15 characters
    func testIbanTooShort() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = "AB123456789012"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }

    //Test IBAN length more than 30 characters
    func testIBANTooLong() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = "AB1234567890123456789012345678901"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }

    //Test IBAN format incorrect
    func testInvalidIBANFormat() {
        // Arrange
        let username = "test@example.com"
        let password = "Password123"
        let confirmPassword = "Password123"
        let iban = "123456789012345"
        
        // Act & Assert
        XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
    }
    
    // MARK: - Descending price auction tests
    
    //Test valid fields
    func testValidAuctionFields() throws {
        // Arrange
        let startingPrice = 100
        let minimumPrice = 50
        let decrementAmount = 5
        let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now
        
        // Act & Assert
        XCTAssertTrue(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    
    //Test starting price less than or equal to 0
    func testStartingPriceLessThanOrEqualToZero() {
        // Arrange
        let startingPrice = 0
        let minimumPrice = 50
        let decrementAmount = 5
        let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now
        
        
        
        //Act & Assert
        XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    
    
    //Test nil starting price
    func testNilStartingPrice() {
        // Arrange
        let startingPrice: Int? = nil
        let minimumPrice = 50
        let decrementAmount = 5
        let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now
        
        // Act & Assert
        XCTAssertThrowsError(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    
    
    //Test minimum price less than or equal to 0
    func testMinimumPriceLessThanOrEqualToZero() {
        // Arrange
        let startingPrice = 100
        let minimumPrice = 0
        let decrementAmount = 5
        let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now
        
        // Act & Assert
        XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    
    
    //Test nil minimum price
    func testNilMinimumPrice() {
        // Arrange
        let startingPrice = 100
        let minimumPrice: Int? = nil
        let decrementAmount = 5
        let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

        // Act & Assert
        XCTAssertThrowsError(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    
    //Test decrement amount less than or equal to 0
    func testDecrementAmountLessThanOrEqualToZero() {
        // Arrange
        let startingPrice = 100
        let minimumPrice = 50
        let decrementAmount = 0
        let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now
        
        // Act & Assert
        XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    
    //Test nil minimum price
    func testNilDecrementAmount() {
        // Arrange
        let startingPrice = 100
        let minimumPrice = 50
        let decrementAmount: Int? = nil
        let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

        // Act & Assert
        XCTAssertThrowsError(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    
    //Test starting date in past
    func testStartingDateInPast() {
        // Arrange
        let startingPrice = 100
        let minimumPrice = 50
        let decrementAmount = 5
        let startingDate = Date(timeIntervalSinceNow: -3600) // 1 hour ago
        
        
        // Act & Assert
        XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    
    //Test nil starting date
    func testNilStartingDate() {
        // Arrange
        let startingPrice = 100
        let minimumPrice = 50
        let decrementAmount = 5
        let startingDate: Date? = nil

        // Act & Assert
        XCTAssertThrowsError(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

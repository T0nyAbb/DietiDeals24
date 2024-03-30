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

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
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
    
    //Test fields are nil
       func testFieldsAreNil() {
           // Arrange
           let username: String? = nil
           let password: String? = nil
           let confirmPassword: String? = nil
           let iban: String? = nil
           
           // Act & Assert
           XCTAssertThrowsError(try fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
       }
       
       //Test fields are empty
       func testFieldsAreEmpty() {
           // Arrange
           let username = ""
           let password = ""
           let confirmPassword = ""
           let iban = ""
           
           // Act & Assert
           XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
       }
    
    //Test invalid Email
    func testInvalidEmail() {
            // Arrange
            let username = "invalidemail"
            let password = "Password123"
            let confirmPassword = "Password123"
            let iban = "AB1234567890123"
            
            // Act & Assert
            XCTAssertFalse(try! fieldChecker.checkFields(username: username, password: password, confirmPassword: confirmPassword, iban: iban))
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
    
    //Test empty fields
    func testEmptyFields() {
        // Arrange
        let username = ""
        let password = ""
        let confirmPassword = ""
        let iban = ""
        
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

    //Test IBAN length less than 15 characters
    func testIBANTooShort() {
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
    
    func testValidAuctionFields() throws {
            // Arrange
            let startingPrice = 100
            let minimumPrice = 50
            let decrementAmount = 5
            let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

            // Assert
        XCTAssertTrue(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
        }

        func testMissingFields() {
            // Arrange
            let startingPrice: Int? = nil
            let minimumPrice = 50
            let decrementAmount = 5
            let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

            // Act & Assert
            XCTAssertThrowsError(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
        }

        func testStartingPriceLessThanOrEqualToZero() {
            // Arrange
            let startingPrice = 0
            let minimumPrice = 50
            let decrementAmount = 5
            let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now



            // Assert
            XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
        }

        func testMinimumPriceLessThanOrEqualToZero() {
            // Arrange
            let startingPrice = 100
            let minimumPrice = 0
            let decrementAmount = 5
            let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

            // Assert
            XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
        }

        func testDecrementAmountLessThanOrEqualToZero() {
            // Arrange
            let startingPrice = 100
            let minimumPrice = 50
            let decrementAmount = 0
            let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

            // Assert
            XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
        }
    
    func testDecrementAmountGreaterThanStartingPrice() {
         // Arrange
         let startingPrice = 100
         let minimumPrice = 50
         let decrementAmount = 150
         let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

         // Assert
         XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
     }

        func testMinimumPriceGreaterThanOrEqualToStartingPrice() {
            // Arrange
            let startingPrice = 100
            let minimumPrice = 150
            let decrementAmount = 5
            let startingDate = Date(timeIntervalSinceNow: 3600) // 1 hour from now

            // Assert
            XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
        }

        func testStartingDateInPast() {
            // Arrange
            let startingPrice = 100
            let minimumPrice = 50
            let decrementAmount = 5
            let startingDate = Date(timeIntervalSinceNow: -3600) // 1 hour ago


            // Assert
            XCTAssertFalse(try descendingPriceChecker.checkAuctionFields(startingPrice: startingPrice, minimumPrice: minimumPrice, decrementAmount: decrementAmount, startingDate: startingDate))
        }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

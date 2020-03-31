//
//  MusicaTest.swift
//  MusicaTests
//
//  Created by Bouziane Bey on 31/03/2020.
//  Copyright © 2020 Bouziane Bey. All rights reserved.
//

import XCTest
import Firebase
@testable import Musica

class MusicaTest: XCTestCase {
    
    override class func tearDown() {
        super.tearDown()
        let data = Database.database().reference().child("tests").child("uid")
        data.removeValue()
    }
    
    func testCreateUser() {
        
        let asyncExpectation = expectation(description: "createUserTestOne")
        var testSuccess = false
        let testUser = (email: "machupichu95583@mail.fr", password: "Boubou", firstName: "bb", lastName: "bb")

        Auth.auth().createUser(withEmail: testUser.email, password: testUser.password) { (user, error) in
            if error != nil {
            print("Error: \(error.debugDescription)")
            } else {
            let userProfileInfo = ["firstName" : testUser.firstName,
                                   "lastName" : testUser.lastName,
                                   "email" : testUser.email]
                let backendRef = Database.database().reference().child("tests")
                backendRef.child("uid").setValue(userProfileInfo)
                testSuccess = true
            }
             asyncExpectation.fulfill()
        }

        waitForExpectations(timeout: 10) { (error) in
            XCTAssertTrue(testSuccess)
        }
    }
    
    func testIfEmailIsAlreadyTaken() {
        
        let asyncExpectation = expectation(description: "createUserTestOne")
        var testSuccess = false
        let testUser = (email: "machupichu95583@mail.fr", password: "Boubou", firstName: "bb", lastName: "bb")

        Auth.auth().createUser(withEmail: testUser.email, password: testUser.password) { (user, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                testSuccess = true
            } else {
            let userProfileInfo = ["firstName" : testUser.firstName,
                                   "lastName" : testUser.lastName,
                                   "email" : testUser.email]
                let backendRef = Database.database().reference().child("tests")
                backendRef.child("uid").setValue(userProfileInfo)
            }
             asyncExpectation.fulfill()
        }

        waitForExpectations(timeout: 10) { (error) in
            XCTAssertTrue(testSuccess)
        }
    }
}

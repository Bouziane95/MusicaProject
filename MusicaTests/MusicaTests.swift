//
//  MusicaTests.swift
//  MusicaTests
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import XCTest
@testable import Musica
import Firebase

class MusicaTests: XCTestCase {
    
    
    
//    private let data = MockUser()
//    private let authService = AuthService.instance
//    private let userID = Auth.auth().currentUser?.uid
//    //let uuid = UUID().uuidString
//    private let userName = "nameTest"
//    private let userPassword = "testPassword"
//    private let userAge = "29"
//    private let userEmail = "bouzianeTEST@mail.fr"
//    private let userMusic = "Batteur"
//    private let userSex = "Homme"
//    private let userDescription = "Salut"
//
//
//    func testRegisterNewUserAtFirebaseWhenUserIsCreated(){
//        var authenticationError : AuthenticationError?
//
//        authService.registerUser(withEmail: data.email, andPassword: data.password, gender: data.userGender, name: data.name, age: data.age, musicStyle: data.userMusicStyle, userDescription: data.description, filterParams: data.filterParams) { (success, error) in
//            if success{
//                let expectation = XCTestExpectation(description: "RegisterNewUser")
//                XCTAssertNil(authenticationError)
//                XCTAssertEqual(self.userName, self.data.name)
//                XCTAssertEqual(self.userPassword, self.data.password)
//                XCTAssertEqual(self.userAge, self.data.age)
//                XCTAssertEqual(self.userEmail, self.data.email)
//                XCTAssertEqual(self.userMusic, self.data.userMusicStyle)
//                XCTAssertEqual(self.userSex, self.data.userGender)
//                XCTAssertEqual(self.userDescription, self.data.description)
//                expectation.fulfill()
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//    }
//
//    func testReturnEmailAlreadyInUseWhenFirebaseReturn(){
//        var authenticationError : AuthenticationError?
//
//        authService.registerUser(withEmail: data.email, andPassword: data.password, gender: data.userGender, name: data.name, age: data.age, musicStyle: data.userMusicStyle, userDescription: data.description, filterParams: data.filterParams) { (success, error) in
//            if success {
//                print(success)
//            } else {
//                let expectation = XCTestExpectation(description: "RegisterUserWithAlreadyInUseEmail")
//                XCTAssertNotNil(authenticationError)
//                XCTAssertEqual(authenticationError, AuthenticationError.emailAlreadyInUse)
//                expectation.fulfill()
//            }
//        }
//    }
}

//
//  MusicaTests.swift
//  MusicaTests
//
//  Created by Bouziane Bey on 19/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import XCTest
@testable import Musica

class MusicaTests: XCTestCase {
    
    let authService = AuthService.instance
    
    func testReturnNotNilWhenUserIsCreated(){
        authService.registerUser(withEmail: "test@mail.fr", andPassword: "test", gender: "Homme", name: "test", age: "29", musicStyle: "Batteur", userDescription: "Salut", filterParams: "Homme_Batteur") { (success, error) in
            if success{
                XCTAssertTrue(success)
            } else {
                XCTAssertFalse((error != nil))
            }
        }
    }
    
    func testReturnSuccessWhenUserLogin(){
        authService.loginUser(withEmail: "test@mail.fr", andPassword: "test") { (success, error) in
            if success{
                XCTAssertTrue(success)
            } else {
                XCTAssertFalse((error != nil))
            }
        }
    }
    
    

   

}

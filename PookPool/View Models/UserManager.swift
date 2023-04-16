//
//  UserManager.swift
//  ProtoFi
//
//  Created by Assa Bentzur on 12/04/2023.
//

import Foundation

class UserManager: ObservableObject {
    
    @Published var userID: UserDefaults = UserDefaults.init()
    @Published var userName: String = "User"
    @Published var isLoggedIn: Bool = false
    
    // one user name and password per device
    func setUserID(name: String, password: String = "") {  // TODO: change to secure password and authentication process when connected to cloud
        let Name = String(name)
        
        let Password = String(password)
        userID.setValue(Name, forKey: "UserName")
        userID.setValue(Password, forKey: "Password")
        userName = userID.value(forKey: "UserName") as! String
        isLoggedIn = true
    }
        
    // TODO: deal with this later: add new user id and change user id
//    func changeUserID(name: String, password: String = "") {
//        let Name = String(name)
//        let Password = String(password)
//        userID.setValue(Name, forKey: "User\(Name)")
//        //        userID.setValue(Name, forKey: "\(name)")
//        userID.setValue(Password, forKey: "Password\(Name)\(Password)")
//    }
    
    // TODO: delete user func
}

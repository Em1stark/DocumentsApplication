//
//  DBManager.swift
//  MyDocs
//
//  Created by Алексей Шахов on 07.02.2022.
//

import Foundation
import RealmSwift

protocol DBManager {
    
    func saveUser(user: User)
    
    func saveCategory(user: UserDocument)
    
    func obtainUsers() -> [User]
    
    func obtainCategories() -> [UserDocument]
}

class DBManagerImpl: DBManager{
    
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
    fileprivate lazy var mainRealm2 = try! Realm(configuration: .defaultConfiguration)
    func saveUser(user: User){
        try! mainRealm.write{
            mainRealm.add(user)
        }
    }
    
    func saveCategory(user: UserDocument){
        try! mainRealm2.write{
            mainRealm2.add(user)
        }
    }
    
    func obtainUsers() -> [User] {
        let models = mainRealm.objects(User.self)
        
        return Array(models)
    }
    func obtainCategories() -> [UserDocument] {
        let models = mainRealm2.objects(UserDocument.self)
        
        return Array(models)
    }
    
    
}

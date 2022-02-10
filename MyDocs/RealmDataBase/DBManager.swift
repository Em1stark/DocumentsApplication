//
//  DBManager.swift
//  MyDocs
//
//  Created by Алексей Шахов on 07.02.2022.
//

import Foundation
import RealmSwift
import UIKit

protocol DBManager {
    
    func saveUser(face: String, definition: String)
    
    func saveCategory(nameText: String, index: ObjectId)
    
    func deleteUser(realmDataBaseArray: Results<User>, index: ObjectId, completion: @escaping() -> Void ) // избегающее замыкание
    
    func deleteCategory(userDocumentsArray: Results<UserDocument>, index: ObjectId,  completion: @escaping() -> Void )
    
    func obtainUsers() -> [User]
    
    func obtainCategories() -> [UserDocument]
}

class DBManagerImpl: DBManager{
    
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
    
    func saveUser(face: String, definition: String){
        try! mainRealm.write{
            var userID = mainRealm.objects(User.self).endIndex
            let user = User(face: face, definition: definition, userCategories: [])
            userID += 1
            mainRealm.add(user)
        }
    }
    
    func saveCategory(nameText: String, index: ObjectId){
        try! mainRealm.write{
            for element in mainRealm.objects(User.self).elements where element.id == index {
                var idParent = element.userCategories.endIndex
                let category = UserDocument(nameOfCategory: nameText, idParent: index, arrayOfImages: [])
                element.userCategories.append(category)
                idParent += 1
            }
        }
    }
    
    func deleteUser(realmDataBaseArray: Results<User>, index: ObjectId, completion: @escaping() -> Void){
        guard let userElement = realmDataBaseArray.first(where: {$0.id == index}) else {return}
            let categories = mainRealm.objects(UserDocument.self)
            let images = mainRealm.objects(CategoryImage.self)
            try! mainRealm.write{
                mainRealm.delete(userElement)
                mainRealm.delete(categories.where({$0.idParent == index}))
                mainRealm.delete(images.where({$0.idGrandParent == index}))
                completion()

            }
    }
    
    func deleteCategory(userDocumentsArray: Results<UserDocument>, index: ObjectId, completion: @escaping() -> Void ){
        guard let categoryElement = userDocumentsArray.first(where: {$0.id == index}) else {return}
            let images = mainRealm.objects(CategoryImage.self)
            try! mainRealm.write{
                mainRealm.delete(categoryElement)
                mainRealm.delete(images.where({$0.idParent == index}))
                completion()
            }
    }
    
    
    func obtainUsers() -> [User] {
        let models = mainRealm.objects(User.self)
        
        return Array(models)
    }
    func obtainCategories() -> [UserDocument] {
        let models = mainRealm.objects(UserDocument.self)
        
        return Array(models)
    }
    
    
}

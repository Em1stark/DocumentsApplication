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
    
    func getUserFromData() -> Results<User>
    
    func getCategoryFromData(id: ObjectId) -> Results<UserDocument>
    
    func getImagesFromData() -> Results<CategoryImage>
    
    func saveUser(face: String, definition: String)
    
    func saveCategory(nameText: String, index: ObjectId)
    
    func saveImage(image: Data, idCategory: ObjectId, idUser: ObjectId)
    
    func deleteUser(realmDataBaseArray: Results<User>, index: ObjectId, completion: @escaping() -> Void ) // избегающее замыкание
    
    func deleteCategory(userDocumentsArray: Results<UserDocument>, index: ObjectId,  completion: @escaping() -> Void )
    
    func deleteImage(image: Results<CategoryImage>, index: ObjectId)
    
    func obtainUsers() -> [User]
    
    func obtainCategories() -> [UserDocument]
}

// Realization func for connect with DB

class DBManagerImpl: DBManager{
    
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
    
    func getUserFromData() -> Results<User>{
        
        
        return mainRealm.objects(User.self)
    }
    
    func getCategoryFromData(id: ObjectId) -> Results<UserDocument>{
        
        return mainRealm.objects(UserDocument.self).where({$0.idParent == id})
    }
    
    func getImagesFromData() -> Results<CategoryImage>{
        return mainRealm.objects(CategoryImage.self)

    }

    func saveUser(face: String, definition: String){
        try! mainRealm.write{
            let user = User(face: face, definition: definition, userCategories: [])
            mainRealm.add(user)
        }
    }
    
    func saveCategory(nameText: String, index: ObjectId){
        try! mainRealm.write{
            for element in mainRealm.objects(User.self).elements where element.id == index {
                let category = UserDocument(nameOfCategory: nameText, idParent: index, arrayOfImages: [])
                element.userCategories.append(category)
            }
        }
    }
    
    func saveImage(image: Data, idCategory: ObjectId, idUser: ObjectId){
        try! mainRealm.write{
            for userDocument in mainRealm.objects(UserDocument.self).where({$0.id == idCategory}){
                let addedElementToCategoryImage = CategoryImage(image: image, idParent: userDocument.id, idGrandParent: idUser)
                userDocument.arrayOfImages.append(addedElementToCategoryImage)
                mainRealm.add(userDocument)
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
    
    func deleteImage(image: Results<CategoryImage>, index: ObjectId) {
        let image = mainRealm.objects(CategoryImage.self)
        try! mainRealm.write{
            mainRealm.delete(image.first(where: {$0.id == index})!)
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

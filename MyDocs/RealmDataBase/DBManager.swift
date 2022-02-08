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
    
    func saveCategory(nameText: String, index: Int)
    
    func deleteUser(realmDataBaseArray: Results<User>, tableView: UITableView, indexPath: IndexPath)
    
    func deleteCategory(userDocumentsArray: Results<UserDocument>, tableView: UITableView, indexPath: IndexPath)
    
    func obtainUsers() -> [User]
    
    func obtainCategories() -> [UserDocument]
}

class DBManagerImpl: DBManager{
    
    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration)
    
    func saveUser(face: String, definition: String){
        try! mainRealm.write{
            let nameText = face
            let iconText = definition
            var userID = mainRealm.objects(User.self).endIndex
            let user = User(_id: userID, face: nameText, definition: iconText, userCategories: [])
            userID += 1
            mainRealm.add(user)
        }
    }
    
    func saveCategory(nameText: String, index: Int){
        let nameText = nameText
        let index = index
        try! mainRealm.write{
            for element in mainRealm.objects(User.self).elements where element._id == index {
                var idParent = element.userCategories.endIndex
                let category = UserDocument(_id: ObjectId.generate(), nameOfCategory: nameText, idParent: index)
                element.userCategories.append(category)
                idParent += 1
            }
        }
    }
    
    func deleteUser(realmDataBaseArray: Results<User>, tableView: UITableView, indexPath: IndexPath){
        let realmDataBaseArray = realmDataBaseArray
        let tableView = tableView
        let indexPath = indexPath
        let categories = mainRealm.objects(UserDocument.self)
            try! mainRealm.write{
                mainRealm.delete(realmDataBaseArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                mainRealm.delete(categories.where({$0.idParent == indexPath.row}))
                mainRealm.add(realmDataBaseArray, update: .all)
                
                tableView.reloadData()
            }
    }
    
    func deleteCategory(userDocumentsArray: Results<UserDocument>, tableView: UITableView, indexPath: IndexPath){
        let userDocumentsArray = userDocumentsArray
        let tableView = tableView
        let indexPath = indexPath
            try! mainRealm.write{
                mainRealm.delete(userDocumentsArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
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

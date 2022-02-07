//
//  RealmDataBase.swift
//  MyDocs
//
//  Created by Алексей Шахов on 03.02.2022.
//

import Foundation
import RealmSwift

class User: Object{
    @Persisted(primaryKey: true) var _id = 0
    @Persisted var face: String = ""
    @Persisted var definition: String = ""
    @Persisted var selectedItem: Int = 0
    @Persisted var userCategories = List<UserDocument>()
    
    convenience init(_id: Int, face: String, definition: String) {
        self.init()
        self._id = _id
        self.face = face
        self.definition = definition
//        self.userCategories.append(objectsIn: userCategories)
        }
    
    override var description: String {
        return "ID = \(_id), Smile = \(face), Name = \(definition), Categories: \(userCategories) "
    }
    
}

class UserDocument: Object{
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var nameOfCategory: String = ""
    
    let owners = LinkingObjects(fromType: User.self, property: "userCategories")
    
    convenience init(_id: ObjectId,nameOfCategory: String) {
        self.init()
        self._id = _id
        self.nameOfCategory = nameOfCategory
        }
    override var description: String {
        return "ID = \(_id), Category = \(nameOfCategory)"
    }
        
}


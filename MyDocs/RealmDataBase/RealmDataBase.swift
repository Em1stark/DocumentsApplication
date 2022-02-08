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
    @Persisted var userCategories = List<UserDocument>()
    
    convenience init(_id: Int, face: String, definition: String, userCategories: [UserDocument]) {
        self.init()
        self._id = _id
        self.face = face
        self.definition = definition
        self.userCategories.append(objectsIn: userCategories)
        }
    
    override var description: String {
        return "ID = \(_id), Smile = \(face), Name = \(definition), Categories: \(userCategories) "
    }
}

class UserDocument: Object{
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var idParent = 0
    @Persisted var nameOfCategory: String = ""

  //  var _owner = LinkingObjects(fromType: User.self, property: "userCategories")
    
    convenience init(_id: ObjectId,nameOfCategory: String, idParent: Int) {
        self.init()
        self._id = _id
        self.nameOfCategory = nameOfCategory
        self.idParent = idParent
        }
    
    override var description: String {
        return "ID = \(_id), IDParent = \(idParent), Category = \(nameOfCategory)"
    }
}


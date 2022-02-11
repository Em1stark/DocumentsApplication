//
//  RealmDataBase.swift
//  MyDocs
//
//  Created by Алексей Шахов on 03.02.2022.
//

import Foundation
import RealmSwift

class User: Object{
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var face: String = ""
    @Persisted var definition: String = ""
    @Persisted var userCategories = List<UserDocument>()
    
    convenience init(face: String, definition: String, userCategories: [UserDocument]) {
        self.init()
        self.face = face
        self.definition = definition
        self.userCategories.append(objectsIn: userCategories)
        }
    
    override var description: String {
        return "ID = \(id), Smile = \(face), Name = \(definition), Categories: \(userCategories) "
    }
}

class UserDocument: Object{
    
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var idParent: ObjectId
    @Persisted var nameOfCategory: String = ""
    @Persisted var arrayOfImages = List<CategoryImage>()
  //  var _owner = LinkingObjects(fromType: User.self, property: "userCategories")
    
    convenience init(nameOfCategory: String, idParent: ObjectId, arrayOfImages: [CategoryImage]) {
        self.init()
        self.nameOfCategory = nameOfCategory
        self.idParent = idParent
        self.arrayOfImages.append(objectsIn: arrayOfImages)
        }
    
    override var description: String {
        return "ID = \(_id), IDParent = \(idParent), Category = \(nameOfCategory)"
    }
}

class CategoryImage: Object{
    
    @Persisted(primaryKey: true) var id = ObjectId.generate()
    @Persisted var idParent: ObjectId
    @Persisted var idGrandParent: ObjectId
    @Persisted var image: Data
    
    
    convenience init(image: Data, idParent: ObjectId, idGrandParent: ObjectId) {
        self.init()
        self.image = image
        self.idParent = idParent
        self.idGrandParent = idGrandParent
        
    }
    
}

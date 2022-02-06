//
//  RealmDataBase.swift
//  MyDocs
//
//  Created by Алексей Шахов on 03.02.2022.
//

import Foundation
import RealmSwift


class RealmDataBase: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var face: String = ""
    @Persisted var definition: String = ""
    
    @Persisted var userCategories = List<UserDocumentsDataBase>()
    


}

class UserDocumentsDataBase: Object{
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var nameOfCategory = ""
        
        
}







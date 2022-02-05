//
//  RealmDataBase.swift
//  MyDocs
//
//  Created by Алексей Шахов on 03.02.2022.
//

import Foundation
import RealmSwift


class RealmDataBase: Object{
    @objc dynamic var UserId: Int = 0
    @objc dynamic var face: String = ""
    @objc dynamic var definition: String = ""
    
    var userDocuments = List<UserDocumentsDataBase>()
    
//        override static func primaryKey() -> String? {
//                return "nameCategoryOfDocument"
//            }

}

class UserDocumentsDataBase: Object{
        @objc dynamic var nameCategoryOfDocument = ""
        
        
}







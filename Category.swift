//
//  Category.swift
//  taskapp
//
//  Created by Liu Peiwen on 2021/04/18.
//

import RealmSwift

//カテゴリクラス
class Category: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var categoryName = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

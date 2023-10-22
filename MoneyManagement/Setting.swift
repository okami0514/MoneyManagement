//
//  Setting.swift
//  MoneyManagement
//
//  Created by WEBSYSTEM-MAC29 on 2023/10/22.
//

import RealmSwift

class Setting: Object {
    // 管理用 ID。プライマリーキー
    @Persisted(primaryKey: true) var id: ObjectId

    // 目標貯金額
    @Persisted var goal = ""

    // 収入
    @Persisted var income = ""

    // 日時
    @Persisted var date = Date()

}

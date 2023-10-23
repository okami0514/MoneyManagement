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

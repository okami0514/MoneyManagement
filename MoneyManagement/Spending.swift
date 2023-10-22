import RealmSwift

class Spending: Object {
    // 管理用 ID。プライマリーキー
    @Persisted(primaryKey: true) var id: ObjectId

    // 支出
    @Persisted var spending = ""

    // カテゴリ
    @Persisted var category = ""

    // 日時
    @Persisted var date = Date()

}

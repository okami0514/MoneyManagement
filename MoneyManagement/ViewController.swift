import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    
    var date = Date()
    var spendingArray = try! Realm().objects(Spending.self).sorted(byKeyPath: "date", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBarTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        // 月初の日付を計算
        let startOfMonth = calendar.date(from: components)!
        let currentStartOfMonth = calendar.date(byAdding: DateComponents(day: 1), to: startOfMonth)!
        // 月末の日付を計算
        let currentEndOfMonth = calendar.date(byAdding: DateComponents(month: 1), to: startOfMonth)!
        
        //-----------------------------
        // 前月計算
        let backStartOfMonth = calendar.date(byAdding: DateComponents(month: -1, day: +1), to: startOfMonth)!
        // 月末の日付を計算
        let backEndOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: backStartOfMonth)!
        //-----------------------------
        
        //-----------------------------
        // 翌月を計算
        let nextStartOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: +1), to: startOfMonth)!
        // 月末の日付を計算
        let nextEndOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: nextStartOfMonth)!
        //-----------------------------
        
        let backSettingArray = try! Realm().objects(Setting.self).filter("date >= %@ AND date <= %@", backStartOfMonth, backEndOfMonth).sorted(byKeyPath: "date", ascending: true)
        
        if backSettingArray.count == 0 {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
        
        let nextSettingArray = try! Realm().objects(Setting.self).filter("date >= %@ AND date <= %@", nextStartOfMonth, nextEndOfMonth).sorted(byKeyPath: "date", ascending: true)
        
        if nextSettingArray.count == 0 {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
        
        let settingArray = try! Realm().objects(Setting.self).filter("date >= %@ AND date <= %@", currentStartOfMonth, currentEndOfMonth).sorted(byKeyPath: "date", ascending: true)
        
        if settingArray.count == 0 {
            let settingViewController = self.storyboard?.instantiateViewController(withIdentifier: "Setting")
            self.present(settingViewController!, animated: true, completion: nil)
        }
    }
    
    private func setupNavigationBarTitle() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        // 月初の日付を計算
        let startOfMonth = calendar.date(from: components)!
        let currentStartOfMonth = calendar.date(byAdding: DateComponents(day: 1), to: startOfMonth)!
        // 月末の日付を計算
        let currentEndOfMonth = calendar.date(byAdding: DateComponents(month: 1), to: startOfMonth)!
        
        // 目標取得
        let settingArray = try! Realm().objects(Setting.self).filter("date >= %@ AND date <= %@", currentStartOfMonth, currentEndOfMonth).sorted(byKeyPath: "date", ascending: true)
        
        let setting = settingArray[0]
        
        // 支出取得
        let spendigArray = try! Realm().objects(Spending.self).filter("date >= %@ AND date <= %@", currentStartOfMonth, currentEndOfMonth).sorted(byKeyPath: "date", ascending: true)
        
        var spendingNum : Int = 0
        if spendigArray.count != 0 {
            for spendigDate in spendigArray {
                var spend = 0
                if !spendigDate.spending.isEmpty {
                    spend = Int(spendigDate.spending)
                }
                spendingNum += Int(spendigDate.spending)
            }
        }
        
        let balance = 0

        navigationItem.setTitleView(withTitle: "目標金額:\(String(setting.goal))", subTitile: "収入:\(String(setting.income)) " + "残高:\(balance) " + "支出合計:\(spendingNum)", subTitile2: "支出詳細")
        
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendingArray.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Cellに値を設定する
        let task = spendingArray[indexPath.row]
        cell.textLabel?.text = task.spending + " " + task.category
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.spendingArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        // 前月計算
        let startOfMonth = calendar.date(from: components)!
        let backOfMonth = calendar.date(byAdding: DateComponents(month: -1, day: +1), to: startOfMonth)!
        // 翌月を計算
        let nextOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: +1), to: startOfMonth)!
        // ②Segueの識別子確認
        if segue.identifier == "next" {
            let viewController:ViewController = segue.destination as! ViewController
            viewController.date = nextOfMonth
            
        }else if segue.identifier == "back" {
            let viewController:ViewController = segue.destination as! ViewController
            viewController.date = backOfMonth
        } else {
            let inputViewController:InputViewController = segue.destination as! InputViewController
            
            if segue.identifier == "cellSegue" {
                let indexPath = self.tableView.indexPathForSelectedRow
                inputViewController.task = spendingArray[indexPath!.row]
            } else {
                inputViewController.task = Spending()
            }
        }
    }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension UINavigationItem {

    func setTitleView(withTitle title: String, subTitile: String, subTitile2: String) {

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .black

        let subTitleLabel = UILabel()
        subTitleLabel.text = subTitile
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textColor = .gray
        
        let subTitleLabel2 = UILabel()
        subTitleLabel2.text = subTitile2
        subTitleLabel2.font = .systemFont(ofSize: 14)
        subTitleLabel2.textColor = .gray

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel, subTitleLabel2])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical

        self.titleView = stackView
    }
}

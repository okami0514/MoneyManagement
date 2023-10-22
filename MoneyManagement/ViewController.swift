//
//  ViewController.swift
//  MoneyManagement
//
//  Created by WEBSYSTEM-MAC29 on 2023/10/21.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    // Realmインスタンスを取得する
    let realm = try! Realm()
    
    var date = Date()
    //    let calendar = Calendar.current
    //    let components = calendar.dateComponents([.year, .month], from: date)
    //    // 月初の日付を計算
    //    let startOfMonth = calendar.date(from: components)!
    //
    //    // 月末の日付を計算
    //    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
    var spendingArray = try! Realm().objects(Spending.self).sorted(byKeyPath: "date", ascending: true)
    var settingArray = try! Realm().objects(Setting.self).sorted(byKeyPath: "date", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBarTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if settingArray.count == 0 {
            let settingViewController = SettingViewController() // 新しいView Controllerをインスタンス化
            self.present(settingViewController, animated: true, completion: nil)
        }
    }
    
    private func setupNavigationBarTitle() {
        title = "目標金額:10000収入:500000残高:1111111支出合計:1111111支出詳細"
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        // ②Segueの識別子確認
        if segue.identifier == "next" {
            let viewController:ViewController = segue.destination as! ViewController
            
        }else if segue.identifier == "back" {
            let viewController:ViewController = segue.destination as! ViewController
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


//
//  SettingViewController.swift
//  MoneyManagement
//
//  Created by WEBSYSTEM-MAC29 on 2023/10/22.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {
    // Realmインスタンスを取得する
    let realm = try! Realm()
    var task: Setting!
    
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var goalLavelField: UILabel!
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date()
        let month = Calendar.current.component(.month, from: today)
        self.goalLavelField.text = "\(month)月の目標設定"
    }
    
    
    @IBAction func handleRegistButton(_ sender: Any) {
        var regist = true
        if Int(self.goalTextField.text!) == nil {
            regist = false
        }
        
        if Int(self.incomeTextField.text!) == nil {
            regist = false
        }
        
        if regist {
            task = Setting()
            try! realm.write {
                self.task.goal = self.goalTextField.text!
                self.task.income = self.incomeTextField.text!
                self.task.date = Date()
                self.realm.add(self.task, update: .modified)
            }
            
            self.dismiss(animated: true, completion: nil)
        } else {
            // アラートを作成
            let alertController = UIAlertController(
                title: "入力値エラー",
                message: "目標は数値のみ設定してください。",
                preferredStyle: .alert
            )
            
            // アクションボタンを追加
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            // アラートを表示
            present(alertController, animated: true, completion: nil)
        }
    }
    
}

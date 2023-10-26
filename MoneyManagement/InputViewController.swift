//
//  InputViewController.swift
//  MoneyManagement
//
//  Created by WEBSYSTEM-MAC29 on 2023/10/21.
//

import UIKit
import RealmSwift
import UserNotifications


class InputViewController: UIViewController {
    @IBOutlet weak var spendigTexrField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    
    let realm = try! Realm()
    var task: Spending!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        spendigTexrField.text = String(task.spending)
        categoryTextField.text = task.category
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var regist = true
        if Int(self.spendigTexrField.text!) == nil {
            regist = false
        }
        
        if regist {
            
            try! realm.write {
                self.task.spending = self.spendigTexrField.text!
                self.task.category = self.categoryTextField.text!
                self.task.date = Date()
                self.realm.add(self.task, update: .modified)
            }
            
            
            super.viewWillDisappear(animated)
        } else {
            // アラートを作成
            let alertController = UIAlertController(
                title: "入力値エラー",
                message: "支出は数値のみ設定してください。",
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

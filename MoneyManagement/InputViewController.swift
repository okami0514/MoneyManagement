//
//  InputViewController.swift
//  MoneyManagement
//
//  Created by WEBSYSTEM-MAC29 on 2023/10/21.
//

import UIKit
import RealmSwift

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
        try! realm.write {
            self.task.spending = self.spendigTexrField.text!
            self.task.category = self.categoryTextField.text!
            self.task.date = Date()
            self.realm.add(self.task, update: .modified)
        }
        
        super.viewWillDisappear(animated)
    }
}

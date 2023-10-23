//
//  SettingViewController.swift
//  MoneyManagement
//
//  Created by WEBSYSTEM-MAC29 on 2023/10/22.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var goalLavelField: UILabel!
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    var task: Setting!
    
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
        try! realm.write {
            self.task.goal = self.goalTextField.text!
            self.task.income = self.incomeTextField.text!
            self.task.date = Date()
            self.realm.add(self.task, update: .modified)
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}

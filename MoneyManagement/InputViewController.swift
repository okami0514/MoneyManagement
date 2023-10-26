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
            setNotification(task: task)
            
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
        
        // タスクのローカル通知を登録する --- ここから ---
          func setNotification(task: Spending) {
              let content = UNMutableNotificationContent()
              // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
              if task.category == "" {
                  content.title = "(カテゴリなし)"
              } else {
                  content.title = task.category
              }
              if task.spending == "" {
                  content.body = "(内容なし)"
              } else {
                  content.body = "支出" + task.spending
              }
              content.sound = UNNotificationSound.default

              // ローカル通知が発動するtrigger（日付マッチ）を作成
              let calendar = Calendar.current
              let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
              let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

              // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
              let request = UNNotificationRequest(identifier: String(task.id.stringValue), content: content, trigger: trigger)

              // ローカル通知を登録
              let center = UNUserNotificationCenter.current()
              center.add(request) { (error) in
                  print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
              }

              // 未通知のローカル通知一覧をログ出力
              center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                  for request in requests {
                      print("/---------------")
                      print(request)
                      print("---------------/")
                  }
              }
          }
    }
}

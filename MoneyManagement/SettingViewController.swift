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
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var registButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

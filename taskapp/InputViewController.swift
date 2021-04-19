//
//  InputViewController.swift
//  taskapp
//
//  Created by Liu Peiwen on 2021/04/14.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
    let realm = try! Realm()
    var task: Task!
    
    //選択されたカテゴリを格納する
    var selectedCategory: String = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        //categoryLabel.text = task.category
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        if task.category == "" {
            categoryLabel.text = "please choose a category"
        } else {
            categoryLabel.text = task.category
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear!!!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear!!!")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear!!!")
    }
    
    @objc func dismissKeyboard() {
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    //SelectCategoryButtonを押した処理
    @IBAction func selectCategoryButton(_ sender: UIButton) {
        print("selectCategoryButton be tapped")
        
    }
    
    //SaveButtonを押し、データを保存する
    @IBAction func tapSaveButton(_ sender: UIButton) {
        print("saveButton be tapped")
        //データ保存処理を呼ぶ
        self.saveTaskData()
    }
    
    //選択されたカテゴリ名を表示する
    func setCategory() {
        categoryLabel.text = self.selectedCategory
    }
    
    //データの保存する処理
    func saveTaskData() {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.category = self.categoryLabel.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: .modified)
        }
        
        self.setNotification(task: task)
        
        //前の画面に戻る
        self.navigationController?.popViewController(animated: true)
    }
    
    //タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        //タイトルと内容を設定(中身がない場合メッセージなしで音だけの通知になる)
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        //ローカル通知が発動するtrigger(日付マッチ)を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //identifier, content, triggerからローカル通知を作成(identifierが同じだとローカル通知を上書き保存)
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/----------")
                print(request)
                print("----------/")
            }
        }
        
    }
    

}

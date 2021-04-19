//
//  CategoryViewController.swift
//  taskapp
//
//  Created by Liu Peiwen on 2021/04/16.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    //Realmインスタンスを取得する
    let realm = try! Realm()
    
    var category: Category!
    
    var categoryTextFieldString = ""
    
    //DB内のカテゴリが格納されるリスト
    var categoryArray = try! Realm().objects(Category.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.categoryTableView.delegate = self
        self.categoryTableView.dataSource = self
        self.categoryTextField.delegate = self
        
        //popupViewカスタマイズ
        self.popUpView.backgroundColor = UIColor.customLightGray
        self.popUpView.layer.cornerRadius = 20
        //cancelButtonカスタマイズ
        self.cancelButton.layer.cornerRadius = 20
        self.cancelButton.tintColor = UIColor.customDarkGreen
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //再利用可能なセルを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        //categoryCellの値を設定する
        let categoryCellData = categoryArray[indexPath.row]
        cell.textLabel?.text = categoryCellData.categoryName
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(categoryArray[indexPath.row]) be tapped")
        //カテゴリデータを渡す
        let nc = self.presentingViewController as! UINavigationController
        let vc = nc.viewControllers[nc.viewControllers.count - 1] as! InputViewController
        vc.selectedCategory = categoryArray[indexPath.row].categoryName
        vc.setCategory()
        self.closePopupView()
    }
    
    @objc func closePopupView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.categoryTextField.isFirstResponder) {
            self.categoryTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapAddCategoryButton(_ sender: CustomButton) {
        print("addButton be tapped")
        //カテゴリ追加処理を呼ぶ
        self.saveCategoryData()
        //categoryTextfieldにある文字を削除
        self.categoryTextField.text = ""
        //categoryTableViewを更新する
        self.categoryTableView.reloadData()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        print("cancelButton be tapped")
        self.closePopupView()
    }
    
    //カテドリデータの保存処理
    func saveCategoryData() {
        try! self.realm.write {
            
            let categoryData = Category()
            let allCategories = self.realm.objects(Category.self)
            if allCategories.count != 0 {
                categoryData.id = allCategories.max(ofProperty: "id")! + 1
            }
            self.category = categoryData
            
            self.categoryTextFieldString = categoryTextField.text!
            print("categoryName: \(self.categoryTextFieldString)")
            self.category.categoryName = self.categoryTextFieldString
            self.realm.add(self.category, update: .modified)
        }
    }
    
    
    

    
}




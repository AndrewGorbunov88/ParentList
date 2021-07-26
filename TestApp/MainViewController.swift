//
//  ViewController.swift
//  TestApp
//
//  Created by Андрей Горбунов on 24.07.2021.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var childTable: UITableView!
    private var childrenArray = [(nameChild: String, ageChild: String)]() {
        didSet {
            self.childTable.reloadData()
            checkTableState()
        }
    }
    
    private let dictionaryWords = ["1": "год",
                                   "2": "года",
                                   "3": "года",
                                   "4": "года",
                                   "5": "лет",
                                   "6": "лет",
                                   "7": "лет",
                                   "8": "лет",
                                   "9": "лет",
                                   "10": "лет",
                                   "11": "лет",
                                   "12": "лет",
                                   "13": "лет",
                                   "14": "лет",
                                   "15": "лет",
                                   "16": "лет",
                                   "17": "лет",
                                   "18": "лет"]
    
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var patronymicField: UITextField!
    @IBOutlet weak var plusBarButton: UIBarButtonItem!
    
    @IBOutlet weak var phoneField: UITextField!
    
    private var startIndexCollection = 0
    private var indexSelectedChild = Int()
    private var fieldCollection = [UITextField]()
    
    private var fieldControl: TextFieldControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTableState()
        
        fieldCollection.append(lastNameField)
        fieldCollection.append(firstNameField)
        fieldCollection.append(patronymicField)
        fieldCollection.append(phoneField)
        
        fieldControl = TextFieldControl(vc: self, collection: fieldCollection)
        
        for field in fieldCollection {
            field.tag = startIndexCollection
            field.autocapitalizationType = .words
            field.delegate = fieldControl
            field.inputAccessoryView = createToolBar()
            startIndexCollection += 1
        }
        
        fieldCollection.last?.returnKeyType = .done
        fieldCollection.first?.becomeFirstResponder()
        
    }
    
    //MARK: - Methods
    
    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Скрыть", style: .done, target: self, action: #selector(hideKeyboard))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleButton, doneButton], animated: false)
        
        return toolBar
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "childCreate" {
            let vc = segue.destination as? UINavigationController
            let targetVC = vc?.topViewController as? ChildInfoController
            targetVC?.stateCreate = .createChild
            targetVC?.delegateChild = self
        } else if segue.identifier == "childEdit" {
            let vcSecond = segue.destination as? UINavigationController
            let editVC = vcSecond?.topViewController as? ChildInfoController
            if let child = sender as? (nameChild: String, ageChild: String) {
                editVC?.nameChild = child.nameChild
                editVC?.ageChild = child.ageChild
                editVC?.stateCreate = .editChild
            }
            editVC?.delegateChild = self
        }
    }
    
    private func checkTableState() {
        if childrenArray.isEmpty {
            self.childTable.isHidden = true
        }
        
        if childrenArray.count > 4 {
            self.plusBarButton.isEnabled = false
        } else {
            self.plusBarButton.isEnabled = true
        }
    }
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrenArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "childrenCell") as? ChildCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "childrenCell") as? ChildCell
        }
        
        let row = indexPath.row
        cell?.childNameLabel.text = childrenArray[row].nameChild
        
        let stringTranslateFromDicitionary = childrenArray[row].ageChild
        if let symbol = dictionaryWords[stringTranslateFromDicitionary] {
            cell?.childAgeLabel.text = childrenArray[row].ageChild + " " + symbol
        } else {
            cell?.childAgeLabel.text = childrenArray[row].ageChild
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Список детей"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            var sourceArray = childrenArray
            sourceArray.remove(at: indexPath.row)
            childrenArray = sourceArray
            
            self.childTable.beginUpdates()
            self.childTable.endUpdates()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectChild = childrenArray[indexPath.row]
        indexSelectedChild = indexPath.row
        
        self.performSegue(withIdentifier: "childEdit", sender: selectChild)
    }

}

extension MainViewController: ChildInfoDelegate {
    
    func addChild(withName name: String, withAge age: String, state: ChildInfoController.Mode) {
        let child = (nameChild: name, ageChild: age)
        
        switch state {
        case .createChild:
            childrenArray.append(child)
            self.childTable.isHidden = false
        case .editChild:
            childrenArray[indexSelectedChild].nameChild = child.nameChild
            childrenArray[indexSelectedChild].ageChild = child.ageChild
            indexSelectedChild = Int()
        }
    }
    
}

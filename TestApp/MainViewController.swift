//
//  ViewController.swift
//  TestApp
//
//  Created by Андрей Горбунов on 24.07.2021.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var childTable: UITableView!
    
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var patronymicField: UITextField!
    @IBOutlet weak var plusBarButton: UIBarButtonItem!
    
    @IBOutlet weak var phoneField: UITextField!
    
    private var startIndexCollection = 0
    private var fieldCollection = [UITextField]()
    
    private var fieldControl: TextFieldControl?
    private var dataSourceAndDelegate: ChildrenTable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Убираю UITableViewDelegate и DataSource в отдельный класс, чтобы облегчить контроллер
        dataSourceAndDelegate = ChildrenTable(vc: self, tableView: childTable)
        childTable.delegate = dataSourceAndDelegate
        childTable.dataSource = dataSourceAndDelegate
        checkTableState()
        
        fieldCollection.append(lastNameField)
        fieldCollection.append(firstNameField)
        fieldCollection.append(patronymicField)
        fieldCollection.append(phoneField)
        
        //Убираю UITextFieldDelegate в отдельный класс, чтобы облегчить контроллер
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
        
        createChildDidChangeObserver()
        
    }
    
    //MARK: - Methods
    
    private func createChildDidChangeObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(tableViewRefresh), name: .didCountChildrenChange, object: nil)
    }

    @objc func tableViewRefresh(notification: Notification) {
        checkTableState()
    }
    
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
            targetVC?.delegateChild = dataSourceAndDelegate
            
        } else if segue.identifier == "childEdit" {
            let vcSecond = segue.destination as? UINavigationController
            let editVC = vcSecond?.topViewController as? ChildInfoController
            if let child = sender as? (nameChild: String, ageChild: String) {
                editVC?.nameChild = child.nameChild
                editVC?.ageChild = child.ageChild
                editVC?.stateCreate = .editChild
            }
            
            editVC?.delegateChild = dataSourceAndDelegate
        }
    }
    
    private func checkTableState() {
        
        if let dataFromTable = dataSourceAndDelegate {
            
            if dataFromTable.childrenArray.isEmpty {
                self.childTable.isHidden = true
            }
            
            if dataFromTable.childrenArray.count > 4 {
                self.plusBarButton.isEnabled = false
            } else {
                self.plusBarButton.isEnabled = true
            }
            
        }
        
    }

}

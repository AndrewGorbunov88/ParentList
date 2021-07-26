//
//  ChildInfo.swift
//  TestApp
//
//  Created by Андрей Горбунов on 25.07.2021.
//

import UIKit

class ChildInfoController: UITableViewController, UITextFieldDelegate {
    
    enum Mode {
        case createChild
        case editChild
    }
    var stateCreate: Mode!
    var delegateChild: ChildInfoDelegate?
    
    private var startIndexCollection = 0
    private var cellsArray = ["Введите имя ребенка", "Введите возраст ребенка"]
    private var fieldsCollection = [UITextField]()
    var nameChild = ""
    var ageChild = ""
    
    private var childFieldControl: ChildFieldControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelShow))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChild))
        
    }
    
    @objc func cancelShow() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveChild() {
        
        guard let childName = fieldsCollection.first?.text else {return}
        guard let ageChild = fieldsCollection[1].text else {return}
        
        if childName.isEmpty {
            let alertName = UIAlertController(title: "Отсутствует имя", message: "Заполните поле для имени", preferredStyle: .alert)
            alertName.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                print("Произошло нажатие на кнопку - Ok")
                self.fieldsCollection.first?.becomeFirstResponder()
            }))
            self.present(alertName, animated: true, completion: nil)
            
        } else if ageChild.isEmpty {
            let alertLastName = UIAlertController(title: "Отсутствует возраст", message: "Заполните поле для возраста", preferredStyle: .alert)
            alertLastName.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                print("Произошло нажатие на кнопку - Ok")
                self.fieldsCollection[1].becomeFirstResponder()
            }))
            self.present(alertLastName, animated: true, completion: nil)
            
        } else {
            dismiss(animated: true, completion: nil)
            
            print("\(childName) \(ageChild)")
            self.delegateChild?.addChild(withName: childName, withAge: ageChild, state: stateCreate)
        }
        
    }
    
    func createField(inCell cell: UITableViewCell?, withFieldName: String) {
        let fieldSize = CGSize(width: self.view.frame.width - 40, height: (cell?.frame.height)! - 10)
        let nameField = UITextField(frame: CGRect(x: self.view.frame.midX - fieldSize.width / 2, y: (cell?.bounds.midY)! - fieldSize.height / 2, width: fieldSize.width, height: fieldSize.height))
        nameField.borderStyle = .roundedRect
        nameField.placeholder = withFieldName
        nameField.returnKeyType = .next
        nameField.autocorrectionType = .no
        nameField.delegate = self
        fieldsCollection.append(nameField)
        
        cell?.contentView.addSubview(nameField)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "childCell")
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "childCell")
        }

        let row = indexPath.row
        
        switch row {
        case 0:
            createField(inCell: cell, withFieldName: cellsArray[indexPath.row])
            fieldsCollection.first?.text = self.nameChild
            fieldsCollection.first?.becomeFirstResponder()
        case 1:
            createField(inCell: cell, withFieldName: cellsArray[indexPath.row])
            fieldsCollection[indexPath.row].text = self.ageChild
        default: break
        }
        
        childFieldControl = ChildFieldControl(vc: self, collection: fieldsCollection)
        for field in fieldsCollection {
            field.tag = startIndexCollection
            field.autocapitalizationType = .words
            field.delegate = childFieldControl
            startIndexCollection += 1
        }

        return cell!
    }
    
}

protocol ChildInfoDelegate {
//    func addChild(withName name: String, withAge age: String state: ChildInfo.Mode, with courses: Set<NSManagedObject>)
    func addChild(withName name: String, withAge age: String, state: ChildInfoController.Mode)
}

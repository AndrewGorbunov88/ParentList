//
//  ChildrenTable.swift
//  TestApp
//
//  Created by Андрей Горбунов on 26.07.2021.
//

import UIKit

class ChildrenTable: NSObject, UITableViewDataSource, UITableViewDelegate {

    private weak var parentViewController: MainViewController!
    private weak var childTable: UITableView!
    private var indexSelectedChild = Int()
    
    private(set) var childrenArray = [(nameChild: String, ageChild: String)]() {
        didSet {
            self.childTable.reloadData()
            let childInfo = ["didCountChildrenChange": childrenArray]
            NotificationCenter.default.post(name: .didCountChildrenChange, object: nil, userInfo: childInfo)
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
    
    init(vc: MainViewController, tableView: UITableView) {
        self.parentViewController = vc
        self.childTable = tableView
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
            
            self.parentViewController.childTable.beginUpdates()
            self.parentViewController.childTable.endUpdates()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectChild = childrenArray[indexPath.row]
        indexSelectedChild = indexPath.row
        
        parentViewController.performSegue(withIdentifier: "childEdit", sender: selectChild)
        
    }
    
}

extension ChildrenTable: ChildInfoDelegate {
    
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

extension Notification.Name {
    static let didCountChildrenChange = Notification.Name("didCountChildrenChange")
}

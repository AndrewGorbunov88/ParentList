//
//  ChildFieldControl.swift
//  TestApp
//
//  Created by Андрей Горбунов on 25.07.2021.
//

import Foundation
import UIKit

class ChildFieldControl: NSObject, UITextFieldDelegate {
    
    private let stringValidationForName = "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZаАбБвВгГдДеЕжЖзЗиИйЙкКлЛмМнНоОпПрРсСтТуУфФхХцЦчЧшШщЩъЪыЫьЬэЭюЮяЯ"
    
    private weak var parentVC: ChildInfoController?
    private var childFieldCollection = [UITextField]()
    
    init(vc: ChildInfoController, collection: [UITextField]) {
        self.parentVC = vc
        self.childFieldCollection = collection
    }
    
    //MARK: - Methods
    func forLoop(inCollection collection: [UITextField], withIndex index: Int, andField field: UITextField) {
        
        if field.isEqual(collection[index]) && collection[index] != collection.last {
            collection[index + 1].becomeFirstResponder()
        } else {
            field.resignFirstResponder()
        }
        
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        for index in childFieldCollection.indices {
            forLoop(inCollection: childFieldCollection, withIndex: index, andField: textField)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(childFieldCollection[0]) {
            
            let validationSet = CharacterSet(charactersIn: stringValidationForName)
            let components = string.components(separatedBy: validationSet.inverted)

            if components.count > 1 {
                return false
            }
            
        }
        
        if textField.isEqual(childFieldCollection[1]) {
            
            let validationSet = CharacterSet.decimalDigits
            let components = string.components(separatedBy: validationSet.inverted)
            
            if components.count > 1 {
                return false
            }
            
        }
        
        return true
    }
    
}

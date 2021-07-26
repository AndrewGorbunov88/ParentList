//
//  FieldDelegate.swift
//  TestApp
//
//  Created by Андрей Горбунов on 24.07.2021.
//

import Foundation
import UIKit

class TextFieldControl: NSObject, UITextFieldDelegate {
    
    static let localNumberMaxLength = 7
    static let areaCodeMaxLength = 3
    static let countryCodeMaxLength = 3
    
    private let stringValidationForName = "aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZаАбБвВгГдДеЕжЖзЗиИйЙкКлЛмМнНоОпПрРсСтТуУфФхХцЦчЧшШщЩъЪыЫьЬэЭюЮяЯ"
    
    private weak var parentVC: MainViewController?
    private var parentFieldCollection = [UITextField]()
    
    init(vc: MainViewController, collection: [UITextField]) {
        self.parentVC = vc
        self.parentFieldCollection = collection
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
        
        for index in parentFieldCollection.indices {
            forLoop(inCollection: parentFieldCollection, withIndex: index, andField: textField)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.isEqual(parentFieldCollection[0]) ||
            textField.isEqual(parentFieldCollection[1]) ||
            textField.isEqual(parentFieldCollection[2]) {
            
            let validationSet = CharacterSet(charactersIn: stringValidationForName)
            let components = string.components(separatedBy: validationSet.inverted)
            
            if components.count > 1 {
                return false
            }
            
        }
        
        if textField.isEqual(parentFieldCollection[3]) {
            
            let validationSet = CharacterSet.decimalDigits
            let components = string.components(separatedBy: validationSet.inverted)
            
            if components.count > 1 {
                return false
            }
            
            let text = (textField.text ?? "") as NSString
            var newString = text.replacingCharacters(in: range, with: string)
            
            let validComponents = newString.components(separatedBy: validationSet.inverted)
            newString = validComponents.joined(separator: "")
            
            //+XX (XXX) XXX-XXXX
            
            var resultingString = NSMutableString()
            
            if newString.count > TextFieldControl.localNumberMaxLength + TextFieldControl.areaCodeMaxLength + TextFieldControl.countryCodeMaxLength {
                return false
            }
            
            let localNumberLength = min(newString.count, TextFieldControl.localNumberMaxLength)
            
            if localNumberLength > 0 {
                let number = String(NSString(string: newString).substring(from: newString.count - localNumberLength))
                resultingString.append(number)
                if resultingString.length > 3 {
                    resultingString.insert("-", at: 3)
                }
                print("resultingString = \(resultingString)")
            }
            
            if newString.count > TextFieldControl.localNumberMaxLength {
                let areaCodeNumberLength = min(newString.count - TextFieldControl.localNumberMaxLength, TextFieldControl.areaCodeMaxLength)
                let areaRange = NSRange(location: newString.count - TextFieldControl.localNumberMaxLength - areaCodeNumberLength, length: areaCodeNumberLength)
                var area = "(\(NSString(string: newString).substring(with: areaRange)))"
                area.append(resultingString as String)
                resultingString = NSMutableString(string: area)
            }
            
            if newString.count > TextFieldControl.localNumberMaxLength + TextFieldControl.areaCodeMaxLength {
                let countryCodeNumberLength = min(newString.count - TextFieldControl.localNumberMaxLength - TextFieldControl.countryCodeMaxLength, TextFieldControl.countryCodeMaxLength)
                let countryRange = NSRange(location: 0, length: countryCodeNumberLength)
                var countryCode = "+\(NSString(string: newString).substring(with: countryRange))"
                countryCode.append(resultingString as String)
                resultingString = NSMutableString(string: countryCode)
            }
            
            textField.text = String(resultingString)
            
            return false
            
        } else {
            return true
        }
        
    }
    
}

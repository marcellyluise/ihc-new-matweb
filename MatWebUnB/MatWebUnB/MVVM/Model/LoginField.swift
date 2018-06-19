//
//  LoginField.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 19/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit
import Quiver

enum FieldType {
    case password
    case registration
}

class LoginField {
    
    var placeholder: String?
    var fieldValue: String?
    var type: FieldType
    var formatter: Formatter?
    var validators: [Validator]?
    var icon: UIImage?
    
    var isValid: Bool {
        return validators?.reduce(true, { (lastValidation, validator) -> Bool in
            do {
                let result = try validator.validate(with: fieldValue)
                return result && lastValidation
            } catch {
                return false
            }
        }) ?? true
    }
    
    init(placeholder: String?, fieldValue: String?, type: FieldType, formatter: Formatter?, validators: [Validator]?, icon: UIImage?) {
        self.placeholder = placeholder
        self.fieldValue = fieldValue
        self.type = type
        self.formatter = formatter
        self.validators = validators
        self.icon = icon
    }
    
}

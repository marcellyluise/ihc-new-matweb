//
//  LoginFieldViewModel.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 19/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit
import Quiver

class LoginFieldViewModel {
    
    private var loginField: LoginField
    
    var placeholder: String? {
        return loginField.placeholder
    }
    
    var fieldValue: String? {
        get { return loginField.fieldValue }
        set { loginField.fieldValue = newValue }
    }
    
    var formatter: Formatter? {
        return loginField.formatter
    }
    
    var validators: [Validator]? {
        return loginField.validators
    }
    
    var isSecureField: Bool {
        return loginField.type == .password
    }
    
    var icon: UIImage? {
        return loginField.icon
    }
    
    var keyboardType: UIKeyboardType {
        switch loginField.type {
        case .registration:
            return .numberPad
        default:
            return .default
        }
    }
    
    init(loginField: LoginField) {
        self.loginField = loginField
    }
    
}

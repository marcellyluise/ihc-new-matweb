//
//  LoginViewModel.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 19/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit

class LoginViewModel {
    
    private var fields: [LoginField] = []
    
    var numberOfFields: Int {
        return fields.count
    }
    
    var isFormValidated: Bool {
        return fields.reduce(true, { (lastResult, field) -> Bool in
            return field.isValid && lastResult
        })
    }
    
    init() {
        setupFields()
    }
    
    private func setupFields() {
        let registrationField = LoginField(placeholder: "Digite sua matrícula", fieldValue: nil, type: .registration, formatter: MaskFormatter.registrationNumber, validators: [.required(), .numeric()], icon: #imageLiteral(resourceName: "registration-icon"))
        let passwordField = LoginField(placeholder: "Digite sua senha", fieldValue: nil, type: .password, formatter: nil, validators: [.required()], icon: #imageLiteral(resourceName: "locker"))
        
        fields.append(registrationField)
        fields.append(passwordField)
    }
    
    func loginFieldModel(at indexPath: IndexPath) -> LoginFieldViewModel? {
        return LoginFieldViewModel(loginField: fields[indexPath.row])
    }
    
}

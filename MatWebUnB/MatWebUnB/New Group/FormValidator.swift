//
//  FormValidator.swift
//  FormTests
//
//  Created by Heitor Costa on 01/02/18.
//  Copyright © 2018 Heitor Costa. All rights reserved.
//

import Foundation

enum FormValidationReason {
    case textChanged
    case returned
}

struct FormValidationResult {
    var message: String?
    var valid: Bool?
}

protocol FormValidator {
    func validate(text: String?, reason: FormValidationReason) -> FormValidationResult
}

//
//  FormTableViewCell.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 02/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit
import Quiver

protocol FormTableViewCellDelegate: class {
    func formField(_ cell: FormTableViewCell, didChangeValidation validationResult: FormValidationResult?)
    func formFieldEditinDidBegin(_ cell: FormTableViewCell)
    func formFieldEditinDidEnd(_ cell: FormTableViewCell)
    func formFieldDidTapTitleIcon(_ cell: FormTableViewCell)
}

class FormTableViewCell: UITableViewCell {

    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var textField: UITextField!
    
    weak var delegate: FormTableViewCellDelegate?
    
    var isSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    var fieldValue: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    var unformattedValue: String? {
        get { return formatter?.unformat(input: textField.text ?? "") ?? fieldValue }
        set { fieldValue = formatter?.format(input: newValue ?? "") ??  newValue }
    }
    
    var keyboardType: UIKeyboardType {
        get { return textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    var formatter: Formatter?
    var validator: FormValidator?
    var indexPath: IndexPath?
    
    var isValid: Bool {
        return lastValidationResult?.valid == true
    }
    
    private(set) var lastValidationResult: FormValidationResult? {
        didSet {
            delegate?.formField(self, didChangeValidation: lastValidationResult)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
    }
}

// MARK: - Text Field Delegate
extension FormTableViewCell: UITextFieldDelegate {
    
    // MARK: Begin Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.formFieldEditinDidBegin(self)
    }
    
    // MARK: Text Changed
    @objc private func textFieldChanged(_ textField: UITextField) {
        
        var unformattedText = textField.text
        
        if let formatter = formatter {
            textField.text = formatter.format(input: textField.text ?? "")
            unformattedText = formatter.unformat(input: textField.text ?? "")
        }
        
        lastValidationResult = validator?.validate(text: unformattedText, reason: .textChanged)
    }
    
    // MARK: End Editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        var unformattedText = textField.text
        
        if let formatter = formatter {
            unformattedText = formatter.unformat(input: textField.text ?? "")
        }
        
        lastValidationResult = validator?.validate(text: unformattedText, reason: .returned)
        
        delegate?.formFieldEditinDidEnd(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        var unformattedText = textField.text
        
        if let formatter = formatter {
            unformattedText = formatter.unformat(input: textField.text ?? "")
        }
        
        lastValidationResult = validator?.validate(text: unformattedText, reason: .returned)
        
        delegate?.formFieldEditinDidEnd(self)
    }
}

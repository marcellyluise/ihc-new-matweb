//
//  FormTableViewCell.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 02/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit
import Quiver

class FormTableViewCell: UITableViewCell {

    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var textField: UITextField!
    
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

extension FormTableViewCell: UITextFieldDelegate {
    
    @objc private func textFieldChanged(_ textField: UITextField) {
        if let formatter = formatter {
            textField.text = formatter.format(input: textField.text ?? "")
        }
    }
}

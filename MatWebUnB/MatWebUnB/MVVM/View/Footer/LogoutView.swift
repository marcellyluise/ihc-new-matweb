//
//  LogoutView.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 02/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit

protocol LogoutViewDelegate: class {
    func logoutViewDidTapButton()
}

class LogoutView: UIView {
    
    weak var delegate: LogoutViewDelegate?
    
    static func create(with delegate: LogoutViewDelegate?) -> LogoutView? {
        
        guard let footerView = Bundle.main.loadNibNamed(String(describing: LogoutView.self), owner: nil, options: nil)?.first as? LogoutView else {
            return nil
        }
        
        footerView.delegate = delegate
        
        return footerView
    }
    
    // MARK: - Actions
    @IBAction func logout(_ sender: Any) {
        delegate?.logoutViewDidTapButton()
    }
}

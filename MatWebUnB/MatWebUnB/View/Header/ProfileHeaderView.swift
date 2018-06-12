//
//  ProfileHeaderView.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 01/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var registrationNumberLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    static func createHeader() -> ProfileHeaderView? {
        
        guard let header = Bundle.main.loadNibNamed(String(describing: ProfileHeaderView.self), owner: nil, options: nil)?.first as? ProfileHeaderView else {
            return nil
        }
        
        header.customize()
        
        return header
        
    }
    
    private func customize() {
        addBorders()
    }
    
    private func addBorders() {
        
    }
    
}

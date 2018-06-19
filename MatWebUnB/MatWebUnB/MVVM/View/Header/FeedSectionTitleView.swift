//
//  FeedSectionTitleView.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 19/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit

class FeedSectionTitleView: UIView {
    @IBOutlet weak private var titleLabel: UILabel!
    
    static let sectionHeight: CGFloat = 40.0
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    static func createSection(with title: String?) -> FeedSectionTitleView? {
        
        guard let sectionView = Bundle.main.loadNibNamed(String(describing: FeedSectionTitleView.self), owner: nil, options: nil)?.first as? FeedSectionTitleView else {
            return nil
        }
        
        sectionView.title = title
        
        return sectionView
    }
    
}

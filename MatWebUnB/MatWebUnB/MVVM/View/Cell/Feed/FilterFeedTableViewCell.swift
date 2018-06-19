//
//  FilterFeedTableViewCell.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 19/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit

class FilterFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var filterNameLabel: UILabel!
    
    var filterName: String? {
        get { return filterNameLabel.text }
        set { filterNameLabel.text = newValue }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

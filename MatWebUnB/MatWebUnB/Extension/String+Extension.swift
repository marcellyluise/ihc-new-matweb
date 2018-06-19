//
//  String+Extension.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 03/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit

extension String {
    func replacingFirstOccurrence(of string: String, with replacement: String) -> String {
        guard let range = self.range(of: string) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
    
    subscript (index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    subscript (index: Int) -> String {
        return String(self[index] as Character)
    }
}

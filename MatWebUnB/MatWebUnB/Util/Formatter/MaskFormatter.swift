//
//  MaskFormatter.swift
//  CaixaImoveis
//
//  Created by Heitor Costa on 18/12/17.
//  Copyright © 2017 Ais Digital. All rights reserved.
//

import UIKit

// See https://github.com/moraisandre/SwiftMaskText for formats
class MaskFormatter: Formatter {
    
    typealias MaskResolver = (String) -> String
    
    var mask: String
    
    private var maskResolvers: [Character: MaskResolver] = [:]
    
    init(mask: String) {
        self.mask = mask
        setupMaskResolvers()
    }
    
    private func setupMaskResolvers() {
        
        maskResolvers["N"] = { character in
            return self.isNumber(textToValidate: character) ? character : ""
        }
        maskResolvers["C"] = { character in
            return self.maskResolvers["X"]?(character).uppercased() ?? ""
        }
        maskResolvers["c"] = { character in
            return self.maskResolvers["X"]?(character).lowercased() ?? ""
        }
        maskResolvers["X"] = { character in
            return (!self.hasSpecialCharacter(searchTerm: character) && !self.isNumber(textToValidate: character)) ? character : ""
        }
        maskResolvers["%"] = { character in
            return !self.hasSpecialCharacter(searchTerm: character) ? character : ""
        }
        maskResolvers["U"] = { character in
            return self.maskResolvers["%"]?(character).uppercased() ?? ""
        }
        maskResolvers["u"] = { character in
            return self.maskResolvers["%"]?(character).lowercased() ?? ""
        }
        maskResolvers["*"] = { character in
            return character
        }
    }
    
    // MARK: - Formatter
    func format(input: String) -> String {
        
        var currentIndex = 0
        var textWithMask = ""
        let text = unformat(input: input)
        
        for maskChar in mask {
            if currentIndex >= text.count {
                break
            }
            
            if let resolver = maskResolvers[maskChar] {
                let result = resolver(text[currentIndex])
                if result.isEmpty {
                    break
                }
                textWithMask += result
                currentIndex += 1
            } else {
                textWithMask += "\(maskChar)"
            }
        }
        
        return textWithMask
    }
    
    func unformat(input: String) -> String {
        var maskString = mask
        var text = input
        
        maskString = maskString.replacingOccurrences(of: "X", with: "")
        maskString = maskString.replacingOccurrences(of: "N", with: "")
        maskString = maskString.replacingOccurrences(of: "C", with: "")
        maskString = maskString.replacingOccurrences(of: "c", with: "")
        maskString = maskString.replacingOccurrences(of: "U", with: "")
        maskString = maskString.replacingOccurrences(of: "u", with: "")
        maskString = maskString.replacingOccurrences(of: "*", with: "")
        
        for maskChar in maskString {
            text = text.replacingFirstOccurrence(of: "\(maskChar)", with: "")
        }
        
        return text
    }
}

extension MaskFormatter {
    private func isNumber(textToValidate: String) -> Bool {
        
        let num = Int(textToValidate)
        
        if num != nil {
            return true
        }
        
        return false
    }
    
    private func hasSpecialCharacter(searchTerm: String) -> Bool {
        let regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        } catch {
            print("Regex error: \(error.localizedDescription)")
            return false
        }
        
        if regex?.firstMatch(in: searchTerm, options: .anchored, range: NSRange(location: 0, length: searchTerm.count)) != nil {
            return true
        }
        
        return false
        
    }
}

// Predefined masks
extension MaskFormatter {
    static let cpf = MaskFormatter(mask: "NNN.NNN.NNN-NN")
    static let phone = MaskFormatter(mask: "(NN) NNNNN-NNNN")
    static let registrationNumber = MaskFormatter(mask: "NN/NNNNNNN")
}

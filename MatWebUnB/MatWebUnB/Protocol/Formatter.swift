//
//  Formatter.swift
//  CaixaImoveis
//
//  Created by Heitor Costa on 18/12/17.
//  Copyright © 2017 Ais Digital. All rights reserved.
//

import Foundation

protocol Formatter {
    func format(input: String) -> String
    func unformat(input: String) -> String
}

//
//  ProfileViewModel.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 01/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import Foundation

class ProfileViewModel {

    var items: [String] = []
    
    init() {
        loadItems()
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    private func loadItems() {
        items.append("Dados Pessoais")
        items.append("Recomendações")
        items.append("Grade Horária")
        items.append("Histórico")
        items.append("Quadro Resumo")
        items.append("Solicitação de Diploma")
    }
    
    func item(at indexPath: IndexPath) -> String {
        return items[indexPath.row]
    }
}

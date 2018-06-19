//
//  FeedViewModel.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 19/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import Foundation

class FeedViewModel {
    
    private var filters: [FeedFilter] = []
    
    var numberOfFilters: Int {
        return filters.count
    }
    
    private(set) var sectionTitle = "FILTRO"
    
    init() {
        setupFilters()
    }
    
    private func setupFilters() {
        filters = [FeedFilter(title: "#MATRÍCULA"),
                   FeedFilter(title: "#PESQUISA"),
                   FeedFilter(title: "#AVALIAÇÕES"),
                   FeedFilter(title: "#AVISOS")]
    }
    
    func field(at indexPath: IndexPath) -> FeedFilter {
        return filters[indexPath.row]
    }
    
}

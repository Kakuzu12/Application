//
//  TableViewCellModel.swift
//  Weather_app
//
//  Created by Егор on 24.08.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import Foundation

struct TableViewCellModel {
    private let name: String
    private let country: String
    
    init(name: String, country: String) {
        self.name = name
        self.country = country
    }
    
    var nameValue: String {
        return name
    }
    var countryValue: String {
        return country
    }
}

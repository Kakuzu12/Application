//
//  SelfConfiguringCell.swift
//  Weather_app
//
//  Created by Егор on 03.08.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ForecastTemperature)
}

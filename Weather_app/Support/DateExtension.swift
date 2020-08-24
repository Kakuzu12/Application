//
//  DateExtension.swift
//  Weather_app
//
//  Created by Егор on 03.08.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import UIKit

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

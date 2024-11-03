//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/3/24.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

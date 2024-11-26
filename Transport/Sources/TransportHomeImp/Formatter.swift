//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/26/24.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

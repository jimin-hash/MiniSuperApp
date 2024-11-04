//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}

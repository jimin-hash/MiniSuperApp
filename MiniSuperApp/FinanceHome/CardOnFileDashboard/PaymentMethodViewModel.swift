//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import UIKit

struct PaymentMethodViewModel {
    let name: String
    let digits: String
    let color: UIColor
    
    init(_ paymentmethod: PaymentMethod) {
        name = paymentmethod.name
        digits = "**** \(paymentmethod.digits)"
        color = UIColor(hex: paymentmethod.color) ?? .systemGray2
    }
}

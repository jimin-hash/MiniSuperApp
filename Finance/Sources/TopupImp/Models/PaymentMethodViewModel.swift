//
//  PaymentMethodViewModel .swift
//  Finance
//
//  Created by Jimin Park on 11/23/24.
//

import UIKit
import FinanceEntity

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

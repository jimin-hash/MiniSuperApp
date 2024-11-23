//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import Foundation

public struct AddPaymentMethodInfo {
    public let number: String
    public let cvc: String
    public let expiry: String
    
    public init(number: String, cvc: String, expiry: String) {
        self.number = number
        self.cvc = cvc
        self.expiry = expiry
    }
}

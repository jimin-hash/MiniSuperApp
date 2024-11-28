//
//  AddCardRequest.swift
//  Finance
//
//  Created by Jimin Park on 11/29/24.
//

import Foundation
import Network
import FinanceEntity

struct AddCardRequest: Request {
    typealias Output = AddCardResponse
    
    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader
    
    init(baseURL: URL, info: AddPaymentMethodInfo) {
        self.endpoint = baseURL.appendingPathComponent("/addCard")
        self.method = .post
        self.query = [
            "number": info.number,
            "cvc": info.cvc,
            "expiry": info.expiry
        ]
        self.header = [:]
    }
    
}

struct AddCardResponse: Decodable {
    let card: PaymentMethod
}

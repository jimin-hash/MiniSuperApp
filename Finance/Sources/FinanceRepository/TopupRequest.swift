//
//  TopupRequest.swift
//  Finance
//
//  Created by Jimin Park on 11/29/24.
//

import Foundation
import Network

struct TopupRequest: Request {
    typealias Output = TopupResponse
    
    var endpoint: URL
    var method: HTTPMethod
    var query: QueryItems
    var header: HTTPHeader
    
    init(baseURL: URL, amount: Double, paymentMethodID: String) {
        self.endpoint = baseURL.appendingPathComponent("/topup")
        self.method = .post
        self.query = [
            "amount": amount,
            "paymentMethodID": paymentMethodID
        ]
        self.header = [:]
    }
}

struct TopupResponse: Decodable {
    let status: String
}

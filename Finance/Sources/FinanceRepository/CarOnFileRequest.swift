//
//  CarOnFileRequest.swift
//  Finance
//
//  Created by Jimin Park on 11/29/24.
//

import Foundation
import Network
import FinanceEntity

struct CarOnFileRequest: Request {
    typealias Output = CarOnFileResponse
    
    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader
    
    init(baseURL: URL) {
        self.endpoint = baseURL.appendingPathComponent("/cards")
        self.method = .get
        self.query = [:]
        self.header = [:]
    }
}

struct CarOnFileResponse: Decodable {
    let cards: [PaymentMethod]
}

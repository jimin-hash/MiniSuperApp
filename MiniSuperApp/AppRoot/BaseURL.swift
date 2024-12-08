//
//  BaseURL.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/29/24.
//

import Foundation

struct BaseURL {
    var financeBaseURL: URL {
        #if UITESTING
        return URL(string: "http://localhost:8080")!
        #else
        return URL(string: "https://financce.superapp.com")!
        #endif
    }
}

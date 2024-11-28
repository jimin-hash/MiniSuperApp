//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/29/24.
//

import Foundation

func setupURLProtocol() {
    
    // 충전
    let topupResponse: [String: Any] = [
        "status": "success"
    ]
    
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    // 카드 추가
    let addCardReponse: [String: Any] = [
        "card": [
            "id": "111",
            "name": "New One",
            "digits": "**** 0000",
            "color": "",
            "isPrimary": false
        ]
    ]
    
    let addCardResponseData = try! JSONSerialization.data(withJSONObject: addCardReponse, options: [])
    
    // 카드 리스트
    let cardOnFileResponse: [String: Any] = [
        "cards": [
            [
                "id": "0",
                "name": "우리은행",
                "digits": "0000",
                "color": "#f19a38ff",
                "isPrimary": false
            ],
            [
                "id": "1",
                "name": "신한은행",
                "digits": "1111",
                "color": "#3478f6ff",
                "isPrimary": false
            ],
            [
                "id": "2",
                "name": "현대카드",
                "digits": "2222",
                "color": "#78c5f5ff",
                "isPrimary": false
            ]
        ]
    ]
    
    let cardOnFileResponseData = try! JSONSerialization.data(withJSONObject: cardOnFileResponse, options: [])
    
    SuperAppUrlProtocol.successMock = [
        "/topup": (200, topupResponseData),
        "/addCard": (200, addCardResponseData),
        "/cards": (200, cardOnFileResponseData)
    ]
}

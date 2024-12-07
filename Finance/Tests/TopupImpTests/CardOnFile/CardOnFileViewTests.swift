//
//  CardOnFileViewTests.swift
//  Finance
//
//  Created by Jimin Park on 12/7/24.
//

import XCTest
import Foundation
import SnapshotTesting
import FinanceEntity
@testable import TopupImp

final class CardOnFileViewTests: XCTestCase {
    func testEnterAmount() {
        // given
        let viewModel = [
            PaymentMethodViewModel(PaymentMethod(id: "0", name: "한국은행", digits: "1234", color: "#51AF80FF", isPrimary: false)),
            PaymentMethodViewModel(PaymentMethod(id: "1", name: "신한은행", digits: "2222", color: "#f19a38ff", isPrimary: false)),
            PaymentMethodViewModel(PaymentMethod(id: "2", name: "국민은행", digits: "5555", color: "#78c5f5ff", isPrimary: false))
        ]
        
        // when
        let sut = CardOnFileViewController()
        sut.update(with: viewModel)
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro))
    }
}


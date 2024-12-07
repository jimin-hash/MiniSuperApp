//
//  EnterAmountViewTests.swift
//  Finance
//
//  Created by Jimin Park on 12/7/24.
//

import XCTest
import Foundation
import SnapshotTesting
import FinanceEntity
@testable import TopupImp

final class EnterAMountViewTest: XCTestCase {
    func testEnterAmount() {
        // given
        let paymentMethod = PaymentMethod(id: "1", name: "한국은행", digits: "1234", color: "#51AF80FF", isPrimary: false)
        let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro))
    }
    
    func testEnterAmountLoading() {
        // given
        let paymentMethod = PaymentMethod(id: "1", name: "한국은행", digits: "1234", color: "#51AF80FF", isPrimary: false)
        let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        sut.startLoading()
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro))
    }
    
    func testEnterAmountStopLoading() {
        // given
        let paymentMethod = PaymentMethod(id: "1", name: "한국은행", digits: "1234", color: "#51AF80FF", isPrimary: false)
        let viewModel = SelectedPaymentMethodViewModel(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        sut.startLoading()
        sut.stopLoading()
        
        // then
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro))
    }
}

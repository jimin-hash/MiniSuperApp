//
//  AddPaymentMethodIntegrationTests.swift
//  AddPaymentMethodIntegrationTests
//
//  Created by Jimin Park on 12/8/24.
//

import XCTest
import Hammer
import ModernRIBs
import RIBsUtil
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport
import AddPaymentMethodTestSupport
@testable import AddPaymentMethodImp

final class AddPaymentMethodIntegrationTests: XCTestCase {
    private var eventGenerator: EventGenerator!
    private var dependecy: AddPaymentMethodDependencyMock!
    private var listener: AddPaymentMethodListenerMock!
    private var viewController: UIViewController!
    private var router: Routing!
    
    private var repository: CardOnFileRepositoryMock {
        dependecy.cardOnFileRepository as! CardOnFileRepositoryMock
    }
    
    override func setUpWithError() throws {
        
        self.dependecy = AddPaymentMethodDependencyMock()
        self.listener = AddPaymentMethodListenerMock()
        
        let builder = AddPaymentMethodBuilder(dependency: self.dependecy)
        let router = builder.build(withListener: self.listener, closeButtonType: .close)
        
        let nav = NavigationControllerable(root: router.viewControllable)
        self.viewController = nav.uiviewController
        
        eventGenerator = try EventGenerator(viewController: nav.navigationController)
        
        router.load()
        router.interactable.activate()
        
        self.router = router
    }
    
    func testAddPaymentMethod() throws {
        // given
        repository.addPaymentMethod = PaymentMethod(id: "1111", name: "한국은행", digits: "1234", color: "#51AF80FF", isPrimary: false)
        
        let cardNumber = try eventGenerator.viewWithIdentifier("addpaymentmethod_cardnumber_textfield")
        try eventGenerator.fingerTap(at: cardNumber)
        try eventGenerator.keyType("1234444444412421412")
        
        let cvc = try eventGenerator.viewWithIdentifier("addpaymentmethod_security_textfield")
        try eventGenerator.fingerTap(at: cvc)
        try eventGenerator.keyType("123")
        
        let expiry = try eventGenerator.viewWithIdentifier("addpaymentmethod_expiry_textfield")
        try eventGenerator.fingerTap(at: expiry)
        try eventGenerator.keyType("1211")
        
        // when
        let confirm = try eventGenerator.viewWithIdentifier("addpaymentmethod_addcard_button")
        try eventGenerator.fingerTap(at: confirm)
        
        // then
        XCTAssertEqual(repository.addCardCallCount, 1)
        try eventGenerator.wait(0.5)
        XCTAssertEqual(listener.addPaymentMethodDidAddCardCallCount, 1)
        XCTAssertEqual(listener.addPaymentMethodDidAddCardPaymentMethod?.id, "1111")
    }
}

final class AddPaymentMethodDependencyMock: AddPaymentMethodDependency {
    var cardOnFileRepository:  CardOnFileRepository = CardOnFileRepositoryMock()
}

//
//  TopupInteractorTests.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 12/3/24.
//

@testable import TopupImp
import XCTest
import TopupTestSupport
import FinanceEntity
import FinanceRepositoryTestSupport

final class TopupInteractorTests: XCTestCase {
    
    private var sut: TopupInteractor!
    private var dependency: TopupDependencyMock!
    private var listener: TopupListenerMock!
    private var router: TopupRoutingMock!
    
    private var cardOnFileRepository: CardOnFileRepositoryMock {
        dependency.cardOnFileRepository as! CardOnFileRepositoryMock
    }
    
    override func setUp() {
        super.setUp()
        
        self.dependency = TopupDependencyMock()
        self.listener = TopupListenerMock()
        
        let interactor = TopupInteractor(dependency: self.dependency)
        self.router = TopupRoutingMock(interactable: interactor)
        
        interactor.listener = self.listener
        interactor.router = self.router
        self.sut = interactor
    }
    
    // MARK: - Tests
    
    func testActivity() {
        // given
        let cards = [
            PaymentMethod(id: "1", name: "Zero", digits: "9999", color: "", isPrimary: false)
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.activate()
        
        // then
        XCTAssertEqual(router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.name, "Zero")
    }
    
    func testActivityWithoutCard() {
        // given
        cardOnFileRepository.cardOnFileSubject.send([])
        
        // when
        sut.activate()
        
        // then
        XCTAssertEqual(router.attachAddPaymentMethodCallCount, 1)
        XCTAssertEqual(router.attachAddPaymentMethodCloseButtonType, .close)
    }
    
    func testActivityWithCard() {
        // given
        let cards = [
            PaymentMethod(id: "1", name: "Zero", digits: "9999", color: "", isPrimary: false)
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        let newCard = PaymentMethod(id: "2", name: "New", digits: "9999", color: "", isPrimary: false)
        
        // when
        sut.activate()
        sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
        
        // then
        XCTAssertEqual(router.popToRootCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "2")
    }
    
    func testDidAddCardWithoutCard() {
        // given
        cardOnFileRepository.cardOnFileSubject.send([])
        
        let newCard = PaymentMethod(id: "2", name: "New", digits: "9999", color: "", isPrimary: false)
        
        // when
        sut.activate()
        sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
        
        // then
        XCTAssertEqual(router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "2")
    }
    
    func testAddPaymentMethodDidTapCloseFromEnterAmount() {
        // given
        let cards = [
            PaymentMethod(id: "1", name: "Zero", digits: "9999", color: "", isPrimary: false)
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.activate()
        sut.addPaymentMethodDidTapClose()
        
        // then
        XCTAssertEqual(router.detachAddPaymentMethodCallCount, 1)
    }
    
    func testAddPaymentMethodDidTapClose() {
        // given
        cardOnFileRepository.cardOnFileSubject.send([])
        
        // when
        sut.activate()
        sut.addPaymentMethodDidTapClose()
        
        // then
        XCTAssertEqual(router.detachAddPaymentMethodCallCount, 1)
        XCTAssertEqual(listener.topupCloseCallCount, 1)
    }
    
    func testDidSelectCard() {
        // given
        let cards = [
            PaymentMethod(id: "1", name: "Zero", digits: "9999", color: "", isPrimary: false),
            PaymentMethod(id: "2", name: "Pay", digits: "8888", color: "", isPrimary: false)
            
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.cardOnFileDidSelect(at: 0)
        
        // then
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "1")
        XCTAssertEqual(router.detachCardOnFileCallCount, 1)
    }
    
    func testDidSelectCardWithInvalidIndex() {
        // given
        let cards = [
            PaymentMethod(id: "1", name: "Zero", digits: "9999", color: "", isPrimary: false),
            PaymentMethod(id: "2", name: "Pay", digits: "8888", color: "", isPrimary: false)
            
        ]
        cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        sut.cardOnFileDidSelect(at: 2)
        
        // then
        XCTAssertEqual(dependency.paymentMethodStream.value.id, "")
        XCTAssertEqual(router.detachCardOnFileCallCount, 1)
    }
}

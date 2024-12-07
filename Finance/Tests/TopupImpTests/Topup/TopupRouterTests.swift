//
//  TopupRouterTests.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 12/3/24.
//

@testable import TopupImp
import XCTest
import ModernRIBs
import RIBsTestSupport
import AddPaymentMethodTestSupport

final class TopupRouterTests: XCTestCase {

    private var sut: TopupRouter!
    private var interactor: TopupInteractableMock!
    private var viewController: ViewControllableMock!
    private var addPaymentMethodBuildable: AddPaymentMethodBuildableMock!
    private var enterAmountBuildable: EnterAmountBuildableMock!
    private var cardOnFileBuildableMock: CardOnFileBuildableMock!
    
    override func setUp() {
        super.setUp()
        
        self.interactor = TopupInteractableMock()
        self.viewController = ViewControllableMock()
        self.addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
        self.enterAmountBuildable = EnterAmountBuildableMock()
        self.cardOnFileBuildableMock = CardOnFileBuildableMock()
        
        sut = TopupRouter(interactor: interactor,
                          viewController: viewController,
                          addPaymentMethodBuildable: addPaymentMethodBuildable,
                          enterAmountBuildable: enterAmountBuildable ,
                          cardOnFileBuildable: cardOnFileBuildableMock
        )
    }

    // MARK: - Tests

    func testAttchAddPaymentMethod() {
        // given
        // when
        sut.attachAddPaymentMethod(closeButtonType: .close)
        
        // then
        XCTAssertEqual(addPaymentMethodBuildable.buildCallCount, 1)
        XCTAssertEqual(addPaymentMethodBuildable.closeButtonType, .close)
        XCTAssertEqual(viewController.presentCallCount, 1)
    }
    
    func testAttachEnterAmount() {
        // given
        let router = EnterAmountRoutingMock(interactable: Interactor(), viewControllable: ViewControllableMock())
        
        var assignedListener: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            assignedListener = listener
            return router
        }
        
        // when
        sut.attachEnterAmount()
        
        // then
        XCTAssertTrue(assignedListener === interactor)
        XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
    }
    
    func testAttachEnterAmountOnNavigation() {
        // given
        let router = EnterAmountRoutingMock(interactable: Interactor(), viewControllable: ViewControllableMock())
        
        var assignedListener: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            assignedListener = listener
            return router
        }
        
        // when
        // 다른 화면 붙임
        sut.attachAddPaymentMethod(closeButtonType: .close)
        sut.attachEnterAmount()
        
        // then
        XCTAssertTrue(assignedListener === interactor)
        XCTAssertEqual(enterAmountBuildable.buildCallCount, 1)
        XCTAssertEqual(viewController.presentCallCount, 1)
        XCTAssertEqual(sut.children.count, 1)
    }
}

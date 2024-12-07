//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 12/2/24.
//

@testable import TopupImp
import XCTest
import FinanceEntity
import FinanceRepositoryTestSupport

final class EnterAmountInteractorTests: XCTestCase {
    
    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!
    
    private var repository: SuperPayRepositoryMock! {
        dependency.superPayRepository as? SuperPayRepositoryMock
    }
    
    override func setUp() {
        super.setUp()
        
        self.presenter = EnterAmountPresentableMock()
        self.dependency = EnterAmountDependencyMock()
        self.listener = EnterAmountListenerMock()
        
        sut = EnterAmountInteractor(presenter: self.presenter,
                                    dependency: self.dependency)
        sut.listener = self.listener
    }
    
    // MARK: - Tests
    func testActivity() {
        // given - 수행에 앞어서 환경을 셋업
        let paymentMethod = PaymentMethod(id: "id_1", name: "name_1", digits: "8888", color: "#13ABE8FF", isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when - 검증하고자 하는 행위
        sut.activate()
        
        // then - 예상하는 행동을 했는지 검증
        XCTAssertEqual(presenter.updateSelectedPaymentMethodCount, 1)
        XCTAssertEqual(presenter.updateSelectedPaymentMethodViewModel?.name, "name_1 8888")
        XCTAssertNotNil(presenter.updateSelectedPaymentMethodViewModel?.image)
    }
    
    func testTopupWithValidAmount() {
        // given - 수행에 앞어서 환경을 셋업
        let paymentMethod = PaymentMethod(id: "id_1", name: "name_1", digits: "8888", color: "#13ABE8FF", isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when - 검증하고자 하는 행위
        sut.didTapTopup(with: 1_000_000)
        
        // then - 예상하는 행동을 했는지 검증
        // 멀티스래딩 문제! 네트워킹이 백그라운드에서 진행되고 콜백 결과를 receiveOn 메인 스래드에서 받고 있음
        // receiveOn 때문에 stopLoading과 enterAmountDidFinishTopup이 비동기로 실행이 되어서, XCTAssert 메소드가 불리고 난 다음에 stopLoading과 enterAmountDidFinishTopup 이 호출이 되는 문제가 있다.
        // 가장 간단한 방법으로는 XCTWaiter 사용하는 방법이 있다. -> 최선은 아님!
        //_ = XCTWaiter.wait(for: [expectation(description: "wait ... ")], timeout: 0.1)
        
        XCTAssertEqual(presenter.startLoadingCount, 1)
        XCTAssertEqual(presenter.stopLoadingCount, 1)
        XCTAssertEqual(repository.topupCallCount, 1)
        XCTAssertEqual(repository.paymentMethodID, "id_1")
        XCTAssertEqual(repository.topupAmount, 1_000_000)
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 1)
    }
    
    func testTopupWithFailure() {
        // given - 수행에 앞어서 환경을 셋업
        let paymentMethod = PaymentMethod(id: "id_1", name: "name_1", digits: "8888", color: "#13ABE8FF", isPrimary: false)
        dependency.selectedPaymentMethodSubject.send(paymentMethod)
        repository.shouldTopupSucceed = false
        
        // when - 검증하고자 하는 행위
        sut.didTapTopup(with: 1_000_000)
        
        // then - 예상하는 행동을 했는지 검증
        XCTAssertEqual(presenter.startLoadingCount, 1)
        XCTAssertEqual(presenter.stopLoadingCount, 1)
        XCTAssertEqual(repository.topupCallCount, 1)
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 0)
    }
    
    func testDidTapClose() {
        // given - 수행에 앞어서 환경을 셋업
        
        // when - 검증하고자 하는 행위
        sut.didTapClose()
        
        // then - 예상하는 행동을 했는지 검증
        XCTAssertEqual(listener.enterAmountDidTapCloseCallCount, 1)
    }
    
    func testDidTapPaymetnMethod() {
        // given - 수행에 앞어서 환경을 셋업
        
        // when - 검증하고자 하는 행위
        sut.didTapPaymentMethod()
        
        // then - 예상하는 행동을 했는지 검증
        XCTAssertEqual(listener.enterAmountDidTapPaymentMethodCallCount, 1)
    }
}

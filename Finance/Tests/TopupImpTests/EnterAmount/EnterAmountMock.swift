//
//  EnterAmountMock.swift
//  Finance
//
//  Created by Jimin Park on 12/2/24.
//

import Foundation
import CombineUtil
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport
import CombineSchedulers
import RIBsTestSupport
@testable import TopupImp


final class EnterAmountPresentableMock: EnterAmountPresentable {
    var listener: EnterAmountPresentableListener?
    
    var updateSelectedPaymentMethodCount = 0
    var updateSelectedPaymentMethodViewModel: SelectedPaymentMethodViewModel?
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel) {
        updateSelectedPaymentMethodCount += 1
        updateSelectedPaymentMethodViewModel = viewModel
    }
    
    var startLoadingCount = 0
    func startLoading() {
        startLoadingCount += 1
    }
    
    var stopLoadingCount = 0
    func stopLoading() {
        stopLoadingCount += 1
    }
    
    init() {
    }
}

final class EnterAmountDependencyMock: EnterAmountInteractorDependency {
    var mainQueue: AnySchedulerOf<DispatchQueue> { .immediate }
    
    var selectedPaymentMethodSubject = CurrentValuePublisher<PaymentMethod>(
        PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false)
    )
    
    // 부모가 현재 선택된 카드를 런타임에 주입해주는 스트링
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { selectedPaymentMethodSubject }
    var superPayRepository: SuperPayRepository = SuperPayRepositoryMock()
}

final class EnterAmountListenerMock: EnterAmountListener {
    var enterAmountDidTapCloseCallCount = 0
    func enterAmountDidTapClose() {
        enterAmountDidTapCloseCallCount += 1
    }
    
    var enterAmountDidTapPaymentMethodCallCount = 0
    func enterAmountDidTapPaymentMethod() {
        enterAmountDidTapPaymentMethodCallCount += 1
    }
    
    var enterAmountDidFinishTopupCallCount = 0
    func enterAmountDidFinishTopup() {
        enterAmountDidFinishTopupCallCount += 1
    }
}

final class EnterAmountBuildableMock: EnterAmountBuildable {
    
    var buildHandler: ((_ listener: EnterAmountListener) -> EnterAmountRouting)?
    
    var buildCallCount = 0
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        buildCallCount += 1
        
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        
        fatalError()
    }
}

final class EnterAmountRoutingMock: ViewableRoutingMock, EnterAmountRouting {
    
}


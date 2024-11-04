//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import ModernRIBs

// 뷰가 없는 리블렛으로 '충전하기' 버튼 클릭시 호출 됨
// 카드가 없으면 카드 추가화면, 카드가 있으면 금액 입력 화면으로 이동
protocol TopupRouting: Routing {
    func cleanupViews()
    
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    
    func attachEnterAmount()
    func detachEnterAmoun()
}

protocol TopupListener: AnyObject {
    func topupClose()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresentationControllerDelegate {
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    weak var router: TopupRouting?
    weak var listener: TopupListener?

    private let dependency: TopupInteractorDependency
    init(
        dependency: TopupInteractorDependency
    ) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if dependency.cardOnFileRepository.cardOnFile.value.isEmpty {
            // 카드 추가 화면
            router?.attachAddPaymentMethod()
        } else {
            // 금액 입력 화면
            router?.attachEnterAmount()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        listener?.topupClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        
    }
    
    func presentationControllerDidDismiss() {
        listener?.topupClose()
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmoun()
        listener?.topupClose()
    }
}

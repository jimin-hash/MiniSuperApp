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
    func detachEnterAmount()
    
    func attachCardOnFile(paymentMethod: [PaymentMethod])
    func detachCardOnFile()
}

protocol TopupListener: AnyObject {
    func topupClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresentationControllerDelegate {
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private var paymentMethods: [PaymentMethod] {
        dependency.cardOnFileRepository.cardOnFile.value
    }
    
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
        
        if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
            dependency.paymentMethodStream.send(card)
            // 금액 입력 화면
            router?.attachEnterAmount()
        } else {
            // 카드 추가 화면
            router?.attachAddPaymentMethod()
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
        router?.detachEnterAmount()
        listener?.topupClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethod: paymentMethods)
    }
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        // attach add card
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(selected)
        }
        
        router?.detachCardOnFile()
    }
    
    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }
}

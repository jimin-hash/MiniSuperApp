//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import ModernRIBs
import Combine
import FinanceEntity
import FinanceRepository
import AddPaymentMethod

// 아무것도 없으므로, AddPaymentMethodRouting 리턴타입들을 ViewableRouting로 변경
protocol AddPaymentMethodRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodPresentable: Presentable {
    var listener: AddPaymentMethodPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddPaymentMethodInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>, AddPaymentMethodInteractable, AddPaymentMethodPresentableListener {
    weak var router: AddPaymentMethodRouting?
    weak var listener: AddPaymentMethodListener?

    private let dependency: AddPaymentMethodInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: AddPaymentMethodPresentable,
        dependency: AddPaymentMethodInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.addPaymentMethodDidTapClose()
    }
    
    func didTapConfirm(with number: String, cvc: String, expiry: String) {
        let info = AddPaymentMethodInfo(number: number, cvc: cvc, expiry: expiry)
        dependency.cardOnFileRepository.addCard(info: info).sink { _ in
        } receiveValue: { method in
            self.listener?.addPaymentMethodDidAddCard(paymentMethod: method)
        }.store(in: &cancellables)

    }
}

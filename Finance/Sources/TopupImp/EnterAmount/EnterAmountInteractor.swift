//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import ModernRIBs
import Combine
import Foundation
import CombineUtil
import FinanceEntity
import FinanceRepository
import CombineSchedulers

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    
    func startLoading()
    func stopLoading()
}

public protocol EnterAmountListener: AnyObject {
    func enterAmountDidTapClose()
    func enterAmountDidTapPaymentMethod()
    func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository: SuperPayRepository { get }
    var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?

    private let dependency: EnterAmountInteractorDependency
    private var cancellable: Set<AnyCancellable>
    
    init(
        presenter: EnterAmountPresentable,
        dependency: EnterAmountInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellable = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.selectedPaymentMethod.sink { [weak self] paymentMethod in
            self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
        }.store(in: &cancellable)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapPaymentMethod()
    }
    
    func didTapTopup(with amount: Double) {
        presenter.startLoading()
        
        dependency.superPayRepository.topup(
            amount: amount,
            paymentMethodID: dependency.selectedPaymentMethod.value.id
        )
        .receive(on: dependency.mainQueue)
        .sink { [weak self] _ in
            self?.presenter.stopLoading()
        } receiveValue: { [weak self] _ in
            self?.listener?.enterAmountDidFinishTopup()
        }.store(in: &cancellable)
    }
}

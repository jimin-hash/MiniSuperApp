//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import ModernRIBs
import FinanceRepository
import CombineUtil
import AddPaymentMethod
import FinanceEntity
import Topup

public protocol TopupDependency: Dependency {
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, EnterAmountDependency, CardOnFileDependency {
    fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    
    let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }
    
    init(
        dependency: TopupDependency,
        paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    ) {
        self.paymentMethodStream = paymentMethodStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    public override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TopupListener) -> Routing {
        let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
        
        let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
//        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let enterAmounBuilder = EnterAmountBuilder(dependency: component)
        let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
        
        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethodBuildable: component.addPaymentMethodBuildable,
            enterAmountBuildable: enterAmounBuilder,
            cardOnFileBuildable: cardOnFileBuilder
        )
    }
}

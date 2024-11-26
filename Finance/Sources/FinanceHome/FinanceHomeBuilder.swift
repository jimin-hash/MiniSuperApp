import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import Topup

public protocol FinanceHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var topupBuildable: TopupBuildable { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency {
    // 카드, 계좌 데이터
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    // 자식 리블렛에 넘길 balance는 read-only
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
//    var topupBaseViewController: ViewControllable
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
    
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }
    
//    override init(
//        dependency: FinanceHomeDependency
//    ) {
//        super.init(dependency: dependency)
//    }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        let viewController = FinanceHomeViewController()
        
        let component = FinanceHomeComponent(
            dependency: dependency
        )
        
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
//        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)

//        let topupBuilder = TopupBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuildable: superPayDashboardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: component.addPaymentMethodBuildable,
            topupBuildable: component.topupBuildable
        )
    }
}

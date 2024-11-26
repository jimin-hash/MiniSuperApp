import ModernRIBs
import FinanceRepository
import TransportHome

public protocol AppHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var transportHomeBuildable: TransportHomeBuildable { get } // 부모에게로 부터 요청
}

final class AppHomeComponent: Component<AppHomeDependency> {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    var transportHomeBuildable: TransportHomeBuildable { dependency.transportHomeBuildable }
}

// MARK: - Builder

public protocol AppHomeBuildable: Buildable {
    func build(withListener listener: AppHomeListener) -> ViewableRouting
}

public final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable {
    
    public override init(dependency: AppHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: AppHomeListener) -> ViewableRouting {
        let component = AppHomeComponent(dependency: dependency)
        let viewController = AppHomeViewController()
        let interactor = AppHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        // 의존성 없애기 위해 삭제, 부모로 부터 요청해서 받아옴
//        let transportHomeBuilder = TransportHomeBuilder(dependency: component)
        
        return AppHomeRouter(
            interactor: interactor,
            viewController: viewController,
            transportHomeBuildable: component.transportHomeBuildable
        )
    }
}

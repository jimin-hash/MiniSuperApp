import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashBuildable: SuperPayDashboardBuildable
    private var superPayRouting: Routing?
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashBuildable: SuperPayDashboardBuildable
    ) {
        self.superPayDashBuildable = superPayDashBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSuperPayDashboard() {
        if superPayRouting != nil {
            return
        }
        
        let router = superPayDashBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        // 라우터의 refence을 들고 있게
        self.superPayRouting = router
        attachChild(router)
    }
}

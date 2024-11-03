//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 10/20/24.
//

import ModernRIBs
import Foundation

protocol SuperPayDashboardDependency: Dependency {
    // 부모로 부터 전달 받을 값
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
    var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
    // 빌더에서 새로 만들던지 아니면 부모로 부터 받던지 둘 중에 선택
    var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {

    override init(dependency: SuperPayDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
        let component = SuperPayDashboardComponent(dependency: dependency)
        let viewController = SuperPayDashboardViewController()
        let interactor = SuperPayDashboardInteractor(
            presenter: viewController,
            dependency: component
        )
        
        interactor.listener = listener
        return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
    }
}

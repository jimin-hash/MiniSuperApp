//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/3/24.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
    // 뷰에서 액션이 일어날 시
    func didTapAddPaymentMethod()
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {
    weak var listener: CardOnFileDashboardPresentableListener?
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "카드 및 게좌"
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(seeAllButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let cardOnFiledStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var addMethodButton: AddPaymentMethodButton = {
        let button = AddPaymentMethodButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.backgroundColor = .systemGray4
        button.addTarget(self, action: #selector(addMethodButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        view.addSubview(headerStackView)
        view.addSubview(cardOnFiledStackView)
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(seeAllButton)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardOnFiledStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            cardOnFiledStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardOnFiledStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardOnFiledStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addMethodButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func seeAllButtonDidTap() {
        
    }
    
    @objc private func addMethodButtonDidTap() {
        listener?.didTapAddPaymentMethod()
    }
    
    func update(with viewModels: [PaymentMethodViewModel]) {
        cardOnFiledStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        // [paymentMethodViewModel] -> [paymentMethodView]
        let views = viewModels.map(PaymentMethodView.init)
        
        views.forEach {
            $0.roundCorners()
            cardOnFiledStackView.addArrangedSubview($0)
        }
        
        cardOnFiledStackView.addArrangedSubview(addMethodButton)
        
        let heightConstraints = views.map({ $0.heightAnchor.constraint(equalToConstant: 60) })
        NSLayoutConstraint.activate(heightConstraints)
    }
}

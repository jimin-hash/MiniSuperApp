//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import ModernRIBs
import UIKit
import RIBsUtil
import SuperUI

protocol AddPaymentMethodPresentableListener: AnyObject {
    func didTapClose()
    func didTapConfirm(with number: String, cvc: String, expiry: String)
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {
    
    weak var listener: AddPaymentMethodPresentableListener?
    
    private let cardNumberTextField: UITextField = {
        let textfIeld = makeTextField()
        textfIeld.placeholder = "카드 번호"
        textfIeld.accessibilityIdentifier = "addpaymentmethod_cardnumber_textfield"
        return textfIeld
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 14
        return stackView
    }()
    
    private let securityTextField: UITextField = {
        let textfIeld = makeTextField()
        textfIeld.placeholder = "CVC"
        textfIeld.accessibilityIdentifier = "addpaymentmethod_security_textfield"
        return textfIeld
    }()
    
    private let expireTextField: UITextField = {
        let textfIeld = makeTextField()
        textfIeld.placeholder = "유효기한"
        textfIeld.accessibilityIdentifier = "addpaymentmethod_expiry_textfield"
        return textfIeld
    }()
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.backgroundColor = .primaryRed
        button.setTitle("추가하기", for: .normal)
        button.addTarget(self, action: #selector(didTapAddCard), for: .touchUpInside)
        button.accessibilityIdentifier = "addpaymentmethod_addcard_button"
        return button
    }()
    
    init(closeButtonType: DismissButtonType) {
        super.init(nibName: nil, bundle: nil)
        
        setupNavigationItem(with: closeButtonType, target: self, action: #selector(didTapClose))
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNavigationItem(with: .close, target: self, action: #selector(didTapClose))
        
        self.setupViews()
    }
    
    private func setupViews() {
        title = "카드 추가"
        
        view.backgroundColor = .backgroundColor
        view.addSubview(cardNumberTextField)
        view.addSubview(stackView)
        view.addSubview(addCardButton)
        
        stackView.addArrangedSubview(securityTextField)
        stackView.addArrangedSubview(expireTextField)
        
        NSLayoutConstraint.activate([
            cardNumberTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            cardNumberTextField.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -40),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stackView.bottomAnchor.constraint(equalTo: addCardButton.topAnchor, constant: -20),
            
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cardNumberTextField.heightAnchor.constraint(equalToConstant: 60),
            securityTextField.heightAnchor.constraint(equalToConstant: 60),
            expireTextField.heightAnchor.constraint(equalToConstant: 60),
            addCardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private static func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }
    
    @objc private func didTapAddCard() {
        if let number = cardNumberTextField.text,
           let cvc = securityTextField.text,
           let expiry = expireTextField.text {
            listener?.didTapConfirm(with: number, cvc: cvc, expiry: expiry)
        }
    }
    
    @objc private func didTapClose() {
        listener?.didTapClose()
    }
}

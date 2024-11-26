//
//  AddPaymentMethodInterface.swift
//  Finance
//
//  Created by Jimin Park on 11/26/24.
//

import Foundation
import ModernRIBs
import FinanceEntity
import RIBsUtil

public protocol AddPaymentMethodBuildable: Buildable {
    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting
}

public protocol AddPaymentMethodListener: AnyObject {
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}

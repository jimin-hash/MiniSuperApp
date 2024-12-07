//
//  CardOnFileMock.swift
//  Finance
//
//  Created by Jimin Park on 12/5/24.
//

@testable import TopupImp
import Foundation
import RIBsTestSupport
import FinanceEntity

final class CardOnFileBuildableMock: CardOnFileBuildable {
    var buildHandler: ((_ listener: CardOnFileListener) -> CardOnFileRouting)?
    
    var buildCallCount = 0
    var buildPaymentMethods: [PaymentMethod]?
    func build(withListener listener: CardOnFileListener, paymentMethod: [PaymentMethod]) -> CardOnFileRouting {
        buildCallCount += 1
        buildPaymentMethods = paymentMethod
        
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        
        fatalError()
    }
}

final class CardOnFileRoutingMock: ViewableRoutingMock, CardOnFileRouting {
    
}

//
//  SuperPayRepositoryMock.swift
//  Finance
//
//  Created by Jimin Park on 12/3/24.
//

import Foundation
import CombineUtil
import Combine
import FinanceRepository

public final class SuperPayRepositoryMock: SuperPayRepository {
    
    public var balanceSubject = CurrentValuePublisher<Double>(0.0)
    public var balance: ReadOnlyCurrentValuePublisher<Double>{ balanceSubject }
    
    public var topupCallCount = 0
    public var topupAmount: Double?
    public var paymentMethodID: String?
    public var shouldTopupSucceed: Bool = true
    public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, any Error> {
        topupCallCount += 1
        topupAmount = amount
        self.paymentMethodID = paymentMethodID
        
        if shouldTopupSucceed {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "SuperPayRepositoryMock", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
    }
    
    public init() {
        
    }
}

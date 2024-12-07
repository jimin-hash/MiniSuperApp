//
//  TopupMock.swift
//  Finance
//
//  Created by Jimin Park on 12/5/24.
//

import Foundation
import Topup

public final class TopupListenerMock: TopupListener {
    
    public var topupCloseCallCount = 0
    public func topupClose() {
        topupCloseCallCount += 1
    }
    
    public var topupDidFinishCallCount = 0
    public func topupDidFinish() {
        topupDidFinishCallCount += 1
    }
    
    public init() {
    }
}


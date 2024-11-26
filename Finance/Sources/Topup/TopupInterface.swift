//
//  TopupInterface.swift
//  Finance
//
//  Created by Jimin Park on 11/26/24.
//

import Foundation
import ModernRIBs

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
    func topupClose()
    func topupDidFinish()
}

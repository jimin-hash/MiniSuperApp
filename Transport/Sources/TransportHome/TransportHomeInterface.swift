//
//  TransportHomeInterface.swift
//  Transport
//
//  Created by Jimin Park on 11/26/24.
//

import Foundation
import ModernRIBs

public protocol TransportHomeBuildable: Buildable {
    func build(withListener listener: TransportHomeListener) -> ViewableRouting
}

public protocol TransportHomeListener: AnyObject {
    func transportHomeDidTapClose()
}

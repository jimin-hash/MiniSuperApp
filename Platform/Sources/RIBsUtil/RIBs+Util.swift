//
//  RIBs+Util.swift
//  Platform
//
//  Created by Jimin Park on 11/23/24.
//

import Foundation

public enum DismissButtonType {
    case back, close
    
    public var iconSystemName: String {
        switch self {
        case .back:
            return "chevron.backward"
        case .close:
            return "xmark"
        }
    }
}

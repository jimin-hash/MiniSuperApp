//
//  Array+Utils.swift
//  Finance
//
//  Created by Jimin Park on 11/23/24.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}

//
//  TestUtil.swift
//  MiniSuperAppUITests
//
//  Created by Jimin Park on 12/8/24.
//

import Foundation

enum TestUtilError: Error {
    case fileNotFound
}

public final class TestUtil {
    static public func path(for fileName: String, in bundleClass: AnyClass) throws -> String {
        if let path = Bundle(for: bundleClass).path(forResource: fileName, ofType: nil) {
            return path
        } else {
            throw TestUtilError.fileNotFound
        }
    }
}

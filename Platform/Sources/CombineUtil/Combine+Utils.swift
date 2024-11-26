//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/3/24.
//

import Foundation
import Combine
import CombineExt

// subscriber들이 가장 최신의 값을 접근할 수 있게 하되, 직접 값을 send할 수는 없게 함
// ex) 잔액을 관리하는 객체가 currentValuePubliser를 생성해서 잔액이 바뀔 떄마다 샌드를 해주지만, 잔액을 사용하는 객체들은 부모 객체인 readOnly 타입으로 받아서 직접 send를 하지 않고 현재 값만 받아갈 수 있게 함
public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
    public typealias Output = Element
    public typealias Failure = Never
    
    public var value: Element {
        currentvalueRelay.value
    }
    
    fileprivate let currentvalueRelay: CurrentValueRelay<Output>
    
    fileprivate init(_ initialValue: Element) {
        currentvalueRelay = CurrentValueRelay(initialValue)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
        currentvalueRelay.receive(subscriber: subscriber)
    }
}

public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
    typealias Output = Element
    typealias Failure = Never
    
    public override init(_ initialValue: Element) {
        super.init(initialValue)
    }
    
    public func send(_ value: Element) {
        currentvalueRelay.accept(value)
    }
}

extension ReadOnlyCurrentValuePublisher: @unchecked Sendable where Element: Sendable {}
extension CurrentValuePublisher: @unchecked Sendable where Element: Sendable {}


public final class FutureResultWrapper<Output, Failure: Error>: @unchecked Sendable {
    public typealias Promise = (Result<Output, Failure>) -> Void

    public let completionResult: Promise

    /// Creates a publisher that invokes a promise closure when the publisher emits an element.
    ///
    /// - Parameter attemptToFulfill: A ``Future/Promise`` that the publisher invokes when the publisher emits an element or terminates with an error.
    public init(_ attemptToFulfill: @escaping Promise) {
        self.completionResult = attemptToFulfill
    }
}

//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by Jimin Park on 11/4/24.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil
import Network

// 유저에게 등록된 카드 목록 API 호출
// 카드 목록은 데이터 스트립으로 가지고 있을거고, 카드 목록이 필요한 곳에 subscribe 할 수 있게 하기 위해 protocol 생성
public protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
    func fetch()
}

public final class CardOnFileRepositoryImp: CardOnFileRepository {
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodSubject }
    
    private let paymentMethodSubject  = CurrentValuePublisher<[PaymentMethod]>([
        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentMethod(id: "1", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
        //        PaymentMethod(id: "2", name: "현대카드", digits: "2345", color: "#78c5f5ff", isPrimary: false),
        //        PaymentMethod(id: "3", name: "국민은행", digits: "8656", color: "#65c466ff", isPrimary: false),
        //        PaymentMethod(id: "4", name: "카카오뱅크", digits: "3444", color: "#ffcc00 ff", isPrimary: false),
    ])
    
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, any Error> {
        let request = AddCardRequest(baseURL: baseURL, info: info)
        
        return network.send(request)
            .map(\.output.card )
            .handleEvents(receiveOutput: { [weak self] method in
                guard let self = self else { return }
                self.paymentMethodSubject.send(self.paymentMethodSubject.value + [method])
            })
            .eraseToAnyPublisher()
        
        
        //        let paymentMethod = PaymentMethod(id: "00", name: "NEW CARD", digits: "\(info.number.prefix(4))", color: "", isPrimary: false)
        //
        //        var new = paymentMethodSubject.value
        //        new.append(paymentMethod)
        //        paymentMethodSubject.send(new)
        //
        //        return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func fetch() {
        let request = CarOnFileRequest(baseURL: baseURL)
        network.send(request).map(\.output.cards)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] cards in
                self?.paymentMethodSubject.send(cards)
            })
            .store(in: &cancellables)
        
    }
    
    private let network: Network
    private let baseURL: URL
    private var cancellables: Set<AnyCancellable>
    
    public init(network: Network, baseURL: URL) {
        self.network = network
        self.baseURL = baseURL
        self.cancellables = .init()
    }
}

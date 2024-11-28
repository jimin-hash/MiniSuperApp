import Foundation

// OCP 준수 X
//public protocol DefaultsStore {
//    var isInitialLaunch: Bool { get set }
//    var lastNoticeDate: Double { get set }
//}
//
//public struct DefaultsStoreImp: DefaultsStore {
//    
//    public var isInitialLaunch: Bool {
//        get {
//            userDefaults.bool(forKey: kIsInitialLaunch)
//        }
//        set {
//            userDefaults.set(newValue, forKey: kIsInitialLaunch)
//        }
//    }
//    
//    public var lastNoticeDate: Double {
//        get {
//            userDefaults.double(forKey: kLastNoticeDate)
//        }
//        set { 
//            userDefaults.set(newValue, forKey: kLastNoticeDate)
//        }
//    }
//    
//    private let userDefaults: UserDefaults
//    
//    private let kIsInitialLaunch = "kIsInitialLaunch"
//    private let kLastNoticeDate = "kLastNoticeDate"
//    
//    public init(defaults: UserDefaults) {
//        self.userDefaults = defaults
//    }
//    
//}

// OCP 준수 O
public protocol DefaultsStore {
    func get<T>(key: String, defaultValue: T) -> T
    func set<T>(key: String, value: T)
}

public struct DefaultsStoreImp: DefaultsStore {
    private let userDefaults: UserDefaults

    public init(defaults: UserDefaults) {
        self.userDefaults = defaults
    }

    public func get<T>(key: String, defaultValue: T) -> T {
        return userDefaults.object(forKey: key) as? T ?? defaultValue
    }

    public func set<T>(key: String, value: T) {
        userDefaults.set(value, forKey: key)
    }
}


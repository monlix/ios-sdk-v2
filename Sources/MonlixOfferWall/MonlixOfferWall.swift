import UIKit
import WebKit

@MainActor
public class MonlixOfferWall: NSObject {
    // Required parameters
    private static var appKey: String = ""
    private static var appZoneId: String = ""
    private static var userId: String = ""
    
    // Optional parameters
    private static var age: String?
    private static var gender: String?
    private static var deviceId: String?
    private static var idfa: String?
    private static var source: String?
    private static var sub1: String?
    private static var sub2: String?
    private static var sub3: String?
    private static var sub4: String?
    private static var sub5: String?
    
    private static var _isInitialized = false
    
    public class Builder {
        private var appKey: String = ""
        private var appZoneId: String = ""
        private var userId: String = ""
        private var age: Int?
        private var gender: Gender?
        private var deviceId: String?
        private var idfa: String?
        private var source: String?
        private var sub1: String?
        private var sub2: String?
        private var sub3: String?
        private var sub4: String?
        private var sub5: String?
        
        public init() {}
        
        @discardableResult
        public func setAppKey(_ appKey: String) -> Builder {
            self.appKey = appKey
            return self
        }
        
        @discardableResult
        public func setAppZoneId(_ appZoneId: String) -> Builder {
            self.appZoneId = appZoneId
            return self
        }
        
        @discardableResult
        public func setUserId(_ userId: String) -> Builder {
            self.userId = userId
            return self
        }
        
        @discardableResult
        public func setAge(_ age: Int) -> Builder {
            self.age = age
            return self
        }
        
        @discardableResult
        public func setGender(_ gender: Gender) -> Builder {
            self.gender = gender
            return self
        }
        
        @discardableResult
        public func setDeviceId(_ deviceId: String) -> Builder {
            self.deviceId = deviceId
            return self
        }
        
        @discardableResult
        public func setIdfa(_ idfa: String) -> Builder {
            self.idfa = idfa
            return self
        }
        
        @discardableResult
        public func setSource(_ source: String) -> Builder {
            self.source = source
            return self
        }
        
        @discardableResult
        public func setSub1(_ sub1: String) -> Builder {
            self.sub1 = sub1
            return self
        }
        
        @discardableResult
        public func setSub2(_ sub2: String) -> Builder {
            self.sub2 = sub2
            return self
        }
        
        @discardableResult
        public func setSub3(_ sub3: String) -> Builder {
            self.sub3 = sub3
            return self
        }
        
        @discardableResult
        public func setSub4(_ sub4: String) -> Builder {
            self.sub4 = sub4
            return self
        }
        
        @discardableResult
        public func setSub5(_ sub5: String) -> Builder {
            self.sub5 = sub5
            return self
        }
        
        @MainActor
        public func build() -> MonlixOfferWall {
            return MonlixOfferWall.initialize(
                appKey: self.appKey,
                appZoneId: self.appZoneId,
                userId: self.userId,
                age: self.age?.description,
                gender: self.gender?.code,
                deviceId: self.deviceId,
                idfa: self.idfa,
                source: self.source,
                sub1: self.sub1,
                sub2: self.sub2,
                sub3: self.sub3,
                sub4: self.sub4,
                sub5: self.sub5
            )
        }
    }
    
    @discardableResult
    private static func initialize(
        appKey: String,
        appZoneId: String,
        userId: String,
        age: String?,
        gender: String?,
        deviceId: String?,
        idfa: String?,
        source: String?,
        sub1: String?,
        sub2: String?,
        sub3: String?,
        sub4: String?,
        sub5: String?
    ) -> MonlixOfferWall {
        self.appKey = appKey
        self.appZoneId = appZoneId
        self.userId = userId
        self.age = age
        self.gender = gender
        self.deviceId = deviceId
        self.idfa = idfa
        self.source = source
        self.sub1 = sub1
        self.sub2 = sub2
        self.sub3 = sub3
        self.sub4 = sub4
        self.sub5 = sub5
        
        _isInitialized = true
        return MonlixOfferWall()
    }
    
    public func open(from viewController: UIViewController, customZoneId: String? = nil) {
        guard MonlixOfferWall.isInitialized else {
            assertionFailure("MonlixOfferWall must be initialized with Builder before use")
            return
        }
        
        guard !MonlixOfferWall.appKey.isEmpty else {
            assertionFailure("App Key is required")
            return
        }
        
        guard !MonlixOfferWall.appZoneId.isEmpty else {
            assertionFailure("App Zone Id is required")
            return
        }
        
        guard !MonlixOfferWall.userId.isEmpty else {
            assertionFailure("User Id is required")
            return
        }
        
        if let customZoneId = customZoneId, !customZoneId.isEmpty {
            MonlixOfferWall.appZoneId = customZoneId
        }
        
        let webViewController = MonlixWebViewController()
        let navController = UINavigationController(rootViewController: webViewController)
        navController.modalPresentationStyle = .fullScreen
        viewController.present(navController, animated: true)
    }
    
    public func close() {
        MonlixOfferWall.close()
    }
    
    public static func close() {
        NotificationCenter.default.post(name: NSNotification.Name(MonlixConstants.CLOSE_ACTION), object: nil)
    }
    
    public static func getUrlWithParameters() -> String {
        var urlString = "\(MonlixConstants.BASE_URL)?app_key=\(appKey)"
        
        let params: [String: String?] = [
            "app_zone_id": appZoneId.isEmpty ? nil : appZoneId,
            "user_id": userId.isEmpty ? nil : userId,
            "age": age,
            "gender": gender,
            "deviceId": deviceId,
            "idfa": idfa,
            "source": source,
            "sub1": sub1,
            "sub2": sub2,
            "sub3": sub3,
            "sub4": sub4,
            "sub5": sub5
        ]
        
        for (key, value) in params {
            if let value = value, !value.isEmpty {
                urlString += "&\(key)=\(value)"
            }
        }
        
        urlString += "&sdk=\(MonlixConstants.SDK_VERSION)"
        
        return urlString
    }
    
    public static var isInitialized: Bool {
        return _isInitialized
    }
}

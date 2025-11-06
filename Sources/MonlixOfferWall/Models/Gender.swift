import Foundation

public enum Gender: String {
    case male = "m"
    case female = "f"
    case other = "o"
    
    public var code: String {
        return self.rawValue
    }
    
    public static func fromCode(_ code: String) -> Gender? {
        return Gender(rawValue: code)
    }
}

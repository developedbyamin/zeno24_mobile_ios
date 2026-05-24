import Foundation

/// Safe type conversions for JSON values — mirrors safe_converters.dart
enum SafeConverters {
    static func toInt(_ value: Any?) -> Int? {
        if let v = value as? Int { return v }
        if let v = value as? Double { return Int(v) }
        if let v = value as? String { return Int(v) }
        return nil
    }

    static func toDouble(_ value: Any?) -> Double? {
        if let v = value as? Double { return v }
        if let v = value as? Int { return Double(v) }
        if let v = value as? String { return Double(v) }
        return nil
    }

    static func toBool(_ value: Any?) -> Bool? {
        if let v = value as? Bool { return v }
        if let v = value as? Int { return v != 0 }
        if let v = value as? String { return ["1", "true", "yes"].contains(v.lowercased()) }
        return nil
    }

    static func toString(_ value: Any?) -> String? {
        if let v = value as? String { return v }
        if let v = value { return String(describing: v) }
        return nil
    }
}

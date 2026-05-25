import Foundation

enum PhoneFormattingUtils {
    static func sanitize(_ raw: String) -> String {
        raw.filter(\.isNumber)
    }

    static func isValid(_ raw: String) -> Bool {
        let digits = sanitize(raw)
        return digits.count >= 7 && digits.count <= 15
    }

    static func format(_ digits: String, isoCode: String) -> String {
        let n = digits.count
        func sub(_ from: Int, _ to: Int? = nil) -> String {
            let start = digits.index(digits.startIndex, offsetBy: from)
            let end = to.map { digits.index(digits.startIndex, offsetBy: $0) } ?? digits.endIndex
            return String(digits[start..<end])
        }

        switch isoCode {
        case "AZ":
            if n <= 2 { return digits }
            if n <= 5 { return "\(sub(0, 2)) \(sub(2))" }
            if n <= 7 { return "\(sub(0, 2)) \(sub(2, 5)) \(sub(5))" }
            return "\(sub(0, 2)) \(sub(2, 5)) \(sub(5, 7)) \(sub(7))"

        case "TR":
            if n <= 3 { return digits }
            if n <= 6 { return "\(sub(0, 3)) \(sub(3))" }
            if n <= 8 { return "\(sub(0, 3)) \(sub(3, 6)) \(sub(6))" }
            return "\(sub(0, 3)) \(sub(3, 6)) \(sub(6, 8)) \(sub(8))"

        case "US", "CA":
            if n <= 3 { return "(\(digits)" }
            if n <= 6 { return "(\(sub(0, 3))) \(sub(3))" }
            return "(\(sub(0, 3))) \(sub(3, 6))-\(sub(6))"

        case "GB":
            if n <= 4 { return digits }
            return "\(sub(0, 4)) \(sub(4))"

        case "RU":
            if n <= 3 { return digits }
            if n <= 6 { return "\(sub(0, 3)) \(sub(3))" }
            if n <= 8 { return "\(sub(0, 3)) \(sub(3, 6))-\(sub(6))" }
            return "\(sub(0, 3)) \(sub(3, 6))-\(sub(6, 8))-\(sub(8))"

        case "DE":
            if n <= 3 { return digits }
            return "\(sub(0, 3)) \(sub(3))"

        case "FR":
            if n <= 1 { return digits }
            if n <= 3 { return "\(sub(0, 1)) \(sub(1))" }
            if n <= 5 { return "\(sub(0, 1)) \(sub(1, 3)) \(sub(3))" }
            if n <= 7 { return "\(sub(0, 1)) \(sub(1, 3)) \(sub(3, 5)) \(sub(5))" }
            return "\(sub(0, 1)) \(sub(1, 3)) \(sub(3, 5)) \(sub(5, 7)) \(sub(7))"

        case "IT", "ES", "PT", "PL", "RO":
            if n <= 3 { return digits }
            if n <= 6 { return "\(sub(0, 3)) \(sub(3))" }
            return "\(sub(0, 3)) \(sub(3, 6)) \(sub(6))"

        case "CN":
            if n <= 3 { return digits }
            if n <= 7 { return "\(sub(0, 3)) \(sub(3))" }
            return "\(sub(0, 3)) \(sub(3, 7)) \(sub(7))"

        case "JP":
            if n <= 2 { return digits }
            if n <= 6 { return "\(sub(0, 2))-\(sub(2))" }
            return "\(sub(0, 2))-\(sub(2, 6))-\(sub(6))"

        case "IN":
            if n <= 5 { return digits }
            return "\(sub(0, 5)) \(sub(5))"

        case "BR":
            if n <= 2 { return digits }
            if n <= 7 { return "\(sub(0, 2)) \(sub(2))" }
            return "\(sub(0, 2)) \(sub(2, 7))-\(sub(7))"

        case "AU", "SA", "AE", "MX":
            if n <= 3 { return digits }
            if n <= 6 { return "\(sub(0, 3)) \(sub(3))" }
            return "\(sub(0, 3)) \(sub(3, 6)) \(sub(6))"

        default:
            if n <= 3 { return digits }
            if n <= 6 { return "\(sub(0, 3)) \(sub(3))" }
            return "\(sub(0, 3)) \(sub(3, 6)) \(sub(6))"
        }
    }

    static func maxLength(isoCode: String) -> Int {
        switch isoCode {
        case "AZ": return 9
        case "TR": return 10
        case "US", "CA", "GB", "RU", "IT", "IN", "JP", "MX",
             "PL", "ES", "PT", "RO":
            return 10
        case "DE", "CN", "BR":
            return 11
        case "FR", "AU", "SA", "AE":
            return 9
        default: return 10
        }
    }
}

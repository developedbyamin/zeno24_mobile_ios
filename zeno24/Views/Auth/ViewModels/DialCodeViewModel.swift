import SwiftUI

@MainActor
@Observable
final class DialCodeViewModel {
    var query: String = ""

    var filtered: [Country] {
        let q = query.lowercased()
        return CountriesData.all.filter {
            $0.name.lowercased().contains(q) || $0.dialCode.contains(q)
        }
    }

    var sortedPopular: [Country] {
        CountriesData.all.filter(\.isPopular).sorted { $0.name < $1.name }
    }

    var sortedRegular: [Country] {
        CountriesData.all.filter { !$0.isPopular }.sorted { $0.name < $1.name }
    }

    var grouped: [String: [Country]] {
        Dictionary(grouping: sortedRegular) {
            String($0.name.prefix(1)).uppercased()
        }
    }

    var letters: [String] {
        grouped.keys.sorted()
    }

    func clearQuery() {
        query = ""
    }
}

import Foundation


struct Representative: Identifiable, Decodable, Hashable {
    let id = UUID()
    let name: String
    let party: String
    let state: String
    let district: String
    let phone: String
    let office: String
    let link: String

    enum CodingKeys: String, CodingKey {
        case name, party, state, district, phone, office, link
    }
}

struct RepresentativeResponse: Decodable {
    let results: [Representative]
}


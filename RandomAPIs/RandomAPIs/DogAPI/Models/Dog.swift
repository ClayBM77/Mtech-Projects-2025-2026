import Foundation

struct Dog: Identifiable, Equatable, Hashable {
    let id: UUID
    var imageURL: URL
    var name: String

    init(id: UUID = UUID(), imageURL: URL, name: String = "") {
        self.id = id
        self.imageURL = imageURL
        self.name = name
    }
}

struct DogImageResponse: Decodable {
    let message: String
    let status: String
}


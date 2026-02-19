import Foundation


protocol DogAPIControllerProtocol {
    func fetchRandomDogImage() async throws -> URL
}


final class DogAPIController: DogAPIControllerProtocol {
    func fetchRandomDogImage() async throws -> URL {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(DogImageResponse.self, from: data)
        guard decoded.status == "success", let url = URL(string: decoded.message) else {
            throw URLError(.cannotParseResponse)
        }
        return url
    }
}


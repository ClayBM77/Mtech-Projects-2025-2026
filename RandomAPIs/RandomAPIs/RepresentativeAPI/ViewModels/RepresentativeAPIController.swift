import Foundation


protocol RepresentativeAPIControllerProtocol {
    func search(byZip zip: String) async throws -> [Representative]
}
final class StubAPIController: RepresentativeAPIControllerProtocol {
    func search(byZip zip: String) async throws -> [Representative] {
        return [
            Representative(
                name: "Bridger Mason",
                party: "definitely likes parties",
                state: "UT",
                district: "13",
                phone: "1",
                office: "just down the road from here",
                link: "lds.org"
            )
        ]
    }
}

final class FakeAPIController: RepresentativeAPIControllerProtocol {
    func search(byZip zip: String) async throws -> [Representative] {
        throw URLError(.badServerResponse)
    }
}
final class RepresentativeAPIController: RepresentativeAPIControllerProtocol {
    func search(byZip zip: String) async throws -> [Representative] {
        let trimmed = zip.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count == 5, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: trimmed)) else {
            throw URLError(.badURL)
        }
        var comps = URLComponents(string: "https://whoismyrepresentative.com/getall_mems.php")!
        comps.queryItems = [
            URLQueryItem(name: "zip", value: trimmed),
            URLQueryItem(name: "output", value: "json")
        ]
        var request = URLRequest(url: comps.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        do {
            let decoded = try decoder.decode(RepresentativeResponse.self, from: data)
            return decoded.results
        } catch {
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let arr = json["results"] as? [[String: String]] {
                let reps: [Representative] = arr.map { dict in
                    Representative(
                        name: dict["name"] ?? "Unknown",
                        party: dict["party"] ?? "",
                        state: dict["state"] ?? "",
                        district: dict["district"] ?? "",
                        phone: dict["phone"] ?? "",
                        office: dict["office"] ?? "",
                        link: dict["link"] ?? ""
                    )
                }
                return reps
            }
            throw error
        }
    }
}


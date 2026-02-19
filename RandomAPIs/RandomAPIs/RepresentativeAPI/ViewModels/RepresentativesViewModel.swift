import Foundation


@Observable
class RepresentativesViewModel {
    let api: RepresentativeAPIControllerProtocol

    var zip: String = ""
    var results: [Representative] = []
    var isLoading: Bool = false
    var errorMessage: String?

    init(api: RepresentativeAPIControllerProtocol) {
        self.api = api
    }

    func search() async {
        isLoading = true
        errorMessage = nil
        do {
            results = try await api.search(byZip: zip)
        } catch {
            errorMessage = "Failed to fetch representatives. Check ZIP and try again."
            results = []
        }
        isLoading = false
    }
}


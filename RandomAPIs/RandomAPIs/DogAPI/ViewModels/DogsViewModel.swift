import Foundation


@Observable
class DogsViewModel {
    let api: DogAPIControllerProtocol

    var currentImageURL: URL?
    var currentName: String = ""
    var dogs: [Dog] = []
    var isLoading: Bool = false
    var errorMessage: String?

    init(api: DogAPIControllerProtocol) {
        self.api = api
    }

    func loadInitialImage() async {
        if currentImageURL == nil {
            await newImage(pushCurrent: false)
        }
    }

    func newImage(pushCurrent: Bool = true) async {
        if pushCurrent, let url = currentImageURL {
            let trimmed = currentName.trimmingCharacters(in: .whitespacesAndNewlines)
            dogs.insert(Dog(imageURL: url, name: trimmed), at: 0)
            currentName = ""
        }
        isLoading = true
        errorMessage = nil
        do {
            let url = try await api.fetchRandomDogImage()
            currentImageURL = url
        } catch {
            errorMessage = "Failed to load dog image. Please try again."
        }
        isLoading = false
    }

    func updateName(for dog: Dog, to newName: String) {
        if let idx = dogs.firstIndex(of: dog) {
            dogs[idx].name = newName
        }
    }
}


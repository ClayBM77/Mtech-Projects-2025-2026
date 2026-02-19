

import SwiftUI

struct DogDetailView: View {
    let dog: Dog
    var onSave: (String) -> Void
    @State private var name: String

    init(dog: Dog, onSave: @escaping (String) -> Void) {
        self.dog = dog
        self.onSave = onSave
        _name = State(initialValue: dog.name)
    }

    var body: some View {
        Form {
            Section("Dog Info") {
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: dog.imageURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading) {
                        TextField("Name", text: $name)
                    }
                }
            }
        }
        .navigationTitle("Edit Dog")
        
    }
}

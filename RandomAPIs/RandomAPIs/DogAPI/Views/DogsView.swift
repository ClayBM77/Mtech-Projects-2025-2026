import SwiftUI


struct DogsView: View {
    @State private var viewModel: DogsViewModel

    init(api: DogAPIControllerProtocol) {
        _viewModel = State(initialValue: DogsViewModel(api: api))
    }

    var body: some View {
        @Bindable var model = viewModel

        NavigationStack {
            VStack(spacing: 16) {
                Group {
                    if let url = model.currentImageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: 240)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 240)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 240)
                                    .foregroundStyle(.secondary)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else if model.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 240)
                    } else {
                        Text("Tap New Image to begin")
                            .frame(maxWidth: .infinity, maxHeight: 240)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)

                HStack {
                    TextField("Name this dog", text: $model.currentName)
                        .textFieldStyle(.roundedBorder)
                    Button("New Image") {
                        Task { await viewModel.newImage(pushCurrent: true) }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(model.isLoading)
                }

                List {
                    ForEach(model.dogs) { dog in
                        NavigationLink(value: dog) {
                            DogListCell(dog: dog)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Dogs")
            .navigationDestination(for: Dog.self) { dog in
                DogDetailView(dog: dog) { updatedName in
                    viewModel.updateName(for: dog, to: updatedName)
                }
            }
            .task { await viewModel.loadInitialImage() }
            .alert("Error", isPresented: .constant(model.errorMessage != nil), actions: {
                Button("OK") { viewModel.errorMessage = nil }
            }, message: {
                Text(model.errorMessage ?? "")
            })
        }
    }
}





#Preview("Dogs") {
    DogsView(api: DogAPIController())
}


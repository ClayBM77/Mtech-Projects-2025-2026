import SwiftUI


struct RepresentativesView: View {
    @State private var viewModel: RepresentativesViewModel

    init(api: RepresentativeAPIControllerProtocol) {
        _viewModel = State(initialValue: RepresentativesViewModel(api: api))
    }

    var body: some View {
        @Bindable var model = viewModel

        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    TextField("Enter ZIP code", text: $model.zip)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    Button("Search") {
                        Task { await viewModel.search() }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.zip.trimmingCharacters(in: .whitespacesAndNewlines).count != 5)
                }

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }

                List(viewModel.results) { rep in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(rep.name)
                            .font(.headline)
                        Text("\(rep.party) • \(rep.state) \(rep.district)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            Image(systemName: "phone")
                            Text(rep.phone)
                        }
                        .font(.caption)
                    }
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Representatives")
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK") { viewModel.errorMessage = nil }
            }, message: {
                Text(viewModel.errorMessage ?? "")
            })
        }
    }
}

#Preview("Representatives") {
    RepresentativesView(api: RepresentativeAPIController())
}


struct PickDirectory<Label: View>: View {
    @State private var showFileImporter = false
    var handlePickedDir: (URL) -> Void
    var buttonLabel: Label
    
    var body: some View {
        Button {
            showFileImporter = true
        } label: {
            buttonLabel
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let dirs):
                dirs.forEach { dir in
                    // Gain access to directory?
                    let gotAccess = dir.startAccessingSecurityScopedResource()
                    if !gotAccess { return }
                    handlePickedDir(dir)
                    dir.stopAccessingSecurityScopedResource()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
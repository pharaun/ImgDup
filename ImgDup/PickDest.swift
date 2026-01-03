            VStack(alignment: .leading) {
                PickDirectory(handlePickedDir: { url in
                    print(url)
                }, buttonLabel: Label("Dest", systemImage: "heart"))
                TextField("Dir",
                    text: $dest
                ) {}
                List(path_choice) {
                    Text($0.path)
                }
            }
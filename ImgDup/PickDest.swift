//
//  PickDest.swift
//  ImgDup
//
//  Created by Anja Berens on 1/3/26.
//

import SwiftUI

struct DestPath: Identifiable {
    let path: String
    let id = UUID()
}

struct PickDest: View {
    @State private var dest: String = ""
    @State private var path_choice = [
        DestPath(path: "pics"),
        DestPath(path: "asdf"),
        DestPath(path: "foobar"),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            PickDirectory(handlePickedDir: { url in
                // For now do a directory walk
                // to generate a list of directory
                // Then use that to set path_choice
                print(url)
            }, buttonLabel: Label("Dest", systemImage: "heart"))
            TextField("Dir",
                text: $dest
            ) {}
            List(path_choice) {
                Text($0.path)
            }
        }
    }
}

#Preview {
    PickDest()
}

//
//  PickDest.swift
//  ImgDup
//
//  Created by Anja Berens on 1/3/26.
//

import SwiftUI

// TODO: probs want to have the path url for later file move operations
struct DestPath: Identifiable {
    let path: String
    let id = UUID()
}

let localFileManager = FileManager()

struct PickDest: View {
    @State private var dest: String = ""
    @State private var path_choice: [DestPath] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            PickDirectory(handlePickedDir: { url in
                // Clear the existing entries first
                path_choice.removeAll()
                PickDirHandler(
                    url: url,
                    closure: { path in
                        path_choice.append(DestPath(path: path))
                    }
                )
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

func PickDirHandler(url: URL, closure: (String) -> Void) {
    let resourceKeys = Set<URLResourceKey>([.isDirectoryKey, .pathKey])
    
    // Parent
    guard let resourceValues = try? url.resourceValues(forKeys: resourceKeys),
          let parent_path = resourceValues.path
    else {
        return
    }
    
    // Descendants
    let directoryEnumerator = localFileManager.enumerator(
        at: url,
        includingPropertiesForKeys: Array(resourceKeys),
        options: .skipsHiddenFiles,
    )!
    
    for case let directoryURL as URL in directoryEnumerator {
        guard let resourceValues = try? directoryURL.resourceValues(forKeys: resourceKeys),
              let isDirectory = resourceValues.isDirectory,
              let path = resourceValues.path
        else {
            continue
        }
        
        if isDirectory {
            var new_path = String.init(
                path.suffix(from: parent_path.endIndex)
            )
            new_path.removeFirst(1)
            closure(new_path)
        }
    }
}

#Preview {
    PickDest()
}

//
//  PickDest.swift
//  ImgDup
//
//  Created by Anja Berens on 1/3/26.
//

import SwiftUI

let localFileManager = FileManager()

struct DestPath: Identifiable {
    let id = UUID()
    let path: String
    let url: URL
}

extension PickDestView {
    @Observable
    class ViewModel {
        var dest: String = ""
        var path_choice: [DestPath] = []
        
        func clear_choice() {
            path_choice.removeAll()
        }
        
        func update_choice(url: URL) {
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
                    
                    path_choice.append(DestPath(
                        path: new_path,
                        url: directoryURL,
                    ))
                }
            }
        }
    }
}

struct PickDestView: View {
    @State var viewModel = ViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            PickDirectory(handlePickedDir: { url in
                // Clear the existing entries first
                viewModel.clear_choice()
                viewModel.update_choice(url: url)
            }, buttonLabel: Label("Dest", systemImage: "heart"))
            TextField("Dir",
                text: $viewModel.dest
            ) {}
            List(viewModel.path_choice) {
                Text($0.path)
            }
        }
    }
}



#Preview {
    let viewModel = PickDestView.ViewModel()
    viewModel.path_choice = [
        DestPath(path: "asdf", url: URL(string: "asdf")!),
        DestPath(path: "basdf", url: URL(string: "basdf")!),
        DestPath(path: "bad", url: URL(string: "bad")!),
    ]
    return PickDestView(viewModel: viewModel)
}

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
        var search_dest: String = ""
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
        
        func search() {
            
        }
    }
}

struct PickDestView: View {
    @FocusState private var isSearchFocused: Bool
    @State var viewModel = ViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            PickDirectory(handlePickedDir: { url in
                // Clear the existing entries first
                viewModel.clear_choice()
                viewModel.update_choice(url: url)
            }, buttonLabel: Label("Dest", systemImage: "heart"))
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(
                        Color(.secondaryLabelColor)
                    )
                
                TextField(
                    "Search",
                    text: $viewModel.search_dest,
                )
                .textFieldStyle(.plain)
                .padding(.vertical, 8)
                .focused($isSearchFocused)
                
                if viewModel.search_dest != "" {
                    Button(action: {
                        viewModel.search_dest = ""
                    }) {
                        Image(
                            systemName: "xmark.circle.fill"
                        )
                        .foregroundStyle(
                            Color(.secondaryLabelColor)
                        )
                    }
                    .padding(.horizontal, -8)
                    .buttonStyle(.borderless)
                }
                
                    
            }
            .padding(.horizontal)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(
                    cornerRadius: 20
                ).stroke(
                    isSearchFocused ? Color(.blue) :
                    Color(.systemGray).opacity(0.3),
                    lineWidth: isSearchFocused ? 2 : 1
                )
            )

            List(viewModel.path_choice) {
                Text($0.path)
            }.searchable(text: $viewModel.search_dest)
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

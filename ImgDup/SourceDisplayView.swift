//
//  SourceDisplay.swift
//  ImgDup
//
//  Created by Anja Berens on 1/3/26.
//

import SwiftUI

struct SourceDisplay: View {
    var body: some View {
        VStack(alignment: .leading) {
            PickDirectory(handlePickedDir: { url in
                print(url)
            }, buttonLabel: Label("Source", systemImage: "heart"))
            ZStack {
                Image(systemName: "globe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 400, alignment: .topLeading)
                Text("File")
            }
        }
    }
}

#Preview {
    SourceDisplay()
}

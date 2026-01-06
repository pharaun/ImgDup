//
//  ContentView.swift
//  ImgDup
//
//  Created by Anja Berens on 1/2/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            SourceDisplay()
            PickDest()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

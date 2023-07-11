//
//  ControlsView.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI

struct ControlsView: View {
    var body: some View {
        HStack {
            VStack {
                Button {
                } label: {
                    Image(systemName: "xmark")
                }
                .tint(.red)
                .font(.title2)
                Text("End")
            }
            VStack {
                Button {
                } label: {
                    Image(systemName: "pause")
                }
                .tint(.yellow)
                .font(.title2)
                Text("Pause")

            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}

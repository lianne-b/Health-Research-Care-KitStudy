//
//  SessionPagingView.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI

struct SessionPagingView: View {
    
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, metrics
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
        }
    }
}

struct SessionPagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView()
    }
}

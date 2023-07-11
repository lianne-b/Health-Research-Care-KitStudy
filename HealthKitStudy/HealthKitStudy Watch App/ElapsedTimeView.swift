//
//  ElapsedTimeView.swift
//  HealthKitStudy Watch App
//
//  Created by Ye Eun Choi on 2023/07/11.
//

import SwiftUI

// to format the elapsed time properly and hide or show subseconds based on the Always On state. -> create a custom ElapsedTimeFormatter
struct ElapsedTimeView: View {
    
    var elapsedTime: TimeInterval = 0
    var showSubSeconds: Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()
    
    // elapsedTime casted as an NSNumber for timeFormatter to use.
    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: showSubSeconds) {
                timeFormatter.showSubseconds = $0
            }
    }
    
    // a custom formatter that uses DateComponentsFormatter.
    // we want elapsedTime to show mins, secs, and pad zeros.
    class ElapsedTimeFormatter: Formatter {
        let componentsFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = .pad
            return formatter
        }()
        
        // showSubseconds detects if subseconds are shown.
        var showSubseconds = true
        
        override func string(for value: Any?) -> String? {
            // ensures the value is a TimeInterval.
            guard let time = value as? TimeInterval else {
                return nil
            }
            
            // ensures the componentFormatter returns a string
            guard let formattedString =
                    componentsFormatter.string(from: time) else {
                return nil
            }
            
            // if showSubseconds is true, calculate the subseconds by getting the truncatedRemainder by dividingBy 1, then multiplying by 100. Use a localized decimalSeparator, then return a formatted String, appending the subseconds.
            if showSubseconds {
                let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
                let decimalSeparator = Locale.current.decimalSeparator ?? "."
                return String(format: "%@%@%0.2d",
                formattedString, decimalSeparator, hundredths)
            }
            return formattedString
        }
    }
}

struct ElapsedTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ElapsedTimeView()
    }
}

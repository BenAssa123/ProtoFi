//
//  IsTimerRunningView.swift
//  PookPool
//
//  Created by Assa Bentzur on 10/07/2022.
//

import SwiftUI

struct IsTimerRunningView: View {
    @EnvironmentObject var stopWatch: StopWatchManager
    
    var body: some View {
        if stopWatch.isRunning {
            Text("\(Int(stopWatch.timeRemaining.rounded())) seconds left in step \(stopWatch.stepNumber)")
                .font(.system(size: 20, weight: .regular, design: .default))
                .multilineTextAlignment(.center)
                .frame(width: 200, height: 70, alignment: .center)
                .background(.gray)
                .cornerRadius(30)
                .padding(.bottom, 10)
        }
    }
}

//struct IsTimerRunningView_Previews: PreviewProvider {
//    static var previews: some View {
//        IsTimerRunningView()
//    }
//}

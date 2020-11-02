//
//  IndicatorPoint.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 03..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

struct IndicatorPoint: View {
    var body: some View {
        ZStack{
            Circle()
                .fill(Colors.IndicatorKnob)
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 3))
        }
        .frame(width: 12, height: 12)
        .shadow(color: Color.black.opacity(0.25), radius: 3)
    }
}

struct IndicatorPoint_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorPoint()
    }
}

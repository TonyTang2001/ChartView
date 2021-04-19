//
//  MagnifierRect.swift
//  
//
//  Created by Samu András on 2020. 03. 04..
//

import SwiftUI

public struct MagnifierRect: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var currentNumber1: Double
    @Binding var currentNumber2: Double
    
    @Binding var currentDate: String
    
    var valueSpecifier: String
    
    public var body: some View {
        ZStack{
            VStack {
                Text("\(self.currentNumber1, specifier: valueSpecifier)")
                    .font(.headline)
                    .foregroundColor(Color(UIColor.label))
                
                Spacer()

                Text("\(self.currentNumber2, specifier: valueSpecifier)")
                    .font(.headline)
                    .foregroundColor(Color(UIColor.label))
                
                Text("\(currentDate)")
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            .padding(.vertical, 12)
            
            
            if (self.colorScheme == .dark) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white, lineWidth: self.colorScheme == .dark ? 2 : 0)
                    .frame(width: 60, height: 260)
            } else {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .frame(width: 60, height: 280)
                    .foregroundColor(Color.white)
                    .shadow(color: Colors.LegendText, radius: 12, x: 0, y: 6 )
                    .blendMode(.multiply)
            }
        }
    }
}

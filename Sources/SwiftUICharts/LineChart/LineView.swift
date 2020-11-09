//
//  LineView.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 02..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct LineView: View {
    @ObservedObject var data: ChartDataArray
    public var title: String?
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public var valueSpecifier:String
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = true
    @State private var dragLocation:CGPoint = .zero
    @State private var indicatorLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var opacity:Double = 0
    @State private var currentDataNumbers: [Double] = [0, 0]
    @State private var hideHorizontalLines: Bool = false
    
    public init(data: [[Double]],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                valueSpecifier: String? = "%.1f") {
        
        var chartDataArray = [ChartData]()
        
        data.forEach { dataArray in
            chartDataArray.append(ChartData(points: dataArray))
        }
        self.data = ChartDataArray(from: chartDataArray, of: [Styles.lineChartStyleOne.gradientColor, Styles.barChartStyleNeonBlueLight.gradientColor])
        self.title = title
        self.legend = legend
        self.style = style
        self.valueSpecifier = valueSpecifier!
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                Group{
                    if (self.title != nil){
                        Text(self.title!)
                            .font(.title)
                            .bold().foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                    }
                    if (self.legend != nil){
                        Text(self.legend!)
                            .font(.callout)
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                    }
                }.offset(x: 0, y: 20)
                
                ZStack{
                    GeometryReader{ reader in
                        Rectangle()
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                        
                        Legend(data: getMergedDataForLegend(),
                               frame: .constant(reader.frame(in: .local)), hideHorizontalLines: self.$hideHorizontalLines)
                            .transition(.opacity)
                            .animation(Animation.easeOut(duration: 1).delay(1))
                        
                        ForEach(self.data.dataArray) { data in
                            Line(data: data,
                                 frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 46, height: reader.frame(in: .local).height)),
                                 touchLocation: self.$indicatorLocation,
                                 showIndicator: self.$hideHorizontalLines,
                                 minDataValue: .constant(getMergedDataForLegend().onlyPoints().min()),
                                 maxDataValue: .constant(getMergedDataForLegend().onlyPoints().max()),
                                 showBackground: false,
                                 gradient: getLineGradient(of: data)
                            )
                            .offset(x: 46, y: -20)
                            .onAppear(){
                                self.showLegend = true
                            }
                            .onDisappear(){
                                self.showLegend = false
                            }
                        }
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 240)
                    .offset(x: 0, y: 40)
                    
                    MagnifierRect(currentNumber1: self.$currentDataNumbers[0], currentNumber2: self.$currentDataNumbers[1], valueSpecifier: self.valueSpecifier)
                        .opacity(self.opacity)
                        .offset(x: self.dragLocation.x - geometry.frame(in: .local).size.width/2, y: 36)
                }
                .frame(width: geometry.frame(in: .local).size.width, height: 240)
                .gesture(DragGesture()
                .onChanged({ value in
                    self.dragLocation = value.location
                    self.indicatorLocation = CGPoint(x: max(value.location.x-46,0), y: 32)
                    self.opacity = 1
                    self.closestPoint = self.getClosestDataPoint(toPoint: value.location, width: geometry.frame(in: .local).size.width-46, height: 240)
                    self.hideHorizontalLines = true
                })
                    .onEnded({ value in
                        self.opacity = 0
                        self.hideHorizontalLines = false
                    })
                )
            }
        }
    }
    
    func getLineGradient(of data: ChartData) -> GradientColor {
        let allData = self.data.dataArray
        let index = allData.firstIndex { chartData -> Bool in
            chartData == data
        } ?? 0
        
        return self.data.gradient[index]
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points1 = self.data.dataArray[0].onlyPoints()
        let points2 = self.data.dataArray[1].onlyPoints()
        
        let stepWidth: CGFloat = width / CGFloat(points1.count-1)
        let stepHeight: CGFloat = height / CGFloat(points1.max()! + points1.min()!)
        
        let index:Int = Int(floor((toPoint.x-15)/stepWidth))
        if (index >= 0 && index < points1.count){
            self.currentDataNumbers = [points1[index], points2[index]]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points1[index])*stepHeight)
        }
        return .zero
    }
    
    func getMergedDataForLegend() -> ChartData {
        return ChartData(values: data.dataArray)
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineView(data: [[8,23,54,32,12,37,7,23,43]], title: "Full chart", style: Styles.lineChartStyleOne)
            
            LineView(data: [[282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.129, 284.188]], title: "Full chart", style: Styles.lineChartStyleOne)
            
        }
    }
}


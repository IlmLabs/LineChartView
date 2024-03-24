//
//  LineChartView.swift
//  ChartLineView Package
//
//  Created by Jonathan Gander
//

import SwiftUI

public struct LineChartView: View {
    public var lineChartParameters: LineChartParameters
    
    @State var showLabels = false
    @State var showingIndicators = false
    @State var indexPosition = Int()
    
    public init(lineChartParameters: LineChartParameters) {
        self.lineChartParameters = lineChartParameters
        setupPosition()
    }
    
    public var body: some View {
        if lineChartParameters.dataValues.count > 0 {
            VStack {
                if lineChartParameters.dragGesture {
                    ChartLabels(
                        lineChartParameters: lineChartParameters,
                        showingIndicators: $showingIndicators,
                        indexPosition: $indexPosition
                    )
                    .opacity(showLabels ? 1: 0)
                    .animation(.easeInOut, value: showLabels)
                }
                
                LineView(
                    lineChartParameters: lineChartParameters,
                    showingIndicators: $showingIndicators,
                    indexPosition: $indexPosition
                )
                .padding(.top, 10)
            }
            .padding()
            .onAppear(perform: setupPosition)
        }
    }
    
    private func setupPosition() {
        indexPosition = lineChartParameters.dataValues.count - 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showLabels = true
            }
        }
    }
}

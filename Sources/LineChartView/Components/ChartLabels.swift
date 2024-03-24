//
//  ChartLabels.swift
//  ChartLineView Package
//
//  Created by Jonathan Gander
//

import SwiftUI



public struct ChartLabels: View {
    
    public enum Alignment {
        case left, center, right
    }
    
    public var lineChartParameters: LineChartParameters
    
    @Binding var indexPosition: Int  // Data point position
    @Binding var showingIndicators: Bool
    
    private var labels: [String?] = []
    
    public init(lineChartParameters: LineChartParameters, showingIndicators: Binding<Bool>, indexPosition: Binding<Int>) {
        self.lineChartParameters = lineChartParameters
        self._showingIndicators = showingIndicators
        self._indexPosition = indexPosition
        
        labels = lineChartParameters.dataLabels
    }
    
    public var body: some View {
        HStack {
            if lineChartParameters.labelsAlignment == .right {
                Spacer()
            }
            
            VStack(alignment: lineChartParameters.labelsAlignment == .left ? .leading : lineChartParameters.labelsAlignment == .right ? .trailing : .center) {
                if let mainLabel = mainLabelValue() {
                    Text(mainLabel)
                        .foregroundColor(lineChartParameters.labelColor)
                        .font(.title)
                        .fontWeight(.bold)
                }

                
                if let secondaryLabel = secondaryLabelValue() {
                    Text(secondaryLabel)
                        .foregroundColor(lineChartParameters.secondaryLabelColor)
                        .font(.caption)
                }
            }
            if lineChartParameters.labelsAlignment == .left {
                Spacer()
            }
        }
    }
    
    // Returns main label according to DisplayMode
    private func mainLabelValue() -> String? {
        
        if lineChartParameters.displayMode == .default {
            if showingIndicators, lineChartParameters.dataValues.count > indexPosition {
                if #available(iOS 15.0, *), #available(macOS 12.0, *) { // Added macOS version too
                    return "\(lineChartParameters.dataPrefix ?? "")\(lineChartParameters.dataValues[indexPosition].formatted(.number.precision(.fractionLength(lineChartParameters.dataPrecisionLength))))\(lineChartParameters.dataSuffix ?? "")"
                } else {
                    return String(format: "%.2f", lineChartParameters.dataValues[indexPosition])
                }
            } else {
                if let lastData = lineChartParameters.dataValues.last, #available(iOS 15.0, *), #available(macOS 12.0, *) {
                    return "\(lineChartParameters.dataPrefix ?? "")\(lastData.formatted(.number.precision(.fractionLength(lineChartParameters.dataPrecisionLength))))\(lineChartParameters.dataSuffix ?? "")"
                }
            }
        } else if lineChartParameters.displayMode == .noValues {
            if labels.count > indexPosition {
                return labels[indexPosition]
            }
        }
        
        return nil
    }
    
    // Returns secondary label according to DisplayMode
    private func secondaryLabelValue() -> String? {
        if lineChartParameters.displayMode == .default {
            if showingIndicators, labels.count > indexPosition {
                return labels[indexPosition]
            } else {
                return labels.last ?? nil
            }
        } else if lineChartParameters.displayMode == .noValues {
            return nil
        }
        
        return nil
    }
}

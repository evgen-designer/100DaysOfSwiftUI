//
//  ContentView.swift
//  LengthConvertor
//
//  Created by Mac on 14/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnit = "m"
    @State private var outputUnit = "km"
    @State private var inputValue = 0.0
    
    let units = ["m", "km", "ft", "yd", "mi"]
    
    let conversionFactors = [
        "m": 1.0, "km": 1000.0, "ft": 0.3048, "yd": 0.9144, "mi": 1609.34
    ]
    
    var convertedValue: Double {
        let inputInMeters = (Double(inputValue)) * (conversionFactors[inputUnit] ?? 1)
        return inputInMeters / (conversionFactors[outputUnit] ?? 1)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Input value") {
                    TextField("Enter value", value: $inputValue, format: .number)
                }
                
                Section("Input unit") {
                    Picker("Input unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .pickerStyle(.segmented)
                
                Section("Output unit") {
                    Picker("Output unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .pickerStyle(.segmented)
                
                Section("Converted value") {
                    Text("\(convertedValue.formatted())")
                }
            }
            .navigationTitle("Length Convertor")
        }
    }
}

#Preview {
    ContentView()
}

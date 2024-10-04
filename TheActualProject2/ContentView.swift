//
//  ContentView.swift
//  TheActualProject2
//
//  Created by Student on 10/4/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var inputValue: Double = 0
    @State private var inputUnit: Dimension = UnitDuration.hours
    @State private var outputUnit: Dimension = UnitDuration.seconds
    @State private var selectedUnits = 2;
    @State private var inputFocused: Bool
    
    let types = ["temperature", "length", "time", "Volume"]
    var units: [[Dimension]] {
        let temperatureUnits: [UnitTemperature] = [.celsius, .fahrenheit, .kelvin]
        let timeUnits: [UnitDuration] = [.seconds, .minutes, .hours]
        let lengthUnits: [UnitLength] = [.millimeters, .meters, .kilometers, .inches, .feet, .yards]
        let volumeUnits: [UnitVolume] = [.milliliters, .liters, .cups, .pints, .gallons]
        return [
        temperatureUnits,
        lengthUnits,
        timeUnits,
        volumeUnits,
        ]
    }
    let formatter: MeasurementFormatter
    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .medium
    }
    var result: String {
        let outputMeasurement = Measurement(value: inputValue, unit: inputUnit).converted(to: outputUnit)
        return formatter.string(from: outputMeasurement)
    }
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("input", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputFocused)
                } header: {
                    Text("Convertion Amount")
                        .fontWeight(.bold)
                }
                Section {
                    unitPicker(title: "convert from", selection: $inputUnit)
                    unitPicker(title: "convert to", selection: $outputUnit)
                } header: {
                    Text("\(formatter.string(from: inputUnit)) to \(formatter.string(from: outputUnit))")
                        .fontWeight(.bold)
                }
                Picker("Conversion", selection: $selectedUnits) {
                    ForEach(0..<types.count, id: \.self) {
                        Text(types[$0])
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
            }
            .navigationTitle("convertion")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("yipeeee"){
                        inputFocused = false
                    }
                }
            }
            .onChange(of: selectedUnits) { newUnits in
                inputUnit = units[newUnits][0]
                outputUnit = units[newUnits][0]
            }
        }
    }
    private func unitPicker(title: String, selection: Binding<Dimension>) -> some View {
        Picker(title, selection: selection) {
            ForEach(units[selectedUnits], id: \.self){
                Text(formatter.string(from: $0).capitalized)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

//
//  EditVinylView.swift
//  Vinlylist
//
//  Created by Matteo Pidalà on 19/04/25.
//
import SwiftUI
import PhotosUI

struct EditVinylView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vinyl: Vinyl
    @State private var selectedItem: PhotosPickerItem?
    @State private var marketValueText = ""

    var validYear: Bool {
        if let yearInt = Int(vinyl.year), (1900...2099).contains(yearInt) {
            return true
        }
        return false
    }

    var validMarketValue: Bool {
        Double(marketValueText) != nil
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Cover Image")) {
                    PhotosPicker("Select New Image", selection: $selectedItem, matching: .images)

                    Image(uiImage: vinyl.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }

                Section(header: Text("Details")) {
                    TextField("Title", text: $vinyl.title)
                    TextField("Artist", text: $vinyl.artist)

                    TextField("Year", text: $vinyl.year)
                        .keyboardType(.numberPad)
                        .onChange(of: vinyl.year) { newValue in
                            vinyl.year = String(newValue.prefix(4).filter("0123456789".contains))
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(validYear ? Color.clear : Color.red, lineWidth: 1)
                        )

                    Stepper("Rating: \(vinyl.rating)", value: $vinyl.rating, in: 1...5)
                }

                Section(header: Text("Additional Info")) {
                    TextField("Label", text: $vinyl.label)

                    Picker("Condition", selection: $vinyl.condition) {
                        Text("Good").tag("Good")
                        Text("Very Good").tag("Very Good")
                        Text("Mint").tag("Mint")
                    }

                    TextField("Market Value (€)", text: $marketValueText)
                        .keyboardType(.decimalPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(validMarketValue ? Color.clear : Color.red, lineWidth: 1)
                        )
                        .onAppear {
                            marketValueText = String(format: "%.2f", vinyl.marketValue)
                        }
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $vinyl.notes)
                        .frame(height: 120)
                }

                Section {
                    Button(role: .destructive) {
                        NotificationCenter.default.post(name: .deleteVinyl, object: vinyl)
                        dismiss()
                    } label: {
                        Label("Delete Vinyl", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Edit Vinyl")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let value = Double(marketValueText) {
                            vinyl.marketValue = value
                        }
                        dismiss()
                    }
                    .disabled(!validYear || !validMarketValue)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        vinyl.image = uiImage
                    }
                }
            }
        }
    }
}

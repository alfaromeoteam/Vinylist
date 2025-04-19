//
//  AddVinylView.swift
//  Vinlylist
//
//  Created by Matteo Pidalà on 19/04/25.
//

import SwiftUI
import PhotosUI

struct AddVinylView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var vinyls: [Vinyl]

    @State private var title = ""
    @State private var artist = ""
    @State private var year = ""
    @State private var rating = 3
    @State private var label = ""
    @State private var condition = "Good"
    @State private var marketValueText = ""
    @State private var marketValue: Double = 0.0
    @State private var notes = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    var validYear: Bool {
        if let yearInt = Int(year), (1900...2099).contains(yearInt) {
            return true
        }
        return false
    }

    var validMarketValue: Bool {
        Double(marketValueText) != nil
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Cover Image")) {
                        PhotosPicker("Select Image", selection: $selectedItem, matching: .images)

                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        }
                    }

                    Section(header: Text("Details")) {
                        TextField("Title", text: $title)
                        TextField("Artist", text: $artist)

                        TextField("Year (e.g. 1985)", text: $year)
                            .keyboardType(.numberPad)
                            .onChange(of: year) { newValue in
                                year = String(newValue.prefix(4).filter("0123456789".contains))
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(validYear ? Color.clear : Color.red, lineWidth: 1)
                            )

                        Stepper("Rating: \(rating)", value: $rating, in: 1...5)
                    }

                    Section(header: Text("Additional Info")) {
                        TextField("Label", text: $label)

                        Picker("Condition", selection: $condition) {
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
                    }

                    Section(header: Text("Notes")) {
                        TextEditor(text: $notes)
                            .frame(height: 120)
                    }
                }

                Spacer()
            }
            .navigationTitle("New Vinyl")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let image = selectedImage {
                            marketValue = Double(marketValueText) ?? 0.0
                            let newVinyl = Vinyl(
                                title: title,
                                artist: artist,
                                year: year,
                                rating: rating,
                                image: image,
                                label: label,
                                condition: condition,
                                marketValue: marketValue,
                                notes: notes
                            )
                            vinyls.append(newVinyl)
                            dismiss()
                        }
                    }
                    .disabled(title.isEmpty || artist.isEmpty || selectedImage == nil || !validYear || !validMarketValue)
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
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
}

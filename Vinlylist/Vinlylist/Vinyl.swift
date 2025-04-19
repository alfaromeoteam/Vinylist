//
//  Vinyl.swift
//  Vinlylist
//
//  Created by Matteo Pidalà on 19/04/25.
//

import SwiftUI

class Vinyl: Identifiable, ObservableObject {
    let id = UUID()

    @Published var title: String
    @Published var artist: String
    @Published var year: String
    @Published var rating: Int
    @Published var image: UIImage

    @Published var label: String
    @Published var condition: String
    @Published var marketValue: Double
    @Published var notes: String

    init(
        title: String,
        artist: String,
        year: String,
        rating: Int,
        image: UIImage,
        label: String = "",
        condition: String = "Good",
        marketValue: Double = 0.0,
        notes: String = ""
    ) {
        self.title = title
        self.artist = artist
        self.year = year
        self.rating = rating
        self.image = image
        self.label = label
        self.condition = condition
        self.marketValue = marketValue
        self.notes = notes
    }
}

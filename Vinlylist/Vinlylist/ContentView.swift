//
//  ContentView.swift
//  Vinlylist
//
//  Created by Matteo Pidalà on 19/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var vinyls: [Vinyl] = []
    @State private var showAddVinyl = false
    @State private var searchText = ""
    @State private var sortByRating = false

    var filteredVinyls: [Vinyl] {
        let result = vinyls
            .filter {
                searchText.isEmpty ||
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.artist.localizedCaseInsensitiveContains(searchText)
            }

        return sortByRating ? result.sorted(by: { $0.rating > $1.rating }) : result
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                if vinyls.isEmpty {
                    VStack(spacing: 24) {
                        Image(systemName: "opticaldisc.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(radius: 8)

                        VStack(spacing: 6) {
                            Text("Welcome to Vinylist")
                                .font(.title2)
                                .foregroundColor(.white)

                            Text("Start building your vinyl collection.")
                                .font(.callout)
                                .foregroundColor(.gray)

                            Text("Tap the '+' button to add your first album.")
                                .font(.footnote)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(filteredVinyls) { vinyl in
                            NavigationLink(destination: EditVinylView(vinyl: vinyl)) {
                                HStack(spacing: 12) {
                                    Image(uiImage: vinyl.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(vinyl.title)
                                            .font(.body)
                                            .foregroundColor(.white)
                                        Text(vinyl.artist)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text(vinyl.year)
                                            .font(.caption)
                                            .foregroundColor(.gray.opacity(0.6))
                                    }

                                    Spacer()

                                    Text("⭐️ \(vinyl.rating)")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete { indexSet in
                            vinyls.remove(atOffsets: indexSet)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                    .searchable(text: $searchText, prompt: "Search by title or artist")
                }
            }
            .navigationTitle("Vinylist")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { sortByRating.toggle() }) {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .foregroundColor(sortByRating ? .yellow : .white)
                    }
                    Button(action: { showAddVinyl = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showAddVinyl) {
                AddVinylView(vinyls: $vinyls)
            }
        }
        .tint(.white)                         // ✅ Elementi UI bianchi
        .preferredColorScheme(.dark)          // ✅ Modalità scura forzata
        .onReceive(NotificationCenter.default.publisher(for: .deleteVinyl)) { notification in
            if let vinylToDelete = notification.object as? Vinyl {
                if let index = vinyls.firstIndex(where: { $0.id == vinylToDelete.id }) {
                    vinyls.remove(at: index)
                }
            }
        }
    }
}

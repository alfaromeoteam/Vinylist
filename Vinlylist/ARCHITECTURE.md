Vinylist - Project Architecture
This document outlines the architecture, view hierarchy, and file relationships within the Vi
---
Overview
Vinylist is a SwiftUI-based app for cataloging vinyl records.
It features:
- Album management (add/edit/delete)
- Image selection and barcode scanning
- Market value and condition tracking
- Advanced statistics with interactive charts
---
Application Entry Point
VinylistApp.swift
■■■ MainView.swift
■■■ LibraryView.swift
■■■ AddVinylView.swift
■■■ StatsView.swift
---
Main View Structure
MainView.swift
■■■ TabView with 3 tabs:
■ ■■■ LibraryView.swift
■ ■ ■■■ VinylRowView.swift
■ ■ ■■■ EditVinylView.swift
■ ■ ■■■ FilterSheet.swift (if used)
■ ■■■ AddVinylView.swift
■ ■ ■■■ BarcodeScannerView.swift (optional)
■ ■ ■■■ DiscogsService.swift (optional)
■ ■■■ StatsView.swift
■ ■■■ PieChartView.swift
■ ■ ■■■ PieSlice.swift
■ ■■■ LegendView.swift
---
Shared Model
Vinyl.swift
■■■ ObservableObject
■■■ Used in:
■ ■■■ LibraryView
■ ■■■ AddVinylView
■ ■■■ EditVinylView
■ ■■■ StatsView
---
Enums
MediaType.swift -> 33 RPM, CD, etc.
VinylCondition.swift -> Mint, VG+, etc.
ValueRange.swift -> Used in stats and filters
SortOption.swift -> Sorting in LibraryView
PieFilterOption.swift -> Condition / Value filters in Stats

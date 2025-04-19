# Changelog

## v0.1-final (2025-04-19)

### Added
- Barcode scanning using camera (AVFoundation)
- `barcode` field added to `Vinyl` model
- Discogs API integration (using user token)
- Autofill of fields from barcode: title, artist, year, label, media type, market value
- Discogs search available in both Add and Edit views
- Condition list with full official grading scale
- Pie chart view with toggle (condition/value-based)
- Value formatting in euro across all views
- Filtering by media type, condition, favorites
- Sorting by artist, title, year, and value
- Dark mode interface
- Stats view with overview counters and chart

### Fixed
- Live syncing of edits between views using @ObservedObject
- Consistent formatting for year (4 digits only)
- Validation on year and value fields (with red border if invalid)

### Internal
- Modular file structure
- Separated `NumberFormatter.currency` into dedicated file

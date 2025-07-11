# TODO

This file tracks upcoming improvements and provides an overview of the project structure.

## Road Map
- [ ] Implement unit tests and continuous integration for testing
- [ ] Add user authentication and secure data storage
- [ ] Improve the user interface and overall user experience
- [ ] Expand health record features (graphs, export options)
- [ ] Prepare for App Store release

## File Hierarchy (partial)
```
.
├── README.md
├── RELEASE.md
├── TODO.md
├── x-health/
│   ├── Assets.xcassets
│   ├── "Preview Content"/
│   ├── ContentView.swift
│   ├── ImagePicker.swift
│   ├── RecordController.swift
│   ├── x_healthApp.swift
│   ├── data.swift
│   └── Views/
│       ├── AddUpdateRecordView.swift
│       ├── BodyPartsView.swift
│       ├── CompareRecordsView.swift
│       ├── DoctorsView.swift
│       ├── HistoryDetailView.swift
│       ├── HomeView.swift
│       ├── gallary.swift
│       └── ...
├── x-health.xcodeproj/
│   └── ... (Xcode project files)
└── .github/
    └── workflows/
        └── ios-build.yml
```

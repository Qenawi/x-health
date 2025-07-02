// Views/AddUpdateRecordView.swift
import SwiftUI
import SwiftData

struct AddUpdateRecordView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext

    @State private var recordType: RecordType = .doctorVisit
    @State private var date = Date()
    @State private var notes = ""
    @State private var attachedFiles: [String] = []
    
    // Medicine fields
    @State private var medicine: String = ""
    @State private var medicineStartDate: Date = Date()
    @State private var medicineEndDate: Date = Date()
    
    // For multi-image selection.
    @State private var showImagePicker = false
    @State private var selectedImages: [UIImage] = []
    
    // Query available doctors and tags.
    @Query(sort: \Doctor.name, order: .forward) var availableDoctors: [Doctor]
    @Query(sort: \Tag.name, order: .forward) var availableTags: [Tag]
    
    @State private var selectedDoctor: Doctor? = nil
    @State private var selectedTag: Tag? = nil
    
    // Multiple selection for body parts.
    let possibleBodyParts = ["Left Knee", "Right Knee", "Left Shoulder", "Right Shoulder", "Lower Back", "Neck", "Left Elbow", "Right Elbow"]
    @State private var selectedBodyParts: Set<String> = []
    
    // Grid columns.
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Color.xHealthBackground.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Add/Update Record")
                        .font(.largeTitle)
                        .foregroundColor(.xHealthPrimaryText)
                        .padding(.top)
                    
                    // Record type picker.
                    Picker("Record Type", selection: $recordType) {
                        ForEach(RecordType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Date picker.
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .foregroundColor(.xHealthPrimaryText)
                        .padding(.horizontal)
                    
                    // Doctor picker.
                    if availableDoctors.isEmpty {
                        Text("No doctor available. Please add one from Home.")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    } else {
                        Picker("Select Doctor", selection: $selectedDoctor) {
                            ForEach(availableDoctors, id: \.self) { doctor in
                                Text(doctor.name).tag(Optional(doctor))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                    }
                    
                    // Tag picker.
                    if availableTags.isEmpty {
                        Text("No tag available. Please add one from Home.")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    } else {
                        Picker("Select Tag", selection: $selectedTag) {
                            ForEach(availableTags, id: \.self) { tag in
                                // Show tag name with its color applied to the text.
                                Text(tag.name)
                                    .foregroundColor(Color(hex: tag.colorHex) ?? .xHealthPrimaryText)
                                    .tag(Optional(tag))
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                    }
                    
                    // Body parts multiple selection.
                    Text("Select Body Parts:")
                        .foregroundColor(.xHealthPrimaryText)
                        .padding(.horizontal)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(possibleBodyParts, id: \.self) { part in
                            Button(action: {
                                withAnimation {
                                    if selectedBodyParts.contains(part) {
                                        selectedBodyParts.remove(part)
                                    } else {
                                        selectedBodyParts.insert(part)
                                    }
                                }
                            }) {
                                Text(part)
                                    .foregroundColor(selectedBodyParts.contains(part) ? .white : .xHealthPrimaryText)
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedBodyParts.contains(part) ? Color.xHealthAccent : Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Medicine section.
                    Group {
                        Text("Medicine")
                            .foregroundColor(.xHealthPrimaryText)
                            .padding(.horizontal)
                        TextField("Enter medicine details", text: $medicine)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        HStack {
                            DatePicker("Start Date", selection: $medicineStartDate, displayedComponents: .date)
                            DatePicker("End Date", selection: $medicineEndDate, displayedComponents: .date)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Multiline description.
                    Text("Description:")
                        .foregroundColor(.xHealthPrimaryText)
                        .padding(.horizontal)
                    TextEditor(text: $notes)
                        .frame(height: 150)
                        .padding(4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.xHealthPrimaryText)
                        .padding(.horizontal)
                    
                    // Attached images preview using AsyncImage.
                    if !attachedFiles.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(attachedFiles, id: \.self) { file in
                                    if let fileURL = getDocumentsDirectory()?.appendingPathComponent(file) {
                                        AsyncImage(url: fileURL) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 100, height: 100)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 100, height: 100)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            case .failure:
                                                Text("Error")
                                                    .foregroundColor(.xHealthPrimaryText)
                                                    .frame(width: 100, height: 100)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Button to add images.
                    Button(action: { showImagePicker = true }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Add Images")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.xHealthAccent)
                        .foregroundColor(.xHealthPrimaryText)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showImagePicker, onDismiss: addSelectedImages) {
                        MultiImagePicker(selectedImages: $selectedImages)
                    }
                    
                    // Button to save the record.
                    Button(action: saveRecord) {
                        Text("Save Record")
                            .font(.headline)
                            .foregroundColor(.xHealthPrimaryText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.xHealthAccent)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .onAppear {
                // Set default selections if available.
                if selectedDoctor == nil, let first = availableDoctors.first {
                    selectedDoctor = first
                }
                if selectedTag == nil, let first = availableTags.first {
                    selectedTag = first
                }
            }
        }
    }
    
    /// Returns the Documents directory URL.
    private func getDocumentsDirectory() -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    /// Processes selected images from the multi-image picker.
    private func addSelectedImages() {
        for image in selectedImages {
            if let fileName = saveImage(image) {
                attachedFiles.append(fileName)
            }
        }
        selectedImages = []
    }
    
    /// Saves a UIImage as JPEG and returns the generated file name.
    private func saveImage(_ image: UIImage) -> String? {
        if let data = image.jpegData(compressionQuality: 0.8),
           let dir = getDocumentsDirectory() {
            let fileName = UUID().uuidString + ".jpg"
            let url = dir.appendingPathComponent(fileName)
            do {
                try data.write(to: url)
                return fileName
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
    }
    
    private func saveRecord() {
        let newRecord = MedicalRecord(
            type: recordType,
            date: date,
            notes: notes,
            attachedFiles: attachedFiles,
            doctor: selectedDoctor,
            tag: selectedTag,
            bodyParts: Array(selectedBodyParts),
            medicine: medicine,
            medicineStartDate: medicineStartDate,
            medicineEndDate: medicineEndDate
        )
        modelContext.insert(newRecord)
        try? modelContext.save()
        print("Saved Record: \(newRecord)")
        // Reset fields.
        recordType = .doctorVisit
        date = Date()
        notes = ""
        attachedFiles = []
        selectedBodyParts = []
        medicine = ""
        medicineStartDate = Date()
        medicineEndDate = Date()
        if let first = availableDoctors.first {
            selectedDoctor = first
        }
        if let first = availableTags.first {
            selectedTag = first
        }
    }
}

struct AddUpdateRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddUpdateRecordView()
        }
        .preferredColorScheme(.dark)
    }
}

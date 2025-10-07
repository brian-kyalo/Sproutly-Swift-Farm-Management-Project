import SwiftUI
import PhotosUI
import FirebaseAuth

struct AddProjectView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var title = ""
    @State private var branch: ProjectBranch?
    @State private var category: Category?
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details").font(.headline)) {
                    TextField("Project Title", text: $title)
                        .padding(.vertical, 8)
                    Picker("Branch", selection: $branch) {
                        Text("Select Branch").tag(Optional<ProjectBranch>.none)
                        ForEach(ProjectBranch.allCases, id: \.self) { branch in
                            Text(branch.rawValue.capitalized).tag(Optional(branch))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical, 8)
                    Picker("Category", selection: $category) {
                        Text("Select Category").tag(Optional<Category>.none)
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(Optional(category))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical, 8)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .padding(.vertical, 8)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("Project Image").font(.headline)) {
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        Text("Select Image")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                            .padding(.vertical, 8)
                    }
                    Button(action: {
                        Task {
                            do {
                                guard let branch = branch, let category = category,
                                      let userId = Auth.auth().currentUser?.uid else {
                                    print("Missing required fields or user not authenticated")
                                    return
                                }
                                print("Save tapped: title=\(title), branch=\(String(describing: branch)), category=\(String(describing: category))")
                                let project = Project(
                                    id: UUID().uuidString,
                                    title: title,
                                    branch: branch,
                                    category: category,
                                    startDate: startDate,
                                    endDate: endDate,
                                    imageUrl: nil,
                                    userId: userId
                                )
                                try await viewModel.addProject(project: project, imageData: imageData)
                                dismiss()
                            } catch {
                                print("Error adding project: \(error)")
                            }
                        }
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(title.isEmpty || branch == nil || category == nil ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(title.isEmpty || branch == nil || category == nil)
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Add Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onChange(of: selectedImage) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    imageData = data
                                    print("Image selected: Data loaded")
                                }
                            }
                        }
           
                }
            }
        }
    

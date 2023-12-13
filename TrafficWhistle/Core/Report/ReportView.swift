import SwiftUI
import MapKit
import PhotosUI

struct ReportView: View {
    @State private var selectedType: String? = nil
    @StateObject var locationManager: LocationManager = .init()
    //Mark: navigation tag to push view to mapview
    @State var navigationTag: String?
    
    
    let incidentTypes = [
        (imageName: "speeding", label: "Speeding"),
        (imageName: "runningRedLights", label: "Running Red Lights/Stop Signs"),
        (imageName: "distractedDriving", label: "Distracted Driving"),
        (imageName: "dui", label: "Driving Under the Influence (DUI)"),
        (imageName: "parking", label: "Illegal Parking")
    ]
    
    var body: some View {
        NavigationView {
                   VStack(spacing: 30) {
                       Text("Select type of incident.")
                           .font(.system(size: 23, weight: .bold))
                           .foregroundColor(.orange)
                           .padding(.top, 30)
                       
                       VStack(spacing: 15) {
                           ForEach(incidentTypes, id: \.label) { type in
                               NavigationLink(
                                   destination: MapViewSelection(selectedType: type.label).environmentObject(locationManager),
                                   tag: type.label,
                                   selection: $selectedType
                               ) {
                                   IncidentTypeButton(
                                       imageName: type.imageName,
                                       label: type.label,
                                       isSelected: selectedType == type.label
                                   )
                               }
                               .simultaneousGesture(TapGesture().onEnded {
                                   selectedType = type.label
                                   if let coordinate = locationManager.userLocation?.coordinate{
                                       locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                       locationManager.addDraggablePin(coordinate: coordinate )
                                       locationManager.updatePlaceMark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                       
                                       print("HI")
                                   }
                                   //navigate to map view
                                   navigationTag = "MAPVIEW"
                                   
                               })
                           }
                       }
                       .padding(.horizontal, 20)
                       .padding(.bottom, 130)
                   }
                   .padding(.top, -100)
               }
           }
       }

struct IncidentTypeButton: View {
    let imageName: String
    let label: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            
            Text(label)
                .foregroundColor(.orange)
            
            Spacer()
        }
        
        .padding()
        .cornerRadius(10)
        .frame( width: 350, height: 70)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 1)
                .background(isSelected ? Color.orange.opacity(0.1) : Color.clear )
        )
    }
}



struct MapViewSelection: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var viewModel = IncidentViewModel()
    @State private var extraInfo = ""
    @State private var imagePickerPresented = false
    @State private var showAlert = false
    @State private var isAnonymous = false
    @Environment(\.presentationMode) var presentationMode
    
    var selectedType: String
    
    // Computed property to check if all fields are filled
    var allFieldsFilled: Bool {
        return viewModel.incidentImage != nil && !extraInfo.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 20) {
            MapViewHelper()
                .environmentObject(locationManager)
                .frame(width: 450, height: 260)
            
            VStack {
                HStack{
                    Button(action: {
                        imagePickerPresented.toggle()
                    }) {
                        Label("Select Image", systemImage: "photo")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    if let image = viewModel.incidentImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    }
                }
                
                TextField("Enter extra info.", text: $extraInfo, axis: .vertical)
                                    .padding(10)
                                    .frame(height: 80) // Reduced height for the text field
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                
                                HStack {
                                    Toggle("Submit as anonymous", isOn: $isAnonymous) // Toggle for anonymity
                                        .padding(.trailing)
                                }
                            }
            
            
            
            VStack(spacing: 15) {
                if let place = locationManager.pickedPlaceMark {
                    Text("You encountered:")
                        .font(.title3.bold())
                    Text(selectedType)
                        .font(.title2.bold())
                        .foregroundColor(.orange)
                    Text("In this location:")
                        .font(.title3.bold())
                    
                    HStack(spacing: 15) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(place.name ?? "")
                                .font(.title3.bold())
                            Text(place.locality ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // this is to show the "Submit" button only if all fields are filled
                if allFieldsFilled {
                    Button(action: {Task{
                        let locationString = getLocationString(from: locationManager.pickedPlaceMark)
                        try await viewModel.uploadReport(type: selectedType, location: locationString , info: extraInfo, isAnonymous: isAnonymous)
                        showAlert = true
                    }}) {
                        Text("Submit Incident")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                            .foregroundColor(.white)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("Incident report submitted successfully."),
                            dismissButton: .default(Text("OK")) {
                                // Dismiss the sheet
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
                }
            }
            .padding()
        }
        .padding()
        .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
        .onDisappear {
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
    
    func getLocationString(from placemark: CLPlacemark?) -> String {
        guard let placemark = placemark else { return "" }
        var locationString = ""
        
        // Extract relevant information from placemark
        if let name = placemark.name {
            locationString += "\(name), "
        }
        if let locality = placemark.locality {
            locationString += "\(locality), "
        }
        

        if locationString.hasSuffix(", ") {
            locationString = String(locationString.dropLast(2))
        }
        
        return locationString
    }
}





    



// map view ui kit
struct MapViewHelper: UIViewRepresentable{
    @EnvironmentObject var locationManager: LocationManager

    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
}


//// Preview code
//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//    }
//}

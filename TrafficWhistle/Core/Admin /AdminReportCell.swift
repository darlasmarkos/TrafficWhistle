import SwiftUI
import Kingfisher

struct AdminReportCell: View {
    let report: ReportedIncident
    @State private var isFullScreen = false // Track fullscreen state

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main Featured Image - Upper Half of Card
            KFImage(URL(string: report.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 300)
                .clipped()
                .overlay(
                    Text(report.type)
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.5)),
                    alignment: .topLeading
                )
            
            // Stack bottom half of card
            VStack(alignment: .leading, spacing: 6) {
                if report.isAnonymous == true {
                    Text("Anonymous User")
                        .fontWeight(.heavy)
                } else {
                    Text(report.user?.fullname ?? "Unknown User")
                        .fontWeight(.heavy)
                }

                // 'Based on:' Horizontal Category Stack
                HStack(alignment: .center, spacing: 6) {
                    Text("In this Location:")
                        .font(.system(size: 13))
                        .fontWeight(.heavy)
                    HStack {
                        Button(action: {
                            openMap(Address: report.location)
                        }) {
                            Text(report.location)
                                .font(.custom("HelveticaNeue-Medium", size: 12))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .foregroundColor(.white)
                        }
                    }
                    .background(Color(red: 43/255, green: 175/255, blue: 187/255))
                    .cornerRadius(7)
                    Spacer()
                }
                Text(report.info)
                    .font(.custom("HelveticaNeue-Bold", size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            
            HStack(alignment: .center, spacing: 4) {
                Text(report.timestamp.dateValue().description)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(red: 231/255, green: 119/255, blue: 112/255))
            }
            .padding(.vertical, 8)
        }
        .frame(width: 350)
        .padding(12)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
    }

    func openMap(Address: String) {
        if let encodedAddress = Address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: "http://maps.apple.com/?address=\(encodedAddress)") {
                UIApplication.shared.open(url)
            }
        }
    }
}

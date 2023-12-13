import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isShowingReportTypes = false
    var body: some View {
        // Check if user is logged in
        if let user = viewModel.currentUser {
            NavigationStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome,")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .opacity(0.4)
                        
                        Text(user.fullname)
                            .font(.system(size: 25))
                            .fontWeight(.heavy)
                            .foregroundColor(.black.opacity(0.8))
                    }
                    Spacer()
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .accentColor(.black.opacity(0.8))
                    }
                    .accentColor(.orange)
                }
                .padding(.top, 80)
                .padding(.horizontal, 30)
                .frame(height: 200)
                            .background(Color.orange)
                            .mask(CustomShape(radius: 50))
                            .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 5)
                            .edgesIgnoringSafeArea(.top)
                            .background(Color.white)
                
               //
               //
                ZStack {
                    Image("traffic")
                                    .resizable()
                                    .scaledToFill()
                                    .edgesIgnoringSafeArea(.all)
                    
                
                    // Middle Button
                    VStack {
                        Button {
                            isShowingReportTypes.toggle()
                        } label: {
                            Image("bing")
                                .sheet(isPresented: $isShowingReportTypes , content: {
                                    ReportView()
                                        .presentationDetents([.large])
                                        .presentationDragIndicator(.visible)
                                        // .presentationBackground(.black)
                                        .presentationCornerRadius(20)
                                })
                            
                                .frame(width: 255, height: 255)
                                                .foregroundColor(Color.black)
                                                .background(Color.orange)
                                                .clipShape(Circle())
                                    .padding(.top, 70) // Adjusting top padding to move the button
                        }
                        Spacer()
                        Text("Tap above to report incident.")
                            .padding(.bottom, 300 )
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundColor(.orange)
                           // .opacity(0.5)
                     
                    }
                    
         
                }

                //.padding(.top, 40)
            }
            .containerRelativeFrame([.horizontal, .vertical])
        }
        
    }
}
struct CustomShape: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let tl = CGPoint(x: rect.minX, y: rect.minY)
        let tr = CGPoint(x: rect.maxX, y: rect.minY)
        let brs = CGPoint(x: rect.maxX, y: rect.maxY - radius)
        let brc = CGPoint(x: rect.maxX - radius, y: rect.maxY - radius)
        let bls = CGPoint(x: rect.minX + radius, y: rect.maxY)
        let blc = CGPoint(x: rect.minX + radius, y: rect.maxY - radius)
        
        path.move(to: tl)
        path.addLine(to: tr)
        path.addLine(to: brs)
        path.addRelativeArc(center: brc, radius: radius,
          startAngle: Angle.degrees(0), delta: Angle.degrees(90))
        path.addLine(to: bls)
        path.addRelativeArc(center: blc, radius: radius,
          startAngle: Angle.degrees(90), delta: Angle.degrees(90))
        
        return path
    }
}
// Preview code
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        
    }
}

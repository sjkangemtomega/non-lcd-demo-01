
import SwiftUI

struct SignInView : View {
    @StateObject var appState: AppState
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .cornerRadius(20)
                .frame(width: 60, height: 60)
                .clipped()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(appState.isSignedIn ? .blue:.gray)
                .padding()
            
            VStack(alignment: .leading) {
                Text(appState.isSignedIn ? "Sign Out":"Sign In or Sign Up")
                    .foregroundColor(appState.isSignedIn ? .gray:.blue)
                    .font(.system(size: 18))
                    .lineLimit(nil)
                Text(appState.isSignedIn ? "":"Please Sign In to use more services")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .lineLimit(nil)
            }
            .onTapGesture {
                SystemUtil.delay(1.5) {
                    appState.isSignedIn = true
                }
            }
        }
    }
}

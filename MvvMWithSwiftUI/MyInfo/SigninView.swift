
import SwiftUI

struct SignInView : View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .cornerRadius(20)
                .frame(width: 60, height: 60)
                .clipped()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .padding()
            
            VStack(alignment: .leading) {
                Text("Sign In or Sign Up")
                    .foregroundColor(.blue)
                    .font(.system(size: 18))
                    .lineLimit(nil)
                Text("Please Sign In to use more services")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .lineLimit(nil)
            }
        }
    }
}

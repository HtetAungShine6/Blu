import SwiftUI

fileprivate struct OnboardingData: Identifiable {
  let id = UUID()
  let heading: String
  let description: String
  let imageName: String
}

struct OnboardingView: View {
  
  @State private var currentIndex: Int = 0
  @State private var onboardingPages: [OnboardingData] = [
    OnboardingData(heading: "Explore Upcoming and Nearby Events", description: "This is the quality event app where you can explore aunty events around you", imageName: "Onboarding_1stPage"),
    OnboardingData(heading: "Explore Upcoming and Nearby Events", description: "This is the quality event app where you can explore aunty events around you", imageName:  "Onboarding_2ndPage"),
    OnboardingData(heading: "Explore Upcoming and Nearby Events", description: "This is the quality event app where you can explore aunty events around you",imageName: "Onboarding_3rdPage")
  ]
  @State private var bubbles: [Bubble] = []
  
  
  var body: some View {
    ZStack(alignment: .top) {
      appSnapshotImage
      VStack(alignment: .center) {
        Spacer()
        container
          .overlay {
            animatingBubbles
            VStack(alignment: .center,spacing: .spacer11) {
              onboardingContent
              pageControlButtons
            }
            .frame(maxWidth: 300)
          }
      }
      .zIndex(2)
    }
    .ignoresSafeArea(edges: [.bottom])
    .onAppear {
      animateBubbles()
    }
  }
}


extension OnboardingView {
  private var appSnapshotImage: some View {
    Image(onboardingPages[currentIndex].imageName)
      .resizable()
      .frame(width: 300,height: 540)
      .scaledToFit()
      .clipped()
      .zIndex(1)
      .padding(.top,.spacer11)
      .overlay(alignment:.bottom) {
        LinearGradient(
          gradient: Gradient(colors: [Color.clear, Color.white]),
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(width:400)
        .frame(height: 150)
        .blur(radius: .radius4)
        .padding(.bottom,.spacer11)
      }
  }
  
  private var container: some View {
    UnevenRoundedRectangle(topLeadingRadius: .radius6,topTrailingRadius: .radius6)
      .foregroundStyle(AppTheme.AppColor.accentColor)
      .frame(height: 300)
      .frame(maxWidth: .infinity,alignment: .bottom)
  }
  
  private var animatingBubbles: some View {
    ForEach(bubbles) { bubble in
      Circle()
        .fill(Color.white.opacity(0.15))
        .frame(width: bubble.size, height: bubble.size)
        .offset(x: bubble.x, y: bubble.y)
        .animation(
          Animation.easeInOut(duration: 1)
            .repeatForever(autoreverses: true)
            .delay(Double.random(in: 0...1)),
          value: bubble.y
        )
      
    }
  }
  
  private var onboardingContent: some View {
    VStack(alignment: .center,spacing: .spacer7) {
      Label(onboardingPages[currentIndex].heading)
        .font(.h2)
        .color(AppTheme.AppColor.TextColor.white)
        .alignment(.center)
        .maxLines(nil)
        .frame(height: 80)
      Label(onboardingPages[currentIndex].description)
        .font(.body2)
        .color(AppTheme.AppColor.TextColor.white)
        .alignment(.center)
        .maxLines(nil)
        .lineSpacing(4)
        .frame(height: 40)
    }
    .frame(height: 130)
  }
  
  private var pageControlButtons: some View {
    HStack {
      AppButton(config: ButtonConfig(title: "Prev", type: .tertiary, fontSize: .button1, action: {
        if (currentIndex != 0){
          withAnimation(.default) {
            currentIndex -= 1
          }
        }
      }))
      .opacity(currentIndex == 0 ? 0.5 : 1)
      .disabled(currentIndex == 0)
      Spacer()
      
      HStack(spacing: .spacer2) {
        ForEach(onboardingPages.indices,id: \.self){ index in
          Circle()
            .frame(width: 6,height: 6)
            .foregroundStyle(index == currentIndex ? Color.white : Color.white.opacity(0.35))
        }
      }
      
      Spacer()
      AppButton(config: ButtonConfig(title: "Next", type: .tertiary, fontSize: .body1, action: {
        if (currentIndex < onboardingPages.count - 1){
          withAnimation(.default) {
            currentIndex += 1
          }
        }
      }))
    }
    .padding(.top,.spacer16)
  }
  
  private func animateBubbles(){
    bubbles = (0..<8).map { _ in
      Bubble(
        x: CGFloat.random(in: -160...160),
        y: CGFloat.random(in: -40...40),
        size: CGFloat.random(in: 20...60),
        animationOffset: CGFloat.random(in: -30...30)
      )
    }
    
    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
      for i in bubbles.indices {
        bubbles[i].y += bubbles[i].animationOffset
      }
    }
  }
}

#Preview {
  OnboardingView()
}

fileprivate struct Bubble: Identifiable {
  let id = UUID()
  var x: CGFloat
  var y: CGFloat
  var size: CGFloat
  var animationOffset: CGFloat
}



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
    OnboardingData(
      heading: "Discover Amazing Events Near You",
      description: "Find concerts, festivals, workshops and networking events happening in your city",
      imageName: "Onboarding_1stPage"
    ),
    OnboardingData(
      heading: "Never Miss Your Favorite Events",
      description: "Get personalized recommendations and instant notifications for events you'll love",
      imageName: "Onboarding_2ndPage"
    ),
    OnboardingData(
      heading: "Connect with Like-Minded People",
      description: "Meet new friends and build meaningful connections at events that match your interests",
      imageName: "Onboarding_3rdPage"
    )
  ]
  
  @State private var bubbles: [Bubble] = []
  @State private var moveLeftNext: Bool = true
  @State private var bubbleTimer: Timer?
  
  private let containerWidth: CGFloat = UIScreen.main.bounds.width
  private let containerHeight: CGFloat = UIScreen.main.bounds.height / 3
  
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
    .onDisappear {
      stopBubbleMovement()
    }
  }
}

//MARK: UI Components
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
      .frame(width: containerWidth,height: containerHeight)
      .frame(maxWidth: .infinity,alignment: .bottom)
  }
  
  private var animatingBubbles: some View {
    ForEach(bubbles) { bubble in
      Circle()
        .fill(bubble.color)
        .frame(width: bubble.size, height: bubble.size)
        .offset(x: bubble.x, y: bubble.y)
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
      AppButton(config: ButtonConfig(
        type: .link,
        title: "Prev",
        fontStyle: .body1,
        action: {
          if (currentIndex != 0){
            HapticPlayer.play(.medium)
            shiftBubbles()
            withAnimation(.snappy) {
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
      
      AppButton(config: ButtonConfig(
        type: .link,
        title: "Next",
        fontStyle: .body1,
        action: {
          if (currentIndex < onboardingPages.count - 1){
            HapticPlayer.play(.medium)
            shiftBubbles()
            withAnimation(.snappy) {
              currentIndex += 1
            }
          }
      }))
    }
    .padding(.top,.spacer16)
  }
}

#Preview {
  OnboardingView()
}


// MARK: Bubbles Animation
fileprivate struct Bubble: Identifiable {
  let id = UUID()
  let color: Color
  var x: CGFloat
  var y: CGFloat
  var size: CGFloat
  var velocityX: CGFloat  // horizontal velocity
  var velocityY: CGFloat  // vertical velocity
}

extension OnboardingView {
  
  private var bubbleColors: [Color] {
    return [
      Color(red: 0.9921568627, green: 0.7725490196, blue: 0.9607843137).opacity(0.45),
      Color(red: 0.968627451, green: 0.6823529412, blue: 0.9725490196).opacity(0.45),
      Color(red: 0.7019607843, green: 0.5333333333, blue: 0.9215686275).opacity(0.45),
      Color(red: 0.5019607843, green: 0.5764705882, blue: 0.9450980392).opacity(0.45),
      Color(red: 0.4470588235, green: 0.8666666667, blue: 0.968627451).opacity(0.45)
    ]
  }
  
  private func animateBubbles() {
    bubbles = (0..<8).map { _ in
      Bubble(
        color: bubbleColors.randomElement() ?? .white.opacity(0.5),
        x: CGFloat.random(in: -containerWidth/2...containerWidth/2),
        y: CGFloat.random(in: -containerHeight/2...containerHeight/2),
        size: CGFloat.random(in: 10...100),
        velocityX: CGFloat.random(in: -0.8...0.8), // increased velocity
        velocityY: CGFloat.random(in: -0.8...0.8)  // increased velocity
      )
    }
    
    startBubbleMovement()
  }
  
  private func startBubbleMovement() {
    bubbleTimer?.invalidate()
    bubbleTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
      updateBubblePositions()
    }
  }
  
  private func updateBubblePositions() {
    for i in bubbles.indices {
      var bubble = bubbles[i]
      let radius = bubble.size / 2
      
      // Calculate bounds with radius compensation
      let leftBound = -containerWidth/2 + radius
      let rightBound = containerWidth/2 - radius
      let topBound = -containerHeight/2 + radius
      let bottomBound = containerHeight/2 - radius
      
      // Update position
      bubble.x += bubble.velocityX
      bubble.y += bubble.velocityY
      
      // Bounce off boundaries with radius compensation
      if bubble.x <= leftBound || bubble.x >= rightBound {
        bubble.velocityX *= -1 // reverse horizontal direction
        bubble.x = max(leftBound, min(rightBound, bubble.x)) // keep in bounds
      }
      
      if bubble.y <= topBound || bubble.y >= bottomBound {
        bubble.velocityY *= -1 // reverse vertical direction
        bubble.y = max(topBound, min(bottomBound, bubble.y)) // keep in bounds
      }
      
      bubbles[i] = bubble
    }
  }
  
  private func shiftBubbles() {
    withAnimation(.easeOut(duration: 0.8).speed(1.5)) {
      for i in bubbles.indices {
        let disperseX = CGFloat.random(in: -80...80)
        let disperseY = CGFloat.random(in: -80...80)
        
        bubbles[i].x += disperseX
        bubbles[i].y += disperseY
        
        // randomize velocities for new movement patterns
        bubbles[i].velocityX = CGFloat.random(in: -1...1)
        bubbles[i].velocityY = CGFloat.random(in: -1...1)
      }
    }
    
    moveLeftNext.toggle()
  }
  
  private func stopBubbleMovement() {
    bubbleTimer?.invalidate()
    bubbleTimer = nil
  }
}

import SwiftUI
import Navio

struct HomeView<ViewModel: HomeViewModel>: View {
    
    let navigator: HomeNavigator
    let tab: TabNavigator
    @StateObject private var viewModel: ViewModel
    
    init(
        viewModel: @autoclosure @escaping () -> ViewModel,
        navigator: HomeNavigator,
        tab: TabNavigator
    ){
        _viewModel = StateObject(wrappedValue: viewModel())
        self.navigator = navigator
        self.tab = tab
    }
    
    var body: some View {
        VStack {
            Text("Hello KOKO MGMG KO Shine:")
            
            Button("Go to Home Detail") {
                navigator.push(.homeDetail)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.signOut(.google)
                } label: {
                    Image(systemName: "door.left.hand.open")
                }
            }
        }
    }
}

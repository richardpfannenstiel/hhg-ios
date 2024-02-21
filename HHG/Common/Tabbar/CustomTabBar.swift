//
//  CustomTab.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 15.08.21.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selectedTab: String
    // Animation Namespace for sliding effect...
    @Namespace var animation
    
    var body: some View {
        HStack {
            TabBarButton(animation: animation, image: Image(systemName: "house.fill"), selectedTab: $selectedTab)
            TabBarButton(animation: animation, image: Image(systemName: "tray"), selectedTab: $selectedTab)
            TabBarButton(animation: animation, image: Image(systemName: "person.2.fill"), selectedTab: $selectedTab)
            TabBarButton(animation: animation, image: Image(systemName: "calendar"), selectedTab: $selectedTab)
        }
        .padding(.top)
        .padding(.vertical,-10)
        .padding(.bottom, getSafeArea().bottom == 0 ? 15 : getSafeArea().bottom)
        .background(Color.white)
    }
}

struct TabBarButton: View {
    
    var animation: Namespace.ID
    var image: Image
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: { withAnimation(.spring()) { selectedTab = getTabItem(image) } }, label: {
                VStack(spacing: 8) {
                    image
                        .resizable()
                        // Since its asset image....
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28)
                        .foregroundColor(selectedTab == getTabItem(image) ? Color.HHG_Blue : Color.gray.opacity(0.5))
                    if selectedTab == getTabItem(image) {
                        Circle()
                            .fill(Color.HHG_Blue)
                            .matchedGeometryEffect(id: "TAB", in: animation) .frame(width: 8, height: 8)
                    }
                }
                .frame(maxWidth: .infinity)
        })
    }
    
    private func getTabItem(_ image: Image) -> String {
        switch image {
        case Image(systemName: "house.fill"):
            return "home"
        case Image(systemName: "tray"):
            return "office"
        case Image(systemName: "person.2.fill"):
            return "residents"
        case Image(systemName: "calendar"):
            return "calendar"
        default:
            return "home"
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant("home"))
    }
}

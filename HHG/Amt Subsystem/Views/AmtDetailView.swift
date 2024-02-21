//
//  AmtDetailView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 22.07.22.
//

import SwiftUI

struct AmtDetailView: View {
    
    @Binding var showing: Bool
    @State var showingMember = false
    @State var selectedMember: Resident?
    
    let amt: Amt
    let previewBubbleLimit = 6
    
    var members: [Resident] {
        ResidentStore.shared.residents.filter( { $0.amts.contains(amt) })
    }
    
    var membersCount: Int {
        members.count > previewBubbleLimit ? previewBubbleLimit - 1 : members.count
    }
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            amt.image
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
            Text(amt.rawValue)
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
            if members.count > 0 {
                Text("If you are interested in taking over the office in an upcoming semester, feel free to contact the person(s) currently in charge.".localized)
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                memberView
                Spacer()
            }
            if !amt.description.isEmpty {
                HStack {
                    Text("Tasks:".localized)
                        .font(Font.system(size: 20, weight: .semibold, design: .rounded))
                        .kerning(0.25)
                }.padding(.horizontal)
                .padding(.bottom, 5)
                Text(amt.description)
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                    .kerning(0.25)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            Spacer()
        }.background(backgroundView)
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: { showing = false }) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var memberView: some View {
        HStack {
            ForEach(0..<membersCount, id: \.self) { index in
                Button(action: { show(members[index]) }) {
                    Circle()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.gray)
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
                        .overlay(Text("\(String(members[index].givenName.first!))\(String(members[index].familyName.first!))")
                                    .font(Font.system(size: 30, weight: .bold, design: .rounded))
                                    .kerning(0.25)
                                    .foregroundColor(.white))
                        
                }.offset(x: -CGFloat(index * 25))
            }
            if membersCount < members.count {
                moreCircle
                    .offset(x: -CGFloat(membersCount * 25))
            }
        }.offset(x: CGFloat(membersCount - (membersCount < members.count ? 0 : 1)) * CGFloat(12.5))
        .sheet(isPresented: $showingMember) {
            ResidentDetailView(viewModel: ResidentDetailViewModel(resident: selectedMember!), showing: $showingMember)
        }
    }
    
    private var moreCircle: some View {
        Circle()
            .frame(width: 70, height: 70)
            .foregroundColor(Color.gray)
            .overlay(Circle().stroke(Color.primary.opacity(0.06), lineWidth: 4))
            .overlay(VStack {
                Text("+\(members.count - membersCount)")
                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white)
                Text("more".localized)
                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                    .kerning(0.25)
                    .foregroundColor(.white)
                    })
    }
    
    private func show(_ member: Resident) {
        selectedMember = member
        showingMember = true
    }
}

struct AmtDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AmtDetailView(showing: .constant(true), amt: .tutor)
    }
}

//
//  ExperimentalView.swift
//  HHG
//
//  Created by Richard Pfannenstiel on 01.09.22.
//

import SwiftUI

struct ExperimentalView: View {
    
    @AppStorage("settings.booking.beverages") var beveragesOn = false
    @State var demoBeverages: [String : [Double]]? = nil
    
    let demoString = "Abbuchung Liste (R: 3x0.50 3x2.00 7x0.85)"
    let dismiss: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
            }
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.indigo)
            Text("Experimental".localized)
                .font(Font.system(size: 35, weight: .heavy, design: .rounded))
                .kerning(0.25)
            Text("You may enable experimental features which are currently still in development.".localized)
                .font(Font.system(size: 17, weight: .regular, design: .rounded))
                .kerning(0.25)
                .multilineTextAlignment(.center)
                .padding(.bottom)
                .padding(.horizontal)
            beveragesView
                .onAppear {
                    self.demoBeverages = calculateBeverages(string: demoString)
                }
            Spacer()
        }.background(backgroundView)
    }
    
    private var cardBackground: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            Color.white
            Color.secondary.opacity(0.2)
        }.edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        Button(action: dismiss) {
            Image(systemName: "chevron.left.circle.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }.padding()
    }
    
    private var beveragesView: some View {
        VStack {
            HStack {
                Toggle(isOn: $beveragesOn) {
                    Text("Beverage Bookings".localized)
                        .font(Font.system(size: 17, weight: .regular, design: .rounded))
                        .kerning(0.25)
                }
            }
            if beveragesOn {
                demoBeveragesView
                    .frame(height: 100)
                    .padding(.vertical)
                HStack {
                    Text("Bookings for beverage consumption are displayed as swipable tally sheets.")
                        .font(Font.system(size: 17, weight: .regular, design: .rounded))
                        .kerning(0.25)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                demoComment
                    .frame(height: 100)
                    .padding(.vertical)
                HStack {
                    Text("Bookings for beverage consumption will display the booking comment.")
                        .font(Font.system(size: 17, weight: .regular, design: .rounded))
                        .kerning(0.25)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }.padding()
        .frame(width: screen.width - 30)
        .background(Color.white)
        .cornerRadius(15)
    }
    
    
    private func calculateBeverages(string: String) -> [String : [Double]] {
        var beverages: [String : [Double]] = [:]
        
        if !string.contains("R") {
            return beverages
        }
        let contents = string.split(separator: "R")[1].dropFirst(2).dropLast()
        let items = contents.split(separator: " ")
        
        for item in items {
            let quantity = Double(item.split(separator: "x")[0]) ?? 0.00
            let price = Double(item.split(separator: "x")[1]) ?? 0.00
            
            switch price {
            case 0.50:
                beverages["softdrink"] = [quantity, price]
            case 0.70:
                beverages["softdrink"] = [quantity, price]
            case 0.85:
                beverages["beer"] = [quantity, price]
            case 1.30:
                beverages["beer"] = [quantity, price]
            case 0.60:
                beverages["snacks1"] = [quantity, price]
            case 1.00:
                beverages["snacks2"] = [quantity, price]
            case 2.00:
                beverages["cocktail"] = [quantity, price]
            case 3.00:
                beverages["cocktail"] = [quantity, price]
            default:
                beverages["other"] = [quantity, price]
            }
        }
        return beverages
    }
    
    private var demoComment: some View {
        Text(demoString)
            .font(Font.system(size: 18, weight: .semibold, design: .rounded))
            .kerning(0.25)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
    }
    
    private var demoBeveragesView: AnyView {
        if let demoBeverages = self.demoBeverages {
            return AnyView(HStack {
                TabView {
                    if let softdrinks = demoBeverages["softdrink"] {
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                                .overlay(Image("softdrink")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40))
                            VStack(alignment: .leading) {
                                Text("Softdrink:")
                                    .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                    .kerning(0.25)
                                striche(number: Int(softdrinks[0]), price: softdrinks[1])
                            }.padding(.leading, 5)
                            
                            Spacer()
                        }
                    }
                    if let beer = demoBeverages["beer"] {
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                                .overlay(Image("beer")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40))
                            VStack(alignment: .leading) {
                                Text("Beer:".localized)
                                    .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                    .kerning(0.25)
                                striche(number: Int(beer[0]), price: beer[1])
                            }.padding(.leading, 5)
                            Spacer()
                        }
                    }
                    if let snacks1 = demoBeverages["snacks1"] {
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                                .overlay(Image("snacks1")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40))
                            VStack(alignment: .leading) {
                                Text("Snack 1:")
                                    .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                    .kerning(0.25)
                                striche(number: Int(snacks1[0]), price: snacks1[1])
                            }.padding(.leading, 5)
                            Spacer()
                        }
                    }
                    if let snacks2 = demoBeverages["snacks2"] {
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                                .overlay(Image("snacks2")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40))
                            VStack(alignment: .leading) {
                                Text("Snack 2:")
                                    .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                    .kerning(0.25)
                                striche(number: Int(snacks2[0]), price: snacks2[1])
                            }.padding(.leading, 5)
                            Spacer()
                        }
                    }
                    if let cocktails = demoBeverages["cocktail"] {
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                                .overlay(Image("cocktail")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40))
                            VStack(alignment: .leading) {
                                Text("Cocktail:")
                                    .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                    .kerning(0.25)
                                striche(number: Int(cocktails[0]), price: cocktails[1])
                            }.padding(.leading, 5)
                            Spacer()
                        }
                    }
                    if let misc = demoBeverages["other"] {
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                                .overlay(Image("cocktail_alcfree")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40))
                            VStack(alignment: .leading) {
                                Text("Special:")
                                    .font(Font.system(size: 18, weight: .semibold, design: .rounded))
                                    .kerning(0.25)
                                striche(number: Int(misc[0]), price: misc[1])
                            }.padding(.leading, 5)
                            Spacer()
                        }
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.horizontal)
                .frame(height: 80)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(15)
            })
        } else {
            return AnyView(
                HStack {
                    ProgressView()
                        .padding(.trailing, 5)
                    Text("Loading")
                }
            )
        }
    }
    
    private func striche(number: Int, price: Double) -> AnyView {
        let blocks = Int(floor(Double(number / 5)))
        let singles = number % 5
        let view = AnyView(
            HStack {
                ForEach(0..<blocks, id: \.self) { _ in
                    Text("IIII")
                        .font(Font.system(size: 18, weight: .regular, design: .rounded))
                        .kerning(0.25)
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .rotationEffect(Angle(degrees: -35))
                        )
                }
                Text("\(String(repeating: "I", count: singles))")
                    .font(Font.system(size: 18, weight: .regular, design: .rounded))
                    .kerning(0.25)
                Text("-  \(String(format: "%.2f", Double(number) * price))€")
                    .font(Font.system(size: 18, weight: .regular, design: .rounded))
                    .kerning(0.25)
            }
        )
        return view
    }
}

struct ExperimentalView_Previews: PreviewProvider {
    static var previews: some View {
        ExperimentalView(dismiss: {})
            .previewInterfaceOrientation(.portrait)
    }
}

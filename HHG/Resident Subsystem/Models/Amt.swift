//
//  Amt.swift
//  HHG
//
//  Created by Marc Fett on 25.03.22.
//

import Foundation
import SwiftUI

enum Amt: String, Identifiable {
    
    var id: String {
        self.rawValue
    }
    
    var isbigOffice: Bool {
        [.haussprecher, .barTeam, .tutor, .admin].contains(self)
    }
    
    var account: String? {
        switch self {
        case .haussprecher:
            return "team_hscash"
        case .barTeam:
            return "team_bar"
        case .tutor:
            return "team_tutor"
        case .admin:
            return "team_admin"
        case .bank:
            return "team_bank"
        default:
            return nil
        }
    }
    
    var image: Image {
        switch self {
        case .haussprecher:
            return Image("team_haussprecher")
        case .barTeam:
            return Image("team_bar")
        case .tutor:
            return Image("team_tutor")
        case .admin:
            return Image("team_admin")
        case .cinema:
            return Image("team_kino")
        case .kassenpruefer:
            return Image("team_pruefer")
        case .barsupport:
            return Image("team_barsupport")
        case .auswahlausschuss:
            return Image("team_auswahl")
        case .radwart:
            return Image("team_bike")
        case .erstehilfe:
            return Image("team_firstaid")
        case .gartenTeam:
            return Image("team_garden")
        case .hilfshausmeister:
            return Image("team_janitor")
        case .klavierwart:
            return Image("team_piano")
        case .grillwart:
            return Image("team_grill")
        default:
            return Image(systemName: "person.2.circle.fill")
        }
    }
    
    var description: String {
        switch self {
        case .haussprecher:
            return """
                   As a house speaker you are \"the girl for everything\" and are basically available for all questions and problems concerning the dormitory. Your main tasks include the organization of the Newcomer's Evening, the Resident Council, the General Assembly and the semi-annual Resident Party (Summer Party and Christmas Party). Furthermore, you facilitate cash deposits for residents.
                   """.localized
        case .barTeam:
            return """
                   The bar team consists of several people who together perform the following tasks. The main duty is the organization and carrying out of bar evenings during the semester. Furthermore, the bar team is responsible for stocking the fridge and takes care of the purchase of drinks and other bar and kitchen utensils. In addition to accepting cash deposits, the bar team facilitates the (private) rental of the bar and kitchen.
                   """.localized
        case .tutor:
            return """
                   As a tutor, you organize various tutoring activities during the lecture period. Together with another tutor, you plan the activities at the beginning of the semester and create a tutor program for the showcase. Tutor activities can be very varied, ranging from a table football tournament and a joint Escape Room to a collective ski trip.
                   """.localized
        case .admin:
            return """
                   The admin team consists of several people who basically take care of the information technology in the dormitory. This includes the administration of the dormitory network and the printer as well as the further development of the intranet. In addition, the team works independently on new projects to improve and constantly expand the digital dorm life.
                   """.localized
        case .kassenpruefer:
            return """
                   The two residence cash auditors are responsible for checking the accounting entries of residence accounts. This audit takes place once during the semester following the Annual General Meeting and marks the close of funds for the current semester.
                   """.localized
        case .cinema:
            return """
                   The cinema team consists of several film enthusiasts who organize cinema evenings during the lecture period. For this purpose, they make a suitable selection of films and provide the residents with free popcorn.
                   """.localized
        case .gartenTeam:
            return """
                   The garden team maintains the vegetable patch of the dormitory during the summer semester. They decide which herbs and vegetables should be planted.
                   """.localized
        case .grillwart:
            return """
                   The grill keeper takes care of the maintenance and availability of the common grill during the summer semester. Together with the bar team he takes care of the supply of barbecue charcoal, which may be used by the residents for non-private parties.
                   """.localized
        case .hilfshausmeister:
            return """
                   The assistant janitor is available for minor repairs (for example, changing a light bulb). The person should also be available on weekends in case the actual janitor is not available.
                   """.localized
        case .barsupport:
            return """
                   As part of the bar support, you will help the bar team with the realization of bar evenings. Especially mixing cocktails is one of the main tasks of this position.
                   """.localized
        case .erstehilfe:
            return """
                   You are the dormitory's contact for first aid and have a hand for treating minor injuries.
                   """.localized
        case .klavierwart:
            return """
                   As the piano keeper, you will take care of the maintenance of the piano in the bar.
                   """.localized
        case .radwart:
            return """
                   You are the contact person of the dormitory for bicycle repairs. For this you are available with suitable tools and know-how.
                   """.localized
        case .auswahlausschuss:
            return """
                   As part of the selection committee you evaluate applications for the dormitory. You decide which people could integrate well into the existing community and enrich the dormitory life.
                   """.localized
        default:
            return ""
        }
    }
    
    // Große Ämter
    case haussprecher = "Haussprecher"
    case barTeam = "Barteam"
    case tutor = "Tutoren"
    case admin = "Administratoren"
    
    // Kleine Ämter
    case kassenpruefer = "Kassenprüfer"
    case cinema = "Kino Team"

    // Sonstige Ämter
    case barsupport = "Bar Support"
    case auswahlausschuss = "Auswahlausschuss"
    case gartenTeam = "Garten Team"
    case grillwart = "Grillwart"
    case hilfshausmeister = "Hilfshausmeister"
    case erstehilfe = "Erste Hilfe"
    case klavierwart = "Klavierwart"
    case radwart = "Radwart"
    
    // Anderes
    case hausverwaltung = "Hausverwaltung"
    case bank = "Bank"
    case resident
    
    init(group: String) {
        switch group {
        case "haussprecher":
            self = .haussprecher
        case "barteam":
            self = .barTeam
        case "tutoren":
            self = .tutor
        case "admins":
            self = .admin
        case "barsupport":
            self = .barsupport
        case "auswahlausschuss":
            self = .auswahlausschuss
        case "gartenteam":
            self = .gartenTeam
        case "grillwart":
            self = .grillwart
        case "hilfshausmeister":
            self = .hilfshausmeister
        case "kassenpruefer":
            self = .kassenpruefer
        case "erstehilfe":
            self = .erstehilfe
        case "kinoteam":
            self = .cinema
        case "klavierwart":
            self = .klavierwart
        case "hausverwaltung":
            self = .hausverwaltung
        case "radwart":
            self = .radwart
        default:
            self = .resident
        }
    }
    
    init(account: String) {
        switch account {
        case "team_hscash":
            self = .haussprecher
        case "team_bar":
            self = .barTeam
        case "team_tutor":
            self = .tutor
        case "team_admin":
            self = .admin
        case "team_bank":
            self = .bank
        default:
            self = .resident
        }
    }
}

extension Amt: BookingPartner {
    var transactionID: String {
        account ?? ""
    }
}

extension Amt: CaseIterable {}

//
//  MarketItemView.swift
//  tbc-x-hackathon
//
//  Created by Akaki Titberidze on 04.07.24.
//

import SwiftUI

struct MarketItemView: View {
    let item: MarketItem
    var showPrice: Bool
    var buttonClicked: () -> Void
    
    var body: some View {
        Button(action: {
            buttonClicked()
        }) {
            VStack {
                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding()
                
                Text(item.title)
                    .font(.custom("VarelaRound-Regular", size: 16))
                    .foregroundStyle(.customLightBlue)

                Spacer()
                if showPrice {
                    HStack {
                        Image("coinIcon")

                        Text("10")
                            .font(.custom("VarelaRound-Regular", size: 16))
                            .foregroundColor(.primary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}



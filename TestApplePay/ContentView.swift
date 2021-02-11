//
//  ContentView.swift
//  TestApplePay
//
//  Created by Ana Carolina Soares de Melo on 11/02/21.
//

import SwiftUI
import UIKit
import PassKit

struct ContentView: View {
    var body: some View {
        PaymentButton()
    }
}

struct PaymentButton: View {
    let paymentHandler = PaymentHandler() //As defined by Taif
    
    var body: some View {
        Button(action: {
            // Using the code from Tarif!
            self.paymentHandler.startPayment { success in
                if success {
                    print("Success")
                } else {
                    print("Failed")
                }
            }
        }, label: { EmptyView() } )
        .buttonStyle(PaymentButtonStyle())
    }
}

struct PaymentButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return PaymentButtonHelper()
    }
}

struct PaymentButtonHelper: View {
    var body: some View {
        PaymentButtonRepresentable()
            .frame(minWidth: 100, maxWidth: 400)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
    }
}

extension PaymentButtonHelper {
    struct PaymentButtonRepresentable: UIViewRepresentable {
        
        var button: PKPaymentButton {
            let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black) /*customize here*/
            button.cornerRadius = 4.0 /* also customize here */
            return button
        }
        
        func makeUIView(context: Context) -> PKPaymentButton {
            return button
        }
        func updateUIView(_ uiView: PKPaymentButton, context: Context) { }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

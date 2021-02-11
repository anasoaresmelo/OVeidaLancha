//
//  PaymentHandler.swift
//  TestApplePay
//
//  Created by Ana Carolina Soares de Melo on 11/02/21.
//

import Foundation
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {

static let supportedNetworks: [PKPaymentNetwork] = [
    .amex,
    .masterCard,
    .visa
]

var paymentController: PKPaymentAuthorizationController?
var paymentSummaryItems = [PKPaymentSummaryItem]()
var paymentStatus = PKPaymentAuthorizationStatus.failure
var completionHandler: PaymentCompletionHandler?

func startPayment(completion: @escaping PaymentCompletionHandler) {

    let amount = PKPaymentSummaryItem(label: "Ammount", amount: NSDecimalNumber(string: "8.88"), type: .final)
    let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.12"), type: .final)
    let total = PKPaymentSummaryItem(label: "ToTal", amount: NSDecimalNumber(string: "10.00"), type: .pending)

    paymentSummaryItems = [amount, tax, total];
    completionHandler = completion

    // Create our payment request
    let paymentRequest = PKPaymentRequest()
    paymentRequest.paymentSummaryItems = paymentSummaryItems
    paymentRequest.merchantIdentifier = "merchant.com.YOURDOMAIN.YOURAPPNAME"
    paymentRequest.merchantCapabilities = .capability3DS
    paymentRequest.countryCode = "US"
    paymentRequest.currencyCode = "USD"
    paymentRequest.requiredShippingContactFields = [.phoneNumber, .emailAddress]
    paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks

    // Display our payment request
    paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
    paymentController?.delegate = self
    paymentController?.present(completion: { (presented: Bool) in
        if presented {
            NSLog("Presented payment controller")
        } else {
            NSLog("Failed to present payment controller")
            self.completionHandler!(false)
         }
     })
  }
}

/*
    PKPaymentAuthorizationControllerDelegate conformance.
*/
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

    // Perform some very basic validation on the provided contact information
    if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
        paymentStatus = .failure
    } else {
        // Here you would send the payment token to your server or payment provider to process
        // Once processed, return an appropriate status in the completion handler (success, failure, etc)
        paymentStatus = .success
    }

    completion(paymentStatus)
}

func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
    controller.dismiss {
        DispatchQueue.main.async {
            if self.paymentStatus == .success {
                self.completionHandler!(true)
            } else {
                self.completionHandler!(false)
            }
        }
    }
}

}

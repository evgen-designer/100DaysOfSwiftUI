//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Mac on 30/08/2024.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .accessibilityHidden(true)
                } placeholder: {
                    ProgressView()
                        .accessibilityHidden(true)
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $showingConfirmation) { } message: {
            Text(confirmationMessage)
        }
    }
    
//    func placeOrder() async {
//        guard let encoded = try? JSONEncoder().encode(order) else {
//            print("Failed to encode order")
//            return
//        }
//        
//        let url = URL(string: "https://reqres.in/api/capcakes")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        
//        do {
//            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
//            
//            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
//            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
//            showingConfirmation = true
//        } catch {
//            print("Check out failed: \(error.localizedDescription)")
//        }
//    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/capcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            confirmationMessage = "Sorry, there was an error placing your order. Please check your internet connection and try again."
            showingConfirmation = true
            print("Check out failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}

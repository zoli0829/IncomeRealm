//
//  EditTransactionView.swift
//  Income
//
//  Created by Zoltan Vegh on 08/11/2025.
//

import SwiftUI
import RealmSwift

struct EditTransactionView: View {
    
    @State private var amount = 0.0
    @State private var transactionTitle = ""
    @State private var selectedTransactionType: TransactionType = .expense
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @ObservedRealmObject var transactionToEdit: TransactionModel
    @Environment(\.dismiss) var dismiss

    @AppStorage("currency") var currency = Currency.usd
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = currency.locale
        return numberFormatter
    }
    
    var body: some View {
        VStack {
            TextField("0.00", value: $amount, formatter: numberFormatter)
                .font(.system(size: 60, weight: .thin))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
            Rectangle()
                .fill(Color(uiColor: UIColor.lightGray))
                .frame(height: 0.5)
                .padding(.horizontal, 30)
            Picker("Choose Type", selection: $selectedTransactionType) {
                ForEach(TransactionType.allCases) { transactionType in
                    Text(transactionType.title)
                        .tag(transactionType)
                }
            }
            TextField("Title", text: $transactionTitle)
                .font(.system(size: 15))
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
                .padding(.top)
            Button(action: {
                guard transactionTitle.count >= 2 else {
                    alertTitle = "Invalid Title"
                    alertMessage = "Title must be 2 or more characters long."
                    showAlert = true
                    return
                }
                guard let realm = transactionToEdit.realm?.thaw() else {
                    alertTitle = "Ooops"
                    alertMessage = "Transaction could not be edited right now."
                    showAlert = true
                    return
                }
                do {
                    try realm.write {
                        transactionToEdit.thaw()?.title = transactionTitle
                        transactionToEdit.thaw()?.amount = amount
                        transactionToEdit.thaw()?.type = selectedTransactionType
                    }
                } catch {
                    alertTitle = "Ooops"
                    alertMessage = "Transaction could not be edited right now."
                    showAlert = true
                }
                
                dismiss()
                
            }, label: {
                Text("Update")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryLightGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    
            })
            .padding(.top)
            .padding(.horizontal, 30)
            Spacer()
        }
        .onAppear() {
            amount = transactionToEdit.amount
            selectedTransactionType = transactionToEdit.type
            transactionTitle = transactionToEdit.title
        }
        .padding(.top)
        .alert(alertTitle, isPresented: $showAlert) {
            Button(action: {
                
            }, label: {
                Text("OK")
            })
        } message: {
            Text(alertMessage)
        }
    }
}

//#Preview {
//    EditTransactionView()
//}

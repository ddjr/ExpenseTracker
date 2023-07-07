//
//  RecentTransactionListView.swift
//  ExpenseTracker
//
//  Created by David Daly on 7/7/23.
//

import SwiftUI

struct RecentTransactionListView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    private let headerTitle: String = "Recent Transactions"
    var body: some View {
        VStack {
            HStack {
                // MARK: Header Title
                Text(headerTitle)
                    .bold()
                Spacer()
                
                // MARK: Header Link
                NavigationLink(destination: TransactionList()) {
                        HStack(spacing: 4) {
                            Text("See All")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.text)
                }
                
            }
            .frame(height: 25)
            .padding(.top)
            
            // MARK: Recent Transaction List
            ForEach(Array(transactionListVM.transactions.prefix(5).enumerated()), id: \.element) { index, transaction in
                TransactionRow(transaction: transaction)

                Divider()
                    .opacity(index == 4 ? 0 : 1)
            }
        }
        .navigationTitle(headerTitle)
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct RecentTransactionListView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()

    static var previews: some View {
        NavigationStack {
            RecentTransactionListView()
                .environmentObject(transactionListVM)
        }
    }
}

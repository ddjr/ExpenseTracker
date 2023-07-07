//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by David Daly on 7/6/23.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    var demoData: [Double] = [80, 50, 40, 60, 120, 90, 200, 80, 50, 40, 60, 120, 90, 200]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: Tit
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    // MARK: Chart
                    let data = transactionListVM.accumulateTransactions()
                    let total = data.last?.rounded() ?? 0
                    LineChartView(data: data, title: total.formatted(.currency(code: "USD")), form: ChartForm.extraLarge)
                    
                    // MARK: Transaction List
                    RecentTransactionListView()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Notification Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
    
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        ContentView()
            .environmentObject(transactionListVM)
    }
}

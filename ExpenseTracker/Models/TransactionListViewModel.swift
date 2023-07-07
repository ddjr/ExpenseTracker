//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by David Daly on 7/6/23.
//

import Foundation
import Combine
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    private var cancellables = Set<AnyCancellable>()
    init() {
        getTransactions()
    }
    
    func getTransactions() {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invaild URL")
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching transactions:", error.localizedDescription)
                case .finished:
                    print("Finish fetching transactions")
                }
            } receiveValue: { [weak self] result in
                self?.transactions = result
                dump(self?.transactions)
            }
            .store(in: &cancellables)
    }
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        let groupedTransactions = TransactionGroup(grouping: transactions, by: \.month)
        return groupedTransactions
    }
    
    func accumulateTransactions() -> [Double] {
        guard !transactions.isEmpty else { return [] }
        print("accumulateTransactions")
        
        let today = "02/17/2022".dateParsed() // Date()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum: [Double] = []
        let secondsInADay: Double = 60*60*24
        for date in stride(from: dateInterval.start, to: today, by: secondsInADay) {
            let dailyExpenses = transactions.filter({ $0.dateParsed == date && $0.isExpense })
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            sum += dailyTotal
            cumulativeSum.append(sum)
            print(date.formatted(), "Daily Total: ", dailyTotal, " Sum: ", sum)
        }

        return cumulativeSum
    }
}

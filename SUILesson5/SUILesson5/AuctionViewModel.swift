//
//  ViewModel.swift
//  SUILesson5
//
//  Created by Григоренко Александр Игоревич on 22.01.2023.
//

import Foundation

/// Модель представления экрана с аукционом.
final class AuctionViewModel: ObservableObject {

    // MARK: - Public properties

    @Published var currentCompany = Company(
        name: Constants.mersedecName,
        models: [Constants.mercedesAName, Constants.mercedesCName, Constants.mercedesDName]
    )

    @Published var companies = [
        Company(
            name: Constants.mersedecName,
            models: [Constants.mercedesAName, Constants.mercedesCName, Constants.mercedesDName]
        ),
        Company(
            name: Constants.bmwName,
            models: [Constants.bmw1Name, Constants.bmw3Name, Constants.bmw5Name]
        ),
        Company(
            name: Constants.audiName,
            models: [Constants.audi1Name, Constants.audi3Name, Constants.audi5Name]
        ),
    ]

    @Published var currentLotPrice: Float = 0

    // MARK: - Public methods

    func setCurrentCompany(tag: Int) {
        currentCompany = companies[tag]
    }

    func getModel(tag: Int) -> String {
        currentCompany.models[tag]
    }

    func setCurrentLot(price: Float) {
        currentLotPrice = price
    }
}

//
//  ContentView.swift
//  SUILesson5
//
//  Created by Григоренко Александр Игоревич on 19.01.2023.
//

import SwiftUI

/// Контент представления экрана с аукционом.
struct ContentView: View {

    // MARK: - Public properties

    var body: some View {
        ZStack {
            stackWithInfoAboutAuto
                .animation(.spring())
                .offset(x: CGFloat(hstackOffset))

            VStack {
                currentCostView
                Spacer()
                lotView
                Spacer()
                imageView
                pickersView
                offersCostView
                offersCostSlider
                betButtonsView
            }
            .animation(.spring())
            .offset(y: CGFloat(vstackOffset))
        }
    }

    // MARK: - private properties

    @StateObject private var viewModel = AuctionViewModel()
    @State private var segmentIndexCompany = 0
    @State private var isShareShown = false
    @State private var segmentIndexCarsModel = 0
    @State private var isBetAlertShown = false
    @State private var isInfoAlertShown = false
    @State private var offsetX = 0
    @State private var priceStape: Float = 0
    @State private var vstackOffset: Float = 0
    @State private var hstackOffset: Float = -250
    private var currentPrice = Int.random(in: Constants.currentRandomPrice)

    // MARK: - private methods

    private var stackWithInfoAboutAuto: some View {
        VStack {
            Text(Constants.haracteristicsName)
            HStack {
                Text(Constants.valueOfEngineName).padding()
                Spacer()
                Text(Constants.valueOfEngine).padding()
            }
            HStack {
                Text(Constants.acselerateForHundredName).padding()
                Spacer()
                Text(Constants.acselerateForHundredValue).padding()
            }
            HStack {
                Text(Constants.horsePowerName).padding()
                Spacer()
                Text(Constants.horsePowerValue).padding()
            }
            HStack {
                Text(Constants.masseName).padding()
                Spacer()
                Text(Constants.masseValue).padding()
            }
            HStack {
                Text(Constants.consumptionName).padding()
                Spacer()
                Text(Constants.consumptionValue).padding()
            }

            HStack {
                Button(Constants.backToLot) {
                    self.vstackOffset = Constants.zeroOffset
                    self.hstackOffset = -Constants.oneThousandOffset
                }
                .frame(width: Constants.backToLotButtonWidth, height: Constants.backToLotButtonHeight, alignment: .center)
                .background(Color.yellow)
                .foregroundColor(.white)
                .cornerRadius(Constants.backToLotButtonCornerRadius)

                Button(action: {
                    self.isShareShown = true
                }, label: {
                    Image(systemName: Constants.shareButtonImageName)
                }).sheet(isPresented: $isShareShown, content: {
                    ActivityView(activityItems: [])
                })
                .frame(width: Constants.shareButtonWidth, height: Constants.shareButtonHeight, alignment: .center)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(Constants.backToLotButtonCornerRadius)
            }
        }
    }

    private var currentCostView: some View {
        Form {
            Text("\(Constants.currentCostName)\(currentPrice + Int(viewModel.currentLotPrice)) \(Constants.rublesName)")
        }
    }

    private var lotView: some View {
        Text("\(Constants.textWithOffersWidth)\(segmentIndexCarsModel + 1) - \(viewModel.companies[segmentIndexCompany].name)")
            .font(.system(.headline))
    }

    private var imageView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.backToLotButtonCornerRadius)
                .fill(Color.gray)
                .offset(x: CGFloat(offsetX))
                .padding()

            Image(viewModel.currentCompany.models[segmentIndexCarsModel])
                .resizable()
                .scaledToFit()
                .frame(width: Constants.autoImageWidht, height: Constants.autoImageHeight)
                .offset(x: CGFloat(offsetX))
        }
    }

    private var pickersView: some View {
        VStack {
            Picker(selection: Binding(get: {
                self.segmentIndexCompany
            }, set: { (newValue) in
                self.segmentIndexCompany = newValue
                self.viewModel.setCurrentCompany(tag: newValue)
            }), label: Text(Constants.emptyString)) {
                ForEach(0..<self.viewModel.companies.count) {
                    Text(self.viewModel.companies[$0].name).tag($0)
                }
            }
            .pickerStyle(.segmented).padding()

            Picker(selection: $segmentIndexCarsModel, label: Text(Constants.emptyString)) {
                ForEach(0..<self.viewModel.currentCompany.models.count) {
                    Text(self.viewModel.getModel(tag: $0)).tag($0)
                }
            }
            .pickerStyle(.segmented).padding()
        }
    }

    private var offersCostView: some View {
        Text("\(currentPrice + Int(priceStape))")
            .frame(width: Constants.textWithOffersWidth, height: Constants.textWidhtOffersheight)
            .border(Color.green)
    }

    private var offersCostSlider: some View {
        Slider(value: Binding(get: {
            self.priceStape
        }, set: { newValue in
            self.priceStape = newValue
            self.isInfoAlertShown = true
        }), in: (Float(currentPrice) * Constants.lowBetСoefficient)...(Float(currentPrice) * Constants.maxBetСoefficient)) {
            Text(Constants.emptyString)
        } minimumValueLabel: {
            Text(Constants.tenProcent)

        } maximumValueLabel: {
            Text(Constants.thirtyProcent)
        }
        .padding()
    }

    private var betButtonsView: some View {
        VStack {

            Button {
                self.isBetAlertShown = true
            } label: {
                Text(Constants.makeBetName)
            }
            .alert(Text(Constants.betQuestionName), isPresented: $isBetAlertShown) {
                HStack {
                    Button(Constants.yesName) {
                        self.viewModel.setCurrentLot(price: priceStape)
                    }
                    Button(Constants.noName) {}
                }
            }
            .frame(width: Constants.backToLotButtonWidth, height: Constants.backToLotButtonHeight, alignment: .center)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(Constants.backToLotButtonCornerRadius)

            Button(Constants.infoName) {
                self.vstackOffset = Constants.oneThousandOffset
                self.hstackOffset = Constants.zeroOffset
            }
            .frame(width: Constants.backToLotButtonWidth, height: Constants.backToLotButtonHeight, alignment: .center)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(Constants.backToLotButtonCornerRadius)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

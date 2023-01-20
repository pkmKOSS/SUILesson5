//
//  ContentView.swift
//  SUILesson5
//
//  Created by Григоренко Александр Игоревич on 19.01.2023.
//

import SwiftUI

/// Контент представления экрана с аукционом.
struct ContentView: View {

    // MARK: - public properties

    var body: some View {
        ZStack {
            stackWithInfoAboutAuto
                .animation(.spring())
                .offset(x: CGFloat(hstackOffset))

            VStack {
                formWithCurrentCost
                Spacer()
                textIwthLotName
                Spacer()
                zstackWithImage
                vstackWithPickers
                textWithOffersCost
                offersCostSlider
                vstackWithBetButtons
            }
            .animation(.spring())
            .offset(y: CGFloat(vstackOffset))
        }
    }

    // MARK: - private properties

    @ObservedObject private var viewModel = ViewModel()
    @State private var segmentIndexCompany = 0
    @State private var isShareShown = false
    @State private var segmentIndexCarsModel = 0
    @State private var isBetAlertShown = false
    @State private var isInfoAlertShown = false
    @State private var offsetX = 0
    @State private var priceStape: Float = 0
    @State private var vstackOffset: Float = 0
    @State private var hstackOffset: Float = -250
    private var currentPrice = Int.random(in: 1000000...7000000)

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
                .frame(width: 250, height: 30, alignment: .center)
                .background(Color.yellow)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button(action: {
                    self.isShareShown = true
                }, label: {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                }).sheet(isPresented: $isShareShown, content: {
                    ActivityView(activityItems: ["message test"])
                })
                .frame(width: 40, height: 30, alignment: .center)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }

    private var formWithCurrentCost: some View {
        Form {
            Text("\(Constants.currentCostName)\(currentPrice + Int(viewModel.currentLotPrice)) \(Constants.rublesName)")
        }
    }

    private var textIwthLotName: some View {
            Text("Лот № \(segmentIndexCarsModel + 1) - \(viewModel.company[segmentIndexCompany].name)")
                .font(.system(.headline))
    }

    private var zstackWithImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .offset(x: CGFloat(offsetX))
                .padding()

            Image(viewModel.currentCompany.models[segmentIndexCarsModel])
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .offset(x: CGFloat(offsetX))
        }
    }

    private var vstackWithPickers: some View {
        VStack {
            Picker(selection: Binding(get: {
                self.segmentIndexCompany
            }, set: { (newValue) in
                self.segmentIndexCompany = newValue
                self.viewModel.setCurrentCompany(tag: newValue)
            }), label: Text(Constants.emptyString)) {
                ForEach(0..<self.viewModel.company.count) {
                    Text(self.viewModel.company[$0].name).tag($0)
                }
            }.pickerStyle(.segmented).padding()

            Picker(selection: $segmentIndexCarsModel, label: Text(Constants.emptyString)) {
                ForEach(0..<self.viewModel.currentCompany.models.count) {
                    Text(self.viewModel.getModel(tag: $0)).tag($0)
                }
            }.pickerStyle(.segmented).padding()
        }
    }

    private var textWithOffersCost: some View {
        Text("\(currentPrice + Int(priceStape))")
            .frame(width: 150, height: 35)
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

    private var vstackWithBetButtons: some View {
        VStack {

            Button {
                self.isBetAlertShown = true
            } label: {
                Text(Constants.makeBetName)
            }.alert(Text(Constants.betQuestionName), isPresented: $isBetAlertShown) {
                HStack {
                    Button(Constants.yesName) {
                        self.viewModel.setCurrentLot(price: priceStape)
                    }
                    Button(Constants.noName) {}
                }
            }
            .frame(width: 250, height: 40, alignment: .center)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button(Constants.infoName) {
                self.vstackOffset = Constants.oneThousandOffset
                self.hstackOffset = Constants.zeroOffset
            }
            .frame(width: 250, height: 30, alignment: .center)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

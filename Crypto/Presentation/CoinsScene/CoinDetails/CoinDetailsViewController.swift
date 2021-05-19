//
//  CoinDetailsViewController.swift
//  Crypto
//
//  Created by Dan Vleju on 19.05.2021.
//

import UIKit
import Charts

final class CoinDetailsViewController: UIViewController, ChartViewDelegate {

    private let viewModel: CoinDetailsViewModel

    var chartView: CandleStickChartView!

    init(viewModel: CoinDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title

        configureUI()
        setChartData()
    }

    private func configureUI() {
        view.backgroundColor = .white

        chartView = CandleStickChartView()
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.leftMargin)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin)
            make.height.equalTo(300)
        }

        chartView.delegate = self
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 200
        chartView.pinchZoomEnabled = true
        chartView.legend.enabled = false
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
    }

    func setChartData() {
        let sets: [CandleChartDataSet] = viewModel.chartDataEntries.map { entry -> CandleChartDataSet in
            let set = CandleChartDataSet(entries: [entry], label: "Data Set \(entry.x)")
            set.axisDependency = .left
            set.setColor(UIColor(white: 80/255, alpha: 1))
            set.drawIconsEnabled = false
            set.shadowColor = .darkGray
            set.shadowWidth = 0.7
            set.decreasingColor = .red
            set.decreasingFilled = true
            set.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
            set.increasingFilled = false
            set.neutralColor = .blue

            return set
        }

        chartView.leftAxis.axisMinimum = sets.map({ $0.yMin }).min() ?? 0

        let data = CandleChartData(dataSets: sets)
        chartView.data = data
    }
}

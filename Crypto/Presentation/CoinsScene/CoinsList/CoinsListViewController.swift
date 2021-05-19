//
//  CoinsListViewController.swift
//  Crypto
//
//  Created by Dan Vleju on 16.05.2021.
//

import UIKit
import Combine
import SnapKit

final class CoinsListViewController: UIViewController {

    private let viewModel: CoinsListViewModel

    private var tableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView!
    private var cancellables: [AnyCancellable] = []

    init(viewModel: CoinsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Market"
        configureUI()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white

        tableView = UITableView()
        tableView.estimatedRowHeight = CoinTableViewCell.height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.margins)
        }

        activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }

    private func bind(to viewModel: CoinsListViewModel) {
        viewModel.state
            .sink { [unowned self] state in
                self.render(state)
            }
            .store(in: &cancellables)
    }

    private func render(_ state: CoinsListState) {
        switch state {
        case .loading:
            tableView.isHidden = true
            activityIndicator.startAnimating()

        case .success(_, let reloadType):
            tableView.isHidden = false
            activityIndicator.stopAnimating()

            switch reloadType {
            case .allItems:
                tableView.reloadData()
            case .item(let index):
                let indexPath = IndexPath(row: index, section: 0)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        case .failure(let error):
            tableView.isHidden = true
            activityIndicator.stopAnimating()
            print(error)
        }
    }
}

extension CoinsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.value.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier) as? CoinTableViewCell else {
            assertionFailure("Failed to dequeue \(CoinTableViewCell.self)")
            return UITableViewCell()
        }

        cell.configure(with: viewModel.state.value.items[indexPath.row]) { [weak self] state in
            self?.viewModel.priceAnimationStateShouldChange(for: indexPath.row, animationState: state)
        }

        return cell
    }
}

extension CoinsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

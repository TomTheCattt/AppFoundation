//
//  FeatureViewController.swift
//  BaseIOSApp
//

import UIKit
import Combine

final class FeatureViewController: BaseViewController {
    private let viewModel: FeatureViewModelProtocol
    private let coordinator: FeatureCoordinatorProtocol

    private lazy var tableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(FeatureTableViewCell.self, forCellReuseIdentifier: FeatureTableViewCell.reuseIdentifier)
        t.delegate = self
        t.dataSource = self
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 60
        return t
    }()

    private lazy var loadingOverlay: ActivityIndicator = {
        let v = ActivityIndicator(frame: view.bounds)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    init(viewModel: FeatureViewModelProtocol, coordinator: FeatureCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func setupUI() {
        super.setupUI()
        title = "Feature List"
        view.addSubview(tableView)
        view.addSubview(loadingOverlay)
    }

    override func setupConstraints() {
        super.setupConstraints()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func setupBindings() {
        super.setupBindings()
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in self?.render(state: state) }
            .store(in: &cancellables)

        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                if loading { self?.loadingOverlay.startAnimating() }
                else { self?.loadingOverlay.stopAnimating() }
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error { self?.showError(error) }
            }
            .store(in: &cancellables)
    }

    private func render(state: FeatureViewState) {
        switch state {
        case .idle: break
        case .loading: loadingOverlay.startAnimating()
        case .loaded:
            loadingOverlay.stopAnimating()
            tableView.backgroundView = nil
            tableView.reloadData()
        case .error:
            loadingOverlay.stopAnimating()
            tableView.backgroundView = nil
            tableView.reloadData()
        case .empty:
            loadingOverlay.stopAnimating()
            showEmptyState()
            tableView.reloadData()
        }
    }

    private func showEmptyState() {
        let empty = EmptyStateView()
        empty.configure(title: "No items", message: "Pull to refresh.")
        tableView.backgroundView = empty
    }
}

extension FeatureViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeatureTableViewCell.reuseIdentifier, for: indexPath) as! FeatureTableViewCell
        if let item = viewModel.item(at: indexPath.row) { cell.configure(with: item) }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectItem(at: indexPath.row)
    }
}

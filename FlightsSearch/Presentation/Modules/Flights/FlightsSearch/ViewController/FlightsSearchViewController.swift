//
//  FlightsSearchViewController.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit
import SnapKit

final class FlightsSearchViewController: NiblessViewController {
    
    // MARK: - Outlets
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.register(AirportCell.self)
        
        return tableView
    }()
    
    // MARK: - Properties
    
    private var viewModel: FlightsSearchViewModelProtocol
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserverKeyboardNotificatons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverKeyboardNotificatons()
    }
    
    // MARK: - Init
    
    init(viewModel: FlightsSearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
}

// MARK: - Private API

extension FlightsSearchViewController {
    
    private func bindViewModel() {
        viewModel.itemsDidUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDataSource

extension FlightsSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.items.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as AirportCell
        let item = viewModel.items[indexPath.row]
        cell.setUp(with: item)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FlightsSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
    
}

// MARK: - Layout

extension FlightsSearchViewController {
    
    private func configureUI() {
        title = "Поиск аэропорта"
        view.addSubview(tableView)
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(view)
        }
    }
    
}

// MARK: - KeyboardShowing

extension FlightsSearchViewController: KeyboardShowing {
    
    func keyboardWillShow(keyboardHeight: CGFloat, with animationDuration: Double) {
        tableView.contentInset.bottom = keyboardHeight + bottomSafeAreaInset
    }
    
    func keyboardWillHide(with animationDuration: Double) {
        tableView.contentInset.bottom = bottomSafeAreaInset
    }
    
}

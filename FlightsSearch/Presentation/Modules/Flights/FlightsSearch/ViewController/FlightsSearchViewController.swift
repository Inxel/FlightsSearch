//
//  FlightsSearchViewController.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit
import SnapKit

final class FlightsSearchViewController: NiblessViewController {
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AirportCell.self)
        
        return tableView
    }()
    private var emptySearchDescriptionLabel: UILabel = UILabel()
    private var searchBar: UISearchBar = UISearchBar()
    
    // MARK: - Properties
    
    private var viewModel: FlightsSearchViewModelProtocol
    private var debouncer: Debouncer = Debouncer(seconds: 0.3)
    
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
        viewModel.itemsDidUpdate = { [weak self] itemsIsEmpty in
            self?.tableView.reloadData()
            
            UIView.animate(withDuration: 0.3) {
                self?.tableView.alpha = itemsIsEmpty ? 0 : 1
            }
        }
        
        viewModel.sameAirportDidSelect = { [weak self] in
            self?.showAlert(
                title: "Слишком крутой маршрут",
                message: "Аэропорты вылета и прилета должны быть разными",
                cancelButtonTitle: "Ок"
            )
        }
    }
    
}

// MARK: - UITableViewDataSource

extension FlightsSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
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
        view.backgroundColor = .white
        view.addSubview(emptySearchDescriptionLabel)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        configureTableView()
        configureEmptySearchDescriptionLabel()
        configureSearchBar()
    }
    
    private func configureTableView() {
        tableView.alpha = 0
        tableView.backgroundColor = .white
        tableView.keyboardDismissMode = .interactive
        tableView.alwaysBounceVertical = true
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureEmptySearchDescriptionLabel() {
        emptySearchDescriptionLabel.text = "Ткните в глобус и введите название попавшегося места или аэропорта, чтобы начать поиск :)"
        emptySearchDescriptionLabel.textAlignment = .center
        emptySearchDescriptionLabel.numberOfLines = 0
        emptySearchDescriptionLabel.textColor = .black
        emptySearchDescriptionLabel.font = .boldSystemFont(ofSize: 20)
        emptySearchDescriptionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Moscow"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .white
        searchBar.delegate = self
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).offset(10)
            make.trailing.equalTo(view).offset(-10)
            make.bottom.equalTo(tableView.snp.top).offset(-5)
        }
    }

}

// MARK: - KeyboardShowing

extension FlightsSearchViewController: KeyboardShowing {
    
    func keyboardWillShow(keyboardHeight: CGFloat, with animationDuration: Double) {
        tableView.contentInset.bottom = keyboardHeight
    }
    
    func keyboardWillHide(with animationDuration: Double) {
        tableView.contentInset.bottom = 0
    }
    
}

// MARK: - UISearchBarDelegate

extension FlightsSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            debouncer.cancel()
            viewModel.setItems(items: [])
            return
        }
        
        debouncer.debounce { [weak self] in
            self?.viewModel.getAirports(query: searchText)
        }
    }
    
}

// MARK: - AlertShowing

extension FlightsSearchViewController: AlertShowing {}

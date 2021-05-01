//
//  FlightsSearchViewController.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit
import SnapKit

// MARK: - Constants

extension FlightsSearchViewController {
    
    private enum Constants {
        static let nothingFoundDescription: String = "Мы не знаем такого места :("
        static let emptySearchBarDescription: String = "Ткните в глобус и введите название попавшегося места или аэропорта, чтобы начать поиск :)"
    }
    
}

// MARK: - View Controller

final class FlightsSearchViewController: NiblessViewController {
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AirportCell.self)
        
        return tableView
    }()
    private var backgroundView: UIView = UIView()
    private var descriptionLabel: UILabel = UILabel()
    private var searchBar: UISearchBar = UISearchBar()
    
    // MARK: - Properties
    
    private var viewModel: FlightsSearchViewModelProtocol
    private var debouncer: Debouncer = Debouncer(seconds: 0.3)
    
    private lazy var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(dismissKeyboard)
    )
    
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
            guard let self = self else { return }
            self.tableView.reloadData()
            
            UIView.animate(withDuration: 0.3) {
                if itemsIsEmpty {
                    self.tableView.alpha = 0
                    self.backgroundView.alpha = 1
                    self.descriptionLabel.text = self.searchBar.text.isNotBlank
                        ? Constants.nothingFoundDescription
                        : Constants.emptySearchBarDescription
                } else {
                    self.tableView.alpha = 1
                    self.backgroundView.alpha = 0
                    self.descriptionLabel.text = nil
                }
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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

// MARK: - Configure Layout

extension FlightsSearchViewController {
    
    private func configureUI() {
        title = "Поиск аэропорта"
        view.backgroundColor = .primaryBackgroundColor
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        configureTableView()
        configureBackgroundView()
        configureSearchBar()
    }
    
    private func configureTableView() {
        tableView.alpha = 0
        tableView.backgroundColor = .primaryBackgroundColor
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureBackgroundView() {
        backgroundView.alpha = 1
        backgroundView.backgroundColor = .primaryBackgroundColor
        backgroundView.addSubview(descriptionLabel)
        configureDescriptionLabel()
        backgroundView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        backgroundView.addGestureRecognizer(tapRecognizer)
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = Constants.emptySearchBarDescription
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .primaryTextColor
        descriptionLabel.font = .boldSystemFont(ofSize: 20)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "Moscow"
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .primaryBackgroundColor
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

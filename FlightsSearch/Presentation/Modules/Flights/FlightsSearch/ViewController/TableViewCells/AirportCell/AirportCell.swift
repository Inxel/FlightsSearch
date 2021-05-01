//
//  AirportCell.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import UIKit
import SnapKit

final class AirportCell: NiblessTableViewCell, ReusableView {

    // MARK: - UI Elements
    
    private let stackView: UIStackView = UIStackView()
    private let cityLabel: UILabel = UILabel()
    private let titleLabel: UILabel = UILabel()
    private let iataLabel: UILabel = UILabel()
    private let separatorView: UIView = UIView()
    
    // MARK: - Life Cycle
    
    override func commonInit() {
        super.commonInit()
        selectionStyle = .none
        configureUI()
    }
    
}

// MARK: - Public API

extension AirportCell {
    
    func setUp(with model: PlacePM) {
        cityLabel.attributedText = model.city
        titleLabel.attributedText = model.airport
        iataLabel.text = model.iata
    }
    
}

// MARK: - Private API

extension AirportCell {
    
    private func configureUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(iataLabel)
        contentView.addSubview(separatorView)
        configureStackView()
        configureIataLabel()
        configureSeparatorView()
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(titleLabel)
        configureCityLabel()
        configureTitleLabel()
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.trailing.greaterThanOrEqualTo(iataLabel.snp.leading).offset(-10)
        }
    }
    
    private func configureCityLabel() {
        cityLabel.font = .systemFont(ofSize: 17)
        cityLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        cityLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        cityLabel.textColor = .primaryTextColor
    }
    
    private func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.textColor = .primaryTextColor
    }
    
    private func configureIataLabel() {
        iataLabel.textAlignment = .right
        iataLabel.textColor = .primaryTextColor
        iataLabel.font = .boldSystemFont(ofSize: 17)
        iataLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.leading.greaterThanOrEqualTo(stackView.snp.trailing).offset(10)
        }
    }
    
    private func configureSeparatorView() {
        separatorView.backgroundColor = .separatorColor
        separatorView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }
    }
    
}

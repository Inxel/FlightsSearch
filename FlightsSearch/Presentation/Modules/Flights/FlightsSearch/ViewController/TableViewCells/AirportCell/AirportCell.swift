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
        titleLabel.attributedText = model.title
        iataLabel.text = model.iata
    }
    
}

// MARK: - Private API

extension AirportCell {
    
    private func configureUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(iataLabel)
        configureStackView()
        configureIataLabel()
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
        cityLabel.textColor = .white
    }
    
    private func configureTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.textColor = .white
    }
    
    private func configureIataLabel() {
        iataLabel.textAlignment = .right
        iataLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.leading.greaterThanOrEqualTo(stackView.snp.trailing).offset(10)
        }
    }
    
}

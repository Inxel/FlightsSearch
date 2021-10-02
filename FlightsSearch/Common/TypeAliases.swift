//
//  TypeAliases.swift
//  FlightsSearch
//
//  Created by Artyom Zagoskin on 28.04.2021.
//

import Foundation

typealias Handler = () -> Void
typealias TypeHandler<T> = (T) -> Void
typealias APIResult<T> = Result<T, Error>

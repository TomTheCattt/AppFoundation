//
//  FeatureViewModelProtocol.swift
//  BaseIOSApp
//

import Foundation
import Combine

protocol FeatureViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<FeatureViewState, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }

    func viewDidLoad()
    func fetchData()
    func refresh()
    func numberOfItems() -> Int
    func item(at index: Int) -> FeatureEntity?
    func didSelectItem(at index: Int)
    func didTapCreate()
    func didTapDelete(at index: Int)
}

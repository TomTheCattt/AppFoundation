//
//  LoginViewModelProtocol.swift
//  AppFoundation
//

import AppFoundation
import Combine
import Foundation

protocol LoginViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<AuthViewState, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    func login(email: String, password: String)
}

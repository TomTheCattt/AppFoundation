//
//  LoginViewModelProtocol.swift
//  AppFoundation
//

import Foundation
import AppFoundation
import Combine

protocol LoginViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<AuthViewState, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    func login(email: String, password: String)
}

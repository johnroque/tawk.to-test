//
//  UsersViewModel.swift
//  GitHubApp
//
//  Created by John Roque Jorillo on 6/27/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// make this events bind with UI events
protocol UsersViewModelInputs {
    func outputs() -> UsersViewModelOutputs
    func getUsers()
    func loadMoreUsers()
    func searchUser(key: String)
}

protocol UsersViewModelOutputs {
    var users: BehaviorRelay<[UserFormatter]> { get }
    var isLoadingMoreUsers: PublishRelay<Bool> { get }
    var shouldShowLoadMore: PublishRelay<Bool> { get }
    var error: PublishRelay<String> { get }
}

class UsersViewModel: UsersViewModelOutputs {
    
    fileprivate var getUsersUseCase: GetUsersUseCase
    
    private var queue = OperationQueue()
    
    init(getUsersUseCase: GetUsersUseCase) {
        self.getUsersUseCase = getUsersUseCase
    }
    
    let users: BehaviorRelay<[UserFormatter]> = BehaviorRelay(value: [])
    let isLoadingMoreUsers: PublishRelay<Bool> = PublishRelay()
    var shouldShowLoadMore: PublishRelay<Bool> = PublishRelay()
    let error: PublishRelay<String> = PublishRelay()
    
    // MARK: - Data properties
    private var _sinceUserId: Int = 0
    private var _users: [UserFormatter] = []
    private var _filteredUsers: [UserFormatter] = []
    private var _isFiltering: Bool = false {
        didSet {
            self.shouldShowLoadMore.accept(!_isFiltering)
        }
    }
    
}

extension UsersViewModel: UsersViewModelInputs {
    
    func outputs() -> UsersViewModelOutputs {
        return self
    }
    
    func getUsers() {
        
        self._sinceUserId = 0
        self._users.removeAll()
        
        self.getUsers(since: self._sinceUserId)
        
    }
    
    func loadMoreUsers() {
        
        self.getUsers(since: self._sinceUserId)
        
    }
    
    private func getUsers(since: Int) {
        
        if _isFiltering { return }
        
        queue.cancelAllOperations()
        queue.qualityOfService = .background
        
        let operation = BlockOperation { [unowned self] in

            let params = GetUsersParameters(since: since)
            
            self.getUsersUseCase.getUsers(params: params) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let users):
                    
                    if let lastUser = users.last {
                        self._sinceUserId = lastUser.id
                    }
                    
                    self._users.append(contentsOf: users.map { UserFormatter(user: $0) })
                    self.users.accept(self._users)
                    self.isLoadingMoreUsers.accept(false)
                
                case .failure(let error):
                    self.error.accept("\(error.localizedDescription)")
                }
                
            }
            
        }
        
        self.queue.addOperation(operation)
    }
    
    func searchUser(key: String) {
        
        if !key.isEmpty {
            self._isFiltering = true
            self._filteredUsers = self._users.filter { (user) -> Bool in
                let usernameMatch = user.getUsername().lowercased().contains(key.lowercased())
                let noteMatch = user.getNotes().lowercased().contains(key.lowercased())
                
                return usernameMatch || noteMatch
            }
            
            self.users.accept(_filteredUsers)
        } else {
            self._isFiltering = false
            self.users.accept(_users)
        }
        
    }
    
}

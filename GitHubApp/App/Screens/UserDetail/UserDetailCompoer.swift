//
//  UserDetailCompoer.swift
//  GitHubApp
//
//  Created by John Roque Jorillo on 6/27/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

final class UserDetailComposer {
    
    private init() {}
    
    static func composeWith(user: UserFormatter) -> UserDetailViewController {
        
        // setup api
        let apiLogger = ApiLogger()
        let apiClient = ApiClientImpl(config: .default, logger: apiLogger)
        let apiGateway = ApiUserGatewayImpl(apiClient: apiClient)
        
        // setup coredata
        let coreDataStack = CoreDataStackImplementation()
        let localGateway = CoreDataGatewayImpl(localPersistence: coreDataStack)
        
        // setup cache middleware
        let cacheGateway = CacheUsersGateway(apiGateway: apiGateway, localPersistence: coreDataStack)
        
        
        let getUserUseCase = GetUserUseCaseImpl(gateway: cacheGateway)
        let noteUseCase = NoteUseCaseImpl(gateway: localGateway)
        
        let vm = UserDetailViewModel(getUserUseCase: getUserUseCase,
                                     noteUseCase: noteUseCase,
                                     user: user)
        
        let vc = UserDetailViewController.initFromNib()
        vc.viewModel = vm
        
        return vc
    }
    
}

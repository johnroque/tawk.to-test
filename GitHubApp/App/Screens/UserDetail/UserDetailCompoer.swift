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
        
        let apiLogger = ApiLogger()
        let apiClient = ApiClientImpl(config: .default, logger: apiLogger)
        let apiGateway = ApiUserGatewayImpl(apiClient: apiClient)
        
        let getUserUseCase = GetUserUseCaseImpl(gateway: apiGateway)
        
        let vm = UserDetailViewModel(getUserUseCase: getUserUseCase, user: user)
        
        let vc = UserDetailViewController.initFromNib()
        vc.viewModel = vm
        
        return vc
    }
    
}
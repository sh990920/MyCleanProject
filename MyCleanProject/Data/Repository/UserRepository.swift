//
//  UserRepository.swift
//  MyCleanProject
//
//  Created by 박승환 on 1/21/25.
//

import Foundation

public struct UserRepository: UserRepositoryProtocol {
    
    private let coreData: UserCoreDataProtocol
    private let network: UserNetworkProtocol
    
    init(coreData: UserCoreDataProtocol, network: UserNetworkProtocol){
        self.coreData = coreData
        self.network = network
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await network.fetchUser(query: query, page: page)
    }
    
    public func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        return coreData.getFavoriteUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        return coreData.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        return coreData.deleteFavoriteUser(userID: userID)
    }
    
}

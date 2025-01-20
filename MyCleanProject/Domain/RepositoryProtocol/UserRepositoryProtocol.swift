//
//  UserListRepositoryProtocol.swift
//  MyCleanProject
//
//  Created by 박승환 on 1/20/25.
//

import Foundation

public protocol UserRepositoryProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError>
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
}

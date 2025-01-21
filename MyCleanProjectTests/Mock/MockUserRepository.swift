//
//  MockUserRepository.swift
//  MyCleanProjectTests
//
//  Created by 박승환 on 1/21/25.
//

import Foundation
@testable import MyCleanProject

class MockUserRepository: UserRepositoryProtocol {
    func fetchUser(query: String, page: Int) async -> Result<MyCleanProject.UserListResult, MyCleanProject.NetworkError> {
        .failure(.dataNil)
    }
    
    func getFavoriteUsers() -> Result<[MyCleanProject.UserListItem], MyCleanProject.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    func saveFavoriteUser(user: MyCleanProject.UserListItem) -> Result<Bool, MyCleanProject.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    func deleteFavoriteUser(userID: Int) -> Result<Bool, MyCleanProject.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    
}

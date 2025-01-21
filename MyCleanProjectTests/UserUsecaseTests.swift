//
//  UserUsecaseTests.swift
//  MyCleanProjectTests
//
//  Created by 박승환 on 1/21/25.
//

import XCTest
@testable import MyCleanProject

final class UserUsecaseTests: XCTestCase {

    var usecase: UserListUsecaseProtocol!
    var repository: UserRepositoryProtocol!
    override func setUp() {
        super.setUp()
        repository = MockUserRepository()
        usecase = UserListUsecase(repository: repository)
    }
    
    func testCheckfavoriteState() {
        let favoriteUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 2, login: "user2", imageURL: "")
        ]
        let fetchUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 3, login: "user3", imageURL: "")
        ]
        let result = usecase.checkFavoriteState(fetchUsers: fetchUsers, favoriteUsers: favoriteUsers)
        XCTAssertEqual(result[0].isFavorite, true)
        XCTAssertEqual(result[1].isFavorite, false)
    }
    
    func testConvertListToDictonary() {
        let users = [
            UserListItem(id: 1, login: "Alice", imageURL: ""),
            UserListItem(id: 2, login: "Bob", imageURL: ""),
            UserListItem(id: 3, login: "Charlie", imageURL: ""),
            UserListItem(id: 4, login: "ash", imageURL: ""),
            UserListItem(id: 5, login: "Anny", imageURL: "")
        ]
        let result = usecase.convertListToDictonary(favoriteUsers: users)
        
        XCTAssertEqual(result.keys.count, 3)
        XCTAssertEqual(result["A"]?.count, 3)
        XCTAssertEqual(result["B"]?.count, 1)
        XCTAssertEqual(result["C"]?.count, 1)
    }
    
    override func tearDown() {
        repository = nil
        usecase = nil
        super.tearDown()
    }

}

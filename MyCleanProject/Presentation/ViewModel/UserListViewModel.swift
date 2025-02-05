//
//  UserListViewModel.swift
//  MyCleanProject
//
//  Created by 박승환 on 2/5/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserListViewModelProtocol {
    
}

public final class UserListViewModel: UserListViewModelProtocol {
    private let usecase: UserListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // fetchUser 즐겨찾기 여부를 위한 전처 목록
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: []) // 목록에 보여줄 리스트
    private var page: Int = 1
    
    public init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    // 이벤트(VC) -> 가공 or 외부에서 데이터 호출 or 뷰 데이터를 전달(VM) -> VC
    public struct Input { // VM에게 전달 되어야 할 이벤트
        // 탭, 텍스트필드, 즐겨찾기 추가 or 삭제, 페이지네이션 observable
        let tabButtonType: Observable<TabButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
    }
    public struct Output { // VC 에게 전달할 뷰 데이터
        // cell data (유저 리스트)
        // error
        let cellData: Observable<[UserListCellData]>
        let error: Observable<String>
    }
    
    // 상단 텍스트 필드
    // 하단 API탭 / 즐겨찾기 탭
    
    public func transform(input: Input) -> Output { // VC이벤트 -> VM데이터
        input.query.bind { [weak self] query in //
            //TODO: user Fetch and get favorite Users
            guard let self = self, validateQeury(qurey: query) else {
                self?.getFavoriteUsers(query: "")
                return
            }
            page = 1
            fetchUser(query: query, page: page)
            getFavoriteUsers(query: query)
        }.disposed(by: disposeBag)
        
        input.saveFavorite
            .withLatestFrom(input.query, resultSelector: { users, query in
            return (users, query)
            })
            .bind{ [weak self] user, query in
            //TODO: 즐겨찾기 추가
            self?.saveFavoriteUser(user: user, query: query)
        }.disposed(by: disposeBag)
        
        input.deleteFavorite
            .withLatestFrom(input.query, resultSelector: { ($0, $1) })
            .bind { [weak self] userID, query in
            //TODO: 즐겨찾기 삭제
                self?.deleteFavoriteUser(userID: userID, query: query)
        }.disposed(by: disposeBag)
        
        input.fetchMore
            .withLatestFrom(input.query)
            .bind { [weak self] query in
            //TODO: 다음 페이지 검색
                guard let self = self else { return }
                self.page += 1
                self.fetchUser(query: query, page: page)
        }.disposed(by: disposeBag)
        
        // 탭 -> api 유저 or 즐겨찾기 유저
        // 탭 유저리스트, 즐겨찾기 리스트
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList).map { [weak self] tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList in
            var cellData: [UserListCellData] = []
            guard let self = self else { return cellData }
            
            
            //TODO: cellData 생성
            // Tab 타입에 따라 fetchUserList / favoriteUserList
            switch tabButtonType {
            case .api:
                let tuple = usecase.checkFavoriteState(fetchUsers: fetchUserList, favoriteUsers: allFavoriteUserList)
                let userCellList = tuple.map { user, isFavorite in
                    UserListCellData.user(user: user, isFavorite: isFavorite)
                }
                return userCellList
            case .favorite:
                let dict = usecase.convertListToDictonary(favoriteUsers: favoriteUserList)
                let keys = dict.keys.sorted()
                keys.forEach { key in
                    cellData.append(.header(key))
                    if let users = dict[key] {
                        cellData += users.map { UserListCellData.user(user: $0, isFavorite: true) } 
                    }
                }
            }
            return cellData
        }
        
        return Output(cellData: cellData, error: error.asObservable())
    }
    
    private func fetchUser(query: String, page: Int) {
        guard let urlAllowdQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        Task {
            let result = await usecase.fetchUser(query: query, page: page)
            switch result {
            case let .success(users):
                if page == 0 {
                    // 첫번째 페이지
                    fetchUserList.accept(users.items)
                } else {
                    // 두번째 그 이상 페이지
                    fetchUserList.accept(fetchUserList.value + users.items)
                }
            case let .failure(error):
                self.error.accept(error.description)
            }
        }
    }
    
    private func getFavoriteUsers(query: String) {
        let result = usecase.getFavoriteUsers()
        switch result {
        case .success(let users):
            if query.isEmpty {
                // 전체 리스트
                favoriteUserList.accept(users)
            } else {
                // 검색어가 있을 때 필터링
                let filteredUsers = users.filter { user in
                    user.login.contains(query)
                }
                favoriteUserList.accept(filteredUsers)
            }
            allFavoriteUserList.accept(users)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func saveFavoriteUser(user: UserListItem, query: String) { //입력값이 있을수도 있고 없을수도 있다.
        let result = usecase.saveFavoriteUser(user: user)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func deleteFavoriteUser(userID: Int, query: String) {
        let result = usecase.deleteFavoriteUser(userID: userID)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }
    
    private func validateQeury(qurey: String) -> Bool {
        if qurey.isEmpty {
            return false
        } else {
            return true
        }
    }
}

public enum TabButtonType {
    case api
    case favorite
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}

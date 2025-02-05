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
    
    public func transform(input: Input) -> Output { // VC이벤트 -> VM데이터
        input.query.bind { query in
            //TODO: 상황에 맞춰서 user Fetch or get favorite Users
        }.disposed(by: disposeBag)
        
        input.saveFavorite.bind{ user in
            //TODO: 즐겨찾기 추가
        }.disposed(by: disposeBag)
        
        input.deleteFavorite.bind { userID in
            //TODO: 즐겨찾기 삭제
        }.disposed(by: disposeBag)
        
        input.fetchMore.bind {
            //TODO: 다음 페이지 검색
        }.disposed(by: disposeBag)
        
        // 탭 -> api 유저 or 즐겨찾기 유저
        // 탭 유저리스트, 즐겨찾기 리스트
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList).map { tabButtonType, fetchUserList, favoriteUserList in
            let cellData: [UserListCellData] = []
            //TODO: cellData 생성
            return cellData
        }
        
        return Output(cellData: cellData, error: error.asObservable())
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

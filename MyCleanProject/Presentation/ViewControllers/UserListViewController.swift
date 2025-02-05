//
//  ViewController.swift
//  MyCleanProject
//
//  Created by 박승환 on 1/20/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    private let viewModel: UserListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let saveFavorite = PublishRelay<UserListItem>()
    private let deleteFavorite = PublishRelay<Int>()
    private let fetchMore = PublishRelay<Void>()
    private let searchTextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 6
        textField.placeholder = "검색어를 입력해 주세요"
        let image = UIImageView(image: .init(systemName: "magnifyingglass"))
        image.frame = .init(x: 0, y: 0, width: 20, height: 20)
        textField.leftView = image
        textField.leftViewMode = .always
        textField.tintColor = .black
        return textField
    }()
    
    private let tabButtonView = TabButtonView(tabList: [.api, .favorite])
    
    private let tableView = {
        let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.id)
        return tableView
    }()
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setUI()
        bindView()
        bindViewModel()
    }
    
    private func setUI() {
        view.addSubview(searchTextField)
        view.addSubview(tabButtonView)
        view.addSubview(tableView)
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        tabButtonView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(tabButtonView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindView() {
        
    }
    
    private func bindViewModel() {
        let tabButtonType = tabButtonView.selectedType.compactMap { $0 }
        let query = searchTextField.rx.text.orEmpty.debounce(.milliseconds(300), scheduler: MainScheduler.instance) // 입력을 하다 마지막것만 사용하기 위해서 사용
        let output = viewModel.transform(input: UserListViewModel.Input(tabButtonType: tabButtonType, query: query, saveFavorite: saveFavorite.asObservable(), deleteFavorite: deleteFavorite.asObservable(), fetchMore: fetchMore.asObservable()))
        
        output.cellData.bind(to: tableView.rx.items) { tableView, index, cellData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.id) else { return UITableViewCell() }
            (cell as? UserTableViewCell)?.apply(cellData: cellData)
            return cell
        }.disposed(by: disposeBag)
        
        output.error.bind { [weak self] errorMessage in
            let alert = UIAlertController(title: "에러", message: errorMessage, preferredStyle: .alert)
            alert.addAction(.init(title: "확인", style: .default))
            DispatchQueue.main.async {
                self?.present(alert, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


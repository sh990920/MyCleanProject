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
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setUI()
        bindView()
    }
    
    private func setUI() {
        view.addSubview(searchTextField)
        view.addSubview(tabButtonView)
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
    }
    
    private func bindView() {
        tabButtonView.selectedType.bind { type in
            print("Type \(type)")
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

final class TabButtonView: UIStackView {
    
    private let tabList: [TabButtonType]
    private let disposeBag = DisposeBag()
    public let selectedType: BehaviorRelay<TabButtonType?>
    
    init(tabList: [TabButtonType]) {
        self.tabList = tabList
        self.selectedType = BehaviorRelay(value: tabList.first)
        super.init(frame: .zero)
        alignment = .fill
        distribution = .fillEqually
        addButtons()
        (arrangedSubviews.first as? UIButton)?.isSelected = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addButtons() {
        tabList.forEach { tabType in
            let button = TabButton(type: tabType)
            button.rx.tap.bind { [weak self] in
                self?.arrangedSubviews.forEach{ view in
                    (view as? UIButton)?.isSelected = false
                }
                button.isSelected = true
                self?.selectedType.accept(tabType)
            }.disposed(by: disposeBag)
            addArrangedSubview(button)
        }
    }
}

final class TabButton: UIButton {
    private let type: TabButtonType
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .systemCyan
            } else {
                backgroundColor = .white
            }
        }
    }
    
    init(type: TabButtonType) {
        self.type = type
        super.init(frame: .zero)
        setTitle(type.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

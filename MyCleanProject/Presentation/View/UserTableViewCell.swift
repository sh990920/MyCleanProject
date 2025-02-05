//
//  UserTableViewCell.swift
//  MyCleanProject
//
//  Created by 박승환 on 2/5/25.
//

import Foundation
import UIKit
import UIKit
import Kingfisher

public final class UserTableViewCell: UITableViewCell {
    static let id = "UserTableViewCell"
    private let userImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(userImageView)
        addSubview(nameLabel)
        userImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(80)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(cellData: UserListCellData) {
        guard case let .user(user, isFavorite) = cellData else { return }
        userImageView.kf.setImage(with: URL(string: user.imageURL))
        nameLabel.text = user.login
    }
}

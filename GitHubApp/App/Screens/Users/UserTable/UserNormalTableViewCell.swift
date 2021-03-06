//
//  UserNormalTableViewCell.swift
//  GitHubApp
//
//  Created by John Roque Jorillo on 6/29/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import Combine

class UserNormalTableViewCell: UITableViewCell, UserCell {
    
    // MARK: Properties
    var imageRequest: AnyCancellable?

    // MARK: - UI Properties
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var userImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var notesImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "ic-pen")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImage.image = nil
        notesImage.isHidden = true
        self.imageRequest?.cancel()
    }
    
    private func setupViews() {
        
        self.selectionStyle = .none
        
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        containerStackView.addArrangedSubview(userImage)
        
        NSLayoutConstraint.activate([
            userImage.widthAnchor.constraint(equalToConstant: 60),
            userImage.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        userImage.setRadius(radius: 30)
        
        detailsStackView.addArrangedSubview(usernameLabel)
        detailsStackView.addArrangedSubview(urlLabel)
        containerStackView.addArrangedSubview(detailsStackView)
        
        contentView.addSubview(notesImage)
        
        NSLayoutConstraint.activate([
            notesImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            notesImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            notesImage.widthAnchor.constraint(equalToConstant: 20),
            notesImage.heightAnchor.constraint(equalToConstant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: notesImage.leadingAnchor, constant: -8)
        ])
        
        notesImage.isHidden = true
        
    }
    
    func configureWith(_ data: UserCellViewModel) {
        
        userImage.shimmer()
        
        self.usernameLabel.text = data.getUsername()
        self.urlLabel.text = data.getProfileUrl()
        
        if let url = URL(string: data.getAvatarUrl()) {
            self.imageRequest = ImageLoader.shared.loadImage(from: url).sink { [unowned self] (image) in
                
                self.userImage.removeShimmer()
                self.userImage.image = image
                
            }
        }
        
    }
    
}


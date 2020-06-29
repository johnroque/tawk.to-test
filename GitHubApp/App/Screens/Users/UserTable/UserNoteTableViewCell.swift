//
//  UserNoteTableViewCell.swift
//  GitHubApp
//
//  Created by John Roque Jorillo on 6/29/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import Combine

class UserNoteTableViewCell: UserNormalTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureWith(_ data: UserCellViewModel) {
        
        userImage.shimmer()
        
        self.usernameLabel.text = data.getUsername()
        self.urlLabel.text = data.getProfileUrl()
        
        if let url = URL(string: data.getAvatarUrl()) {
            self.imageRequest = ImageLoader.shared.loadImage(from: url).sink { [unowned self] (image) in
                
                self.userImage.removeShimmer()
                self.userImage.image = image
            }
        }
        
        notesImage.isHidden = false
        
    }
        
}

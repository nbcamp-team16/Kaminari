//
//  SearchTableHeaderView.swift
//  Kaminari
//
//  Created by 보경 on 2023/09/28.
//

import UIKit
import SnapKit

class SearchTableHeader: UITableViewHeaderFooterView {
    
    let view = UIView()
    let searchField = UITextField()
    
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: "searchTableHeader")
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        view.layer.opacity = 0
        addSubview(self.view)
        self.view.backgroundColor = .systemBackground
        self.view.layer.opacity = 1
        self.view.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 60))
        }
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: self.frame.height))
        let leftPaddingIcon = UIImageView()
        
        leftPaddingIcon.image = UIImage(systemName: "magnifyingglass")
        leftPaddingView.addSubview(leftPaddingIcon)
        leftPaddingIcon.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
        
        searchField.leftView = leftPaddingView
        searchField.leftViewMode = .always
        
        searchField.clearButtonMode = .whileEditing
        searchField.returnKeyType = .done
    
        searchField.layer.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1).cgColor
        searchField.layer.cornerRadius = 10
        searchField.placeholder = "도시 또는 공항 검색"
        self.view.addSubview(searchField)
        searchField.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width - 40, height: 50))
        }
    }
}


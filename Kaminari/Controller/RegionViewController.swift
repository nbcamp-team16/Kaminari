//
//  RegionViewController.swift
//  Kaminari
//
//  Created by (^ㅗ^)7 iMac on 2023/09/25.
//

import SnapKit
import UIKit

class RegionViewController: UIViewController {
    let testButton = CustomButton(frame: .zero)

    deinit {
        print("### ViewController deinitialized")
    }
}

extension RegionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTestButton()
    }

    func configureTestButton() {
        view.addSubview(testButton)
        testButton.configure(title: "TEST", fontSize: 20, font: .bold)
        testButton.setupButtonUI(cornerValue: 10, background: .systemBlue, fontColor: .white)
        testButton.addTarget(self, action: #selector(tappedTestButton), for: .touchUpInside)

        testButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(60)
        }
    }

    @objc func tappedTestButton(_ sender: UIButton) {
        print("### \(#function)")
    }
}

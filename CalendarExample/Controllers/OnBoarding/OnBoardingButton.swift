//
//  OnBoardingButton.swift
//  CalendarExample
//
//  Created by admin on 04.02.2024.
//

import UIKit

final class OnBoardingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.addTarget(self, action: #selector(didTap), for: .touchDown)
        self.addTarget(self, action: #selector(didUntap), for: .touchUpInside)
    }
    
    private func setupButton() {
        setTitleColor(.white, for: .normal)
        setTitleColor(.lightGray, for: .disabled)
        backgroundColor = .black
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    @objc private func didTap() {
        self.alpha = 0.7
    }
    @objc private func didUntap() {
        self.alpha = 1.0
    }
}

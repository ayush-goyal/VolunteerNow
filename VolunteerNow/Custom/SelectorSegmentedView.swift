//
//  SelectorSegmentedView.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 1/15/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

class SelectorSegmentedView: UIControl {
    
    let highlightColor: UIColor
    let normalColor: UIColor
    let titles: [String]
    let images: [UIImage]
    var buttons: [UIButton] = []
    
    let width: CGFloat
    
    var selector = UIView()
    var selectedSegmentIndex = 0
    var selectorConstraint: NSLayoutConstraint!
    
    var changeView: (SelectorSegmentedView) -> Void
    
    init(normalColor: UIColor, highlightColor: UIColor, titles: [String], images: [UIImage], width: CGFloat, changeView: @escaping (SelectorSegmentedView) -> Void) {
        self.highlightColor = highlightColor
        self.normalColor = normalColor
        self.titles = titles
        self.images = images
        self.width = width
        self.changeView = changeView
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        createSubViews()
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        guard titles.count == images.count else { fatalError("Titles is not equal to number of images") }
        for index in 0..<titles.count {
            let button = UIButton()
            button.setTitle(titles[index], for: .normal)
            button.setTitleColor(normalColor, for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0) // Space out image from text
            button.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0) // Account for font
            button.titleLabel?.font = UIFont(name: "SofiaPro-Medium", size: 17)
            
            button.setImage(images[index].withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = normalColor
            
            button.addTarget(self, action: #selector(buttonClicked(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(highlightColor, for: .normal)
        buttons[0].tintColor = highlightColor
    }
    
    func updateView() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
        selector.backgroundColor = highlightColor
        selector.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(selector)
        selector.widthAnchor.constraint(equalToConstant: width/CGFloat(titles.count)).isActive = true
        selector.heightAnchor.constraint(equalToConstant: 5).isActive = true
        selector.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        selectorConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: selector, attribute: .left, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([selectorConstraint])
    }
    
    @objc func buttonClicked(button selectedButton: UIButton) {
        for (index, button) in buttons.enumerated() {
            if button == selectedButton {
                selectedSegmentIndex = index
                
                self.selectorConstraint.constant = -(width/CGFloat(titles.count)) * CGFloat(index) // Negative needed because selector constraint relates self to selector backwards
                UIView.animate(withDuration: 0.4, animations: {
                    self.layoutIfNeeded()
                    button.setTitleColor(self.highlightColor, for: .normal)
                    button.tintColor = self.highlightColor
                })
            } else {
                button.setTitleColor(normalColor, for: .normal)
                button.tintColor = normalColor
            }
        }
        
        changeView(self)
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

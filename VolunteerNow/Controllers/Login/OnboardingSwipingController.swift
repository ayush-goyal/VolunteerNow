//
//  OnboardingSwipingController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 3/3/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "onboardingCell"

class OnboardingSwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let pages = [OnboardingPage(headerText: "Find events near you", bodyText: "Based on your location, we help find the best volunteer events for you based on location proximity."), OnboardingPage(headerText: "View your past and upcoming events", bodyText: "All your previously attended and upcoming events are saved in the app. Show off all your hard work and prepare for more to come.")]
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "SofiaPro-Bold", size: 16)!
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        changeCurrentPage(toPage: nextIndex)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "SofiaPro-Bold", size: 16)!
        button.setTitleColor(UIColor.Custom.purple, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        changeCurrentPage(toPage: nextIndex)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor.Custom.purple
        pc.pageIndicatorTintColor = UIColor.Custom.lightGray
        return pc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(OnboardingPageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.isPagingEnabled = true

        changeBackNavigationButton()
        setupBottomControls()
    }
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        changeCurrentPage(toPage: Int(x / view.frame.width))
        
    }
    
    func changeCurrentPage(toPage page: Int) {
        pageControl.currentPage = page
        
        if (page == pageControl.numberOfPages - 1) {
            nextButton.setTitle("DONE", for: .normal)
            nextButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        } else {
            nextButton.setTitle("NEXT", for: .normal)
            nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
            nextButton.removeTarget(self, action: #selector(handleDone), for: .touchUpInside)
        }
    }
    
    @objc private func handleDone() {
        print("segue")
        performSegue(withIdentifier: "showSignInSegue", sender: nil)
    }
    
}
extension OnboardingSwipingController {

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OnboardingPageCell
    
        cell.onboardingPage = pages[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

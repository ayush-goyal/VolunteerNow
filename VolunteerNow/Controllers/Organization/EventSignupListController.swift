//
//  EventSignupListController.swift
//  VolunteerNow
//
//  Created by Ayush Goyal on 3/3/18.
//  Copyright © 2018 Summit Labs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class EventSignupListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.Custom.purple
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshControl
    }()
    
    var signupNames: [String] = []
    
    var eventId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(EventSignupCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        loadData()
        
        navigationItem.title = "Signup List"
        collectionView?.backgroundColor = .white
        
        addShadowToBar()
        addShadowToTabBar()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.addSubview(refresher)
    }
    
    @objc func loadData() {
        App.shared.dbRef.child("event-users").child(String(eventId)).child("uid").observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? NSArray {
                self.retrieveNames(keys: value) { names in
                    self.signupNames = names
                    self.collectionView?.reloadData()
                    self.refresher.endRefreshing()
                }
            }
        }
    }
    
    func retrieveNames(keys: NSArray, completionHandler: @escaping ([String]) -> Void) {
        let group = DispatchGroup()
        var names: [String] = []
        print(keys)
        for key in keys {
            let key = String(describing: key)
            group.enter()
            App.shared.dbRef.child("users").child(key).child("name").observeSingleEvent(of: .value) { snapshot in
                let value = snapshot.value as! String
                names.append(value)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completionHandler(names)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return signupNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EventSignupCell
        
        cell.nameLabel.text = signupNames[indexPath.row]
    
        return cell
    }
    
    // MARK: UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width-20, height: 50) // Subtract left and right collection view section insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

}
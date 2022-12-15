//
//  ViewController.swift
//  musicspace
//
//  Created by Marina Roshchupkina on 14.12.2022.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        let main = UIHostingController(rootView: MainScreenView(model: MainScreenModel(onPlusTap: openCollection, onSavedTap: openSaved)))
        addChild(main)
        main.view.frame = view.bounds
        view.addSubview(main.view)
       
    }
    
    func openCollection() {
        let collection = UIHostingController(rootView: CollectionView())
        navigationController!.pushViewController(collection, animated: true)
    }
    
    func openSaved() {
        let saved = UIHostingController(rootView: SavedView())
        navigationController!.pushViewController(saved, animated: true)
    }
}


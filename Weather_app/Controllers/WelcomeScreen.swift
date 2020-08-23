//
//  WelcomeScreen.swift
//  Weather_app
//
//  Created by Егор on 16.08.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import UIKit

class WelcomeScreen: UIViewController {
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to the weather app!"
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    let buttonToStartSearch: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap to start searching", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(transitionBetweenViews), for: .touchUpInside)
        button.accessibilityIdentifier = "button"
        return button
    }()
    
    let imageView: UIImageView? = {
        let image: UIImage = UIImage(named: "Climate-Change-and-the-New-Language-of-Weather-800x450.jpg")!
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc func transitionBetweenViews() {
        self.navigationController?.pushViewController(ViewController(),animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "WelcomeScreen"

        setupViews()
        layoutViews()
    }
    
    func setupViews() {
        view.addSubview(imageView!)
        view.addSubview(welcomeLabel)
        view.addSubview(buttonToStartSearch)
    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            imageView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView!.heightAnchor.constraint(equalToConstant: 250),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            welcomeLabel.bottomAnchor.constraint(equalTo: imageView!.topAnchor, constant: -30),
            buttonToStartSearch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonToStartSearch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            buttonToStartSearch.topAnchor.constraint(equalTo: imageView!.bottomAnchor,constant: 40)
        ])
    }
}



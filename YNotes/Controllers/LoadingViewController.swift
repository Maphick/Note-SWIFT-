//
//  LoadingViewController.swift
//  GetGists
//
//  Created by Dzhek on 09/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    private lazy var backgroundView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .none
        self.setupView()
        self.setupActivityIndicator()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // We use a 0.5 second delay to not show an activity indicator
        // in case our data loads very quickly.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self?.backgroundView.backgroundColor = UIColor.white
                self?.activityIndicator.startAnimating()
            })
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        DispatchQueue.main.async() { [weak self] in
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                self?.backgroundView.backgroundColor = UIColor(white: 1, alpha: 0)
//            })
//        }
//    }
    
    private func setupView() {
        
        backgroundView.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backgroundView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            self.backgroundView.heightAnchor.constraint(equalToConstant: self.view.frame.height),
            self.backgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.backgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
    }
    
    private func setupActivityIndicator() {
        
        self.backgroundView.addSubview(activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let constantAnchor = self.view.frame.height / 3
        NSLayoutConstraint.activate ([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constantAnchor)
            ])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    func add(_ child: UIViewController) {
        self.addChild(child)
        DispatchQueue.main.async() { [weak self] in
            self?.view.addSubview(child.view)
            child.didMove(toParent: self)
        }
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard self.parent != nil else { return }
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

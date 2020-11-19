//
//  CongratsVC.swift
//  FinancialElephant
//
//  Created by Davit Ghushchyan on 11/19/20.
//

import UIKit
import SwiftyMDLib
import Lottie

class CongratsVC: BaseViewController {
    @IBOutlet weak var imgWiner: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    var animationView:  AnimationView!
    
    var company: Company!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgWiner.image = UIImage(named: company.imgURL)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
////        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnBack.applyCornerRadius(btnBack.bounds.height / 2 )
        btnBack.layer.applySketchShadow()
        setAnimation()
    }
    
    @IBAction func backTap() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setAnimation() {
        if animationView != nil {
            return
        }
        let animation = Animation.named("congratulations")!
        
        animationView = .init(animation: animation)
        animationView.frame = view.bounds
        view.addSubview(animationView)
        animationView.isUserInteractionEnabled = false
//        animationView.mdLayout.setBottom(anchor: view.bottomAnchor, type: .equal(constant: 0))
//        animationView.mdLayout.setLeading(anchor: view.leadingAnchor, type: .equal(constant: 0))
//        animationView.mdLayout.setTrailing(anchor: view.trailingAnchor, type: .equal(constant: 0))
        animationView.loopMode = .loop
        animationView.play()
        view.bringSubviewToFront(btnBack)
    }
    
}

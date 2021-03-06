//
//  ViewController.swift
//  FinancialElephant
//
//  Created by Davit Ghushchyan on 11/18/20.
//

import UIKit
import SwiftyMDLib

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.resizeSubViewConstraints(view: view)
        UIView.scaleSubViewsFontSizes(view: view)
    }
}


class ViewController: BaseViewController {
    @IBOutlet weak var btnChooseAttributes: UIButton!
    @IBOutlet weak var btnChooseCompany: UIButton!
    @IBOutlet weak var btnStartCount: UIButton!
    
    var model: Source!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        navigationController?.navigationBar.tintColor = UIColor(named: "buttonColor")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnChooseAttributes.applyCornerRadius(btnChooseAttributes.bounds.height/2)
        btnChooseAttributes.layer.applySketchShadow()
        btnChooseCompany.applyCornerRadius(btnChooseCompany.bounds.height/2)
        btnChooseCompany.layer.applySketchShadow()
        btnStartCount.applyCornerRadius(btnStartCount.bounds.height/2)
        btnStartCount.layer.applySketchShadow()
    }

    
    @IBAction func companyAction() {
        let vc = instantiateController(withIdentifier: DialogViewController.id) as! DialogViewController
        present(vc, animated: true, completion: nil)
        vc.type = .companies
        vc.model = model
    }
    
    @IBAction func attributesAction() {
        let vc = instantiateController(withIdentifier: DialogViewController.id) as! DialogViewController
        present(vc, animated: true, completion: nil)
        vc.type = .attributes
        vc.model = model
    }
    
    @IBAction func startAction() {
        let vc = instantiateController(withIdentifier: ComparingItemsController.id) as! ComparingItemsController
        vc.model = self.model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func readData() {
        if let path = Bundle.main.path(forResource: "full_values", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let result = try decoder.decode(Source.self, from: data)
                model = result
            } catch {
                
            }
        }
    }
    
    
    
}


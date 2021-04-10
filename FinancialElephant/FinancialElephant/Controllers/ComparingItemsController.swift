//
//  ComparingItemsController.swift
//  FinancialElephant
//
//  Created by Davit Ghushchyan on 11/19/20.
//

import UIKit
import SwiftyMDLib

class ComparingItemsController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var model: Source! {
        didSet {
            companies = model.companies.filter({$0.isChoosed ?? true})
        }
    }
    var companies = [Company]()
    
    var isFirstSizeSet = true
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstSizeSet {
            isFirstSizeSet = false
            let layout = PagingCollectionViewLayout()
            var size = collectionView.frame.size
            layout.scrollDirection = .horizontal
            //        size.width -= 80
            size.height -= 50.scaled
            layout.itemSize = size
            layout.numberOfItemsPerPage = 1
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            collectionView.collectionViewLayout = layout
            collectionView.reloadData()
        }
        btnConfirm.applyCornerRadius(btnConfirm.bounds.height/2)
        btnConfirm.layer.applySketchShadow()
    }
    
    @IBAction func start() {
        let company = model.solve()
        
        let vc = instantiateController(withIdentifier: CongratsVC.id) as! CongratsVC
        vc.company = company
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ComparingItemsController: UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompareCell.id, for: indexPath) as! CompareCell
        let item = companies[indexPath.row]
        cell.imgCompany.image = UIImage(named: item.imgURL)
        cell.configureWith(model.attributeComparing, model: item)
        
        //        cell.contentView.backgroundColor = .systemFill
        return cell
    }
    
}



class CompareCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imgCompany: UIImageView!
    // ______
    @IBOutlet weak var revenueAttView: AttributeView!
    @IBOutlet weak var paidusAttView: AttributeView!
    @IBOutlet weak var mauAttView: AttributeView!
    @IBOutlet weak var urrAttView: AttributeView!
    @IBOutlet weak var testAttView: AttributeView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.clipsToBounds = true
        baseView.applyCornerRadius(15.scaled)
    }
    
    func configureWith(_ attributes: AttributeComparing, model: Company) {
        revenueAttView.isHidden = !(attributes.isRevenue ?? true)
        revenueAttView.lblValue.text = model.Revenue.description
        
        paidusAttView.isHidden = !(attributes.isPaid_Users ?? true)
        paidusAttView.lblValue.text = model.Paid_Users.description
        
        mauAttView.isHidden = !(attributes.isMAU ?? true)
        mauAttView.lblValue.text = model.MAU.description
        
        urrAttView.isHidden = !(attributes.isRetention_Rate ?? true)
        urrAttView.lblValue.text = model.Retention_Rate.description
        
        testAttView.isHidden = !(attributes.isTarget_Market ?? true)
        testAttView.lblValue.text = model.Target_Market.description
        
        
    }
    
}

class AttributeView: UIView {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
}

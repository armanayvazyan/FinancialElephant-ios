//
//  DialogViewController.swift
//  FinancialElephant
//
//  Created by Davit Ghushchyan on 11/18/20.
//

import UIKit

class DialogViewController: BaseViewController {
    enum DialogType {
        case companies
        case attributes
        
        var title:String {
            switch self {
            case .attributes:
                return "Choose Attributes"
            case .companies:
                return "Choose Company"
            }
        }
    }
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var baseVIew: UIView!
    @IBOutlet weak var visualView: UIVisualEffectView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var model: Source?
    var type = DialogType.companies {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblHeader.text = type.title
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseVIew.applyCornerRadius(15.scaled)
        btnClose.applyCornerRadius(btnClose.bounds.height/2)
        btnClose.layer.applySketchShadow()
    }
    
    @IBAction func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension DialogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else {return 0}
        
        if type == .companies {
            return model.companies.count
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.id, for: indexPath) as! AttributeCell
        
        switch type {
        case .attributes:
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Revenue"
                cell.toggle.isOn = model?.attributeComparing.isRevenue ?? true
                cell.switchAction = { isOn in
                    self.model?.attributeComparing.isRevenue = isOn
                }
                
            case 1:
                cell.lblTitle.text = "Paid Users"
                cell.toggle.isOn = self.model?.attributeComparing.isPaid_Users ?? true
                cell.switchAction = { isOn in self.model?.attributeComparing.isPaid_Users = isOn
                }
            case 2:
                cell.lblTitle.text = "MAU"
                cell.toggle.isOn = model?.attributeComparing.isMAU ?? true
                cell.switchAction = { isOn in
                    self.model?.attributeComparing.isMAU = isOn
                }
            case 3:
                cell.lblTitle.text = "Retention rate"
                cell.toggle.isOn = model?.attributeComparing.isRetention_Rate ?? true
                cell.switchAction = { isOn in
                    self.model?.attributeComparing.isRetention_Rate = isOn
                }
            case 4:
                cell.lblTitle.text = "Target Market"
                cell.toggle.isOn = model?.attributeComparing.isTarget_Market ?? true
                cell.switchAction = { isOn in
                    self.model?.attributeComparing.isTarget_Market = isOn
                }
            default:
                break
            }
        case .companies:
            cell.lblTitle.text = model?.companies[indexPath.row].name
            cell.toggle.isOn = model?.companies[indexPath.row].isChoosed ?? true
            cell.switchAction = { isOn in
                self.model?.companies[indexPath.row].isChoosed = isOn
            }
        }
        
        
        
        return cell
    }
    
    
}


class AttributeCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    var switchAction: ((Bool)->())?
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBAction func toggleDidChangeValue(_ sender:UISwitch) {
        switchAction?(sender.isOn)
    }
    
}

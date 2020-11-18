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
                cell.lblTitle.text = "revenue"
                cell.toggle.isOn = model?.companies[0].isChoosed ?? true
                cell.switchAction = { isOn in
                    self.model?.companies[0].isChoosed = isOn
                }
                
            case 1:
                cell.lblTitle.text = "paidusers"
                cell.toggle.isOn = model?.companies[0].isChoosed ?? true
                cell.switchAction = { isOn in
                    self.model?.companies[0].isChoosed = isOn
                }
            case 2:
                cell.lblTitle.text = "mau"
                cell.toggle.isOn = model?.companies[0].isChoosed ?? true
                cell.switchAction = { isOn in
                    self.model?.companies[0].isChoosed = isOn
                }
            case 3:
                cell.lblTitle.text = "urr"
                cell.toggle.isOn = model?.companies[0].isChoosed ?? true
                cell.switchAction = { isOn in
                    self.model?.companies[0].isChoosed = isOn
                }
            case 4:
                cell.lblTitle.text = "test"
                cell.toggle.isOn = model?.companies[0].isChoosed ?? true
                cell.switchAction = { isOn in
                    self.model?.companies[0].isChoosed = isOn
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

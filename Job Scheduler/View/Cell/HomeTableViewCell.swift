//
//  HomeTableViewCell.swift
//  Job Scheduler
//
//  Created by Nadeer C K on 3/11/24.
//

import UIKit

protocol HomeViewCellDelegate : class {
    func didCompletedButtonPress(_ tag: Int)
    func didIncompletedButtonPress(_ tag: Int)
}

class HomeTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var dueDateLbl: UILabel!
    @IBOutlet weak var inCompleteBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    
    var cellDelegate: HomeViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: IBActions
    @IBAction func incompleteBtnClick(_ sender: UIButton) {
       
        self.cellDelegate?.didIncompletedButtonPress(sender.tag)
        self.completedBtn.setImage(UIImage(named: "radio"), for: .normal)
        self.inCompleteBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
    }
    
    @IBAction func completedBtnClick(_ sender: UIButton) {
       
        self.cellDelegate?.didCompletedButtonPress(sender.tag)
        self.completedBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
        self.inCompleteBtn.setImage(UIImage(named: "radio"), for: .normal)
    }
}

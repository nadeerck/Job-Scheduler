//
//  DetailViewController.swift
//  Job Scheduler
//
//  Created by Nadeer C K on 3/11/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var dueDatetxtField: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var inProgressbtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    
    var data: Task?
    let detailViewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        configure()
    }
    
    func initViews() {
        guard let data = data else { return }
        titleLbl.text = data.title
        descriptionTxt.text = data.details
        dueDatetxtField.text = data.dueDate
        switch data.status {
        case StatusType.toDo.rawValue :
            todoButton.setImage(UIImage(named: "radio_selected"), for: .normal)
        case StatusType.inProgress.rawValue:
            inProgressbtn.setImage(UIImage(named: "radio_selected"), for: .normal)
        case StatusType.completed.rawValue:
            completedBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
        default:
            break
        }
    }
    
    func configure(){
        detailViewModel.delegate = self
    }
    
    // MARK: IBActions
    @IBAction func todoBtnClick(_ sender: Any) {
        data?.status = 0
        todoButton.setImage(UIImage(named: "radio_selected"), for: .normal)
        completedBtn.setImage(UIImage(named: "radio"), for: .normal)
        inProgressbtn.setImage(UIImage(named: "radio"), for: .normal)
    }
    
    @IBAction func inProgressBtnClick(_ sender: Any) {
        data?.status = 1
        inProgressbtn.setImage(UIImage(named: "radio_selected"), for: .normal)
        todoButton.setImage(UIImage(named: "radio"), for: .normal)
        completedBtn.setImage(UIImage(named: "radio"), for: .normal)
    }
    
    @IBAction func completedBtnClick(_ sender: Any) {
        data?.status = 2
        completedBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
        inProgressbtn.setImage(UIImage(named: "radio"), for: .normal)
        todoButton.setImage(UIImage(named: "radio"), for: .normal)
    }
    
    
    @IBAction func deleteClick(_ sender: Any) {
        guard let data = data else { return }
        detailViewModel.DeleteData(data: data)
    }
    
    @IBAction func updateClick(_ sender: Any) {
        guard let data = data else { return }
        detailViewModel.updateData(data)
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
}

// MARK: DetailViewModelDelegate Methods
extension DetailViewController: DetailViewModelDelegate {
    func didUpdateSuccess() {
        showAlert(detailViewModel.successTitle, message: detailViewModel.successMessage)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didUpdateFailed() {
        showAlert(detailViewModel.errorTitle, message: detailViewModel.errorMessage)
    }
    
    func didDeleteSuccess() {
        showAlert(detailViewModel.successTitle, message: detailViewModel.deleteSuccessMessage)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didDeleteFailed() {
        showAlert(detailViewModel.errorMessage, message: detailViewModel.deleteErrorMessage)
    }
    
    
}

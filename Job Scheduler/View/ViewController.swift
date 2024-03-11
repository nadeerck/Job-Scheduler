//
//  ViewController.swift
//  Job Scheduler
//
//  Created by Nadeer C K on 3/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segments: UISegmentedControl!
    
    let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        configure()
    }
    
    func initViews(){
        registerCell()
        tableView.delegate = self
        tableView.dataSource = self
        
        DatabaseHandler().addData()
        homeViewModel.getTodoList()
    }
    
    func configure() {
        homeViewModel.homeViewDelegate = self
    }
    
    func registerCell() {
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    // MARK: IBACTIONS
    @IBAction func SegmentValueChanged(_ sender: Any) {
        switch segments.selectedSegmentIndex {
        case 0:
            getToDoTasks()
        case 1:
            getInProgressTasks()
        case 2:
            getCompletedTasks()
        default:
            break
        }
    }
    
    func getToDoTasks() {
        homeViewModel.getTodoList()
    }
    
    func getInProgressTasks() {
        homeViewModel.getInprogressList()
    }
    
    func getCompletedTasks() {
        homeViewModel.getCompletedList()
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

// MARK: UITableViewDelegate, UITableViewDataSource Methods
extension ViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.taskLbl.text = homeViewModel.tasks[indexPath.row].title
        cell.dueDateLbl.text = homeViewModel.tasks[indexPath.row].dueDate
        cell.cellDelegate = self
        cell.completedBtn.tag = indexPath.row
        cell.inCompleteBtn.tag = indexPath.row
        
        switch homeViewModel.tasks[indexPath.row].status {
        case 0,1:
            cell.inCompleteBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
            cell.completedBtn.setImage(UIImage(named: "radio"), for: .normal)
        case 2:
            cell.completedBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
            cell.inCompleteBtn.setImage(UIImage(named: "radio"), for: .normal)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController as DetailViewController
        detailViewController.data = homeViewModel.tasks[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: HomeViewCellDelegate Methods
extension ViewController: HomeViewCellDelegate {
    func didCompletedButtonPress(_ tag: Int) {
        DispatchQueue.main.async{
            self.homeViewModel.updateData(self.homeViewModel.tasks[tag], status: StatusType.completed.rawValue)
        }
    }
    
    func didIncompletedButtonPress(_ tag: Int) {
        DispatchQueue.main.async {
            switch  self.segments.selectedSegmentIndex {
            case StatusType.toDo.rawValue, StatusType.completed.rawValue:
                self.homeViewModel.updateData(self.homeViewModel.tasks[tag], status: StatusType.toDo.rawValue)
            case StatusType.inProgress.rawValue:
                self.homeViewModel.updateData(self.homeViewModel.tasks[tag], status: StatusType.inProgress.rawValue)
            default:
                break
            }
        }
    }
}

// MARK: HomeViewDelegate methods
extension ViewController: HomeViewDelegate {
    
    func didSuccess() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailed() {
        print("Fetch Failed")
    }
    
    func updateSuccess() {
        showAlert(homeViewModel.successTitle, message: homeViewModel.successMessage)
        switch segments.selectedSegmentIndex {
        case 0:
            getToDoTasks()
        case 1:
            getInProgressTasks()
        case 2:
            getCompletedTasks()
        default:
            break
        }
    }
    
    func updateFailed() {
        showAlert(homeViewModel.errorTitle, message: homeViewModel.errorMessage)
    }
}


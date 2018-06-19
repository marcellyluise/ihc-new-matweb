//
//  LoginViewController.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 02/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    private func registerCells() {
        tableView.register(nibWithCellClass: FormTableViewCell.self)
    }
    
    // MARK: - Actions
    @IBAction func login(_ sender: Any) {
        if viewModel.isFormValidated {
            goToMainNavigation()
        } else {
            showAlert(title: "Ops! 😬",
                      message: "Parece que tem algo errado com suas credenciais...",
                      buttonTitles: ["Beleza 👍🏻"],
                      highlightedButtonIndex: nil,
                      completion: nil)
        }
    }
    
    @IBAction func switchToPos(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    private func goToMainNavigation() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let initialViewController = mainStoryboard.instantiateInitialViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = initialViewController
    }
    
}

// MARK: - Table View Data Source
extension LoginViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFields
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return generateFieldCell(with: tableView, at: indexPath)
    }
    
    private func generateFieldCell(with tableView: UITableView, at indexPath: IndexPath) -> FormTableViewCell {
        guard let formFieldCell = tableView.dequeueReusableCell(withClass: FormTableViewCell.self, for: indexPath) else {
            return FormTableViewCell()
        }
        
        let field = viewModel.loginFieldModel(at: indexPath)
        
        formFieldCell.delegate = self
        
        formFieldCell.indexPath = indexPath
        formFieldCell.icon = field?.icon
        formFieldCell.placeholder = field?.placeholder
        formFieldCell.fieldValue = field?.fieldValue
        formFieldCell.isSecureTextEntry = field?.isSecureField ?? false
        formFieldCell.keyboardType = field?.keyboardType ?? .default
        formFieldCell.formatter = field?.formatter
        
        return formFieldCell
    }
}

extension LoginViewController: FormTableViewCellDelegate {
    func formField(_ cell: FormTableViewCell, didChangeValidation validationResult: FormValidationResult?) {
        
        let indexPath = cell.indexPath ?? IndexPath(row: 0, section: 0)
        
        viewModel.loginFieldModel(at: indexPath)?.fieldValue = cell.unformattedValue
    }
    
    func formFieldEditinDidBegin(_ cell: FormTableViewCell) {
        
    }
    
    func formFieldEditinDidEnd(_ cell: FormTableViewCell) {
        
        let indexPath = cell.indexPath ?? IndexPath(row: 0, section: 0)
        
        viewModel.loginFieldModel(at: indexPath)?.fieldValue = cell.unformattedValue
    }
    
    func formFieldDidTapTitleIcon(_ cell: FormTableViewCell) {
        
    }
}

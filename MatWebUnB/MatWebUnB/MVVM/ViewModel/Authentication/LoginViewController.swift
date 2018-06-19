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
        
    }
    
    @IBAction func switchToPos(_ sender: Any) {
        
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
        
        formFieldCell.icon = field?.icon
        formFieldCell.placeholder = field?.placeholder
        formFieldCell.fieldValue = field?.fieldValue
        formFieldCell.isSecureTextEntry = field?.isSecureField ?? false
        formFieldCell.keyboardType = field?.keyboardType ?? .default
        
        return formFieldCell
    }
}

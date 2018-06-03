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
        tableView.register(UINib(nibName: String(describing: FormTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FormTableViewCell.self))
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let formCell = tableView.dequeueReusableCell(withIdentifier: String(describing: FormTableViewCell.self), for: indexPath) as? FormTableViewCell else {
            return FormTableViewCell()
        }
        
        return formCell
    }
}

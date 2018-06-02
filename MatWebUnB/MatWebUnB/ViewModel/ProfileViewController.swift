//
//  ProfileViewController.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 01/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ProfileViewModel()
    private var itemsIcon = [#imageLiteral(resourceName: "personal-data"), #imageLiteral(resourceName: "recommendation"), #imageLiteral(resourceName: "schedule"), #imageLiteral(resourceName: "history"), #imageLiteral(resourceName: "summary"), #imageLiteral(resourceName: "diploma-request")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: String(describing: ProfileItemTableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: String(describing: ProfileItemTableViewCell.self))
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return generateItemCell(with: tableView, at: indexPath)
    }
    
    private func generateItemCell(with tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileItemTableViewCell.self), for: indexPath) as? ProfileItemTableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.item(at: indexPath)
        
        itemCell.itemLabel.text = item
        itemCell.itemIconImageView.image = itemsIcon[indexPath.row]
        
        return itemCell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ProfileHeaderView.createHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140.0
    }
}

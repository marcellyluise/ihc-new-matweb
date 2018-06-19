//
//  FeedViewController.swift
//  MatWebUnB
//
//  Created by Marcelly Luise on 19/06/18.
//  Copyright © 2018 Marcelly Luise. All rights reserved.
//

import UIKit
import SafariServices

class FeedViewController: UIViewController {

    @IBOutlet weak var featuredNewUIView: UIView!
    @IBOutlet weak var featureNewTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = FeedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupFeaturedNew()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupFeaturedNew() {
        featuredNewUIView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToFeaturedNewDetails)))
        featureNewTitleLabel.text = "PEDIDO \n DE \n MATRÍCULA"
    }
    
    private func setupTableView() {
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(nibWithCellClass: FilterFeedTableViewCell.self)
    }

    // MARK: - Navigation
    private func goToRegistration() {
        tabBarController?.selectedIndex = 3
    }
    
    private func goToSearch() {
        tabBarController?.selectedIndex = 2
    }
    
    private func goToFacebookEvaluations() {
        let safariVC = SFSafariViewController(url: URL(string: "https://www.facebook.com/groups/unbavaliacaoprof/")!)
        
        present(safariVC, animated: true, completion: nil)
    }
    
    @objc private func goToFeaturedNewDetails() {
        performSegue(withIdentifier: "goToFeaturedNewDetails", sender: self)
    }
    
}

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfFilters
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return generateFilterCell(with: tableView, at: indexPath)
    }
    
    private func generateFilterCell(with tableView: UITableView, at indexPath: IndexPath) -> FilterFeedTableViewCell {
        guard let feedFilterCell = tableView.dequeueReusableCell(withClass: FilterFeedTableViewCell.self, for: indexPath) else {
            return FilterFeedTableViewCell()
        }
        
        let filter = viewModel.field(at: indexPath)
        
        feedFilterCell.filterName = filter.title
        
        return feedFilterCell
    }
    
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return FeedSectionTitleView.createSection(with: viewModel.sectionTitle)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FeedSectionTitleView.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            goToRegistration()
        case 1:
            goToSearch()
        case 2:
            goToFacebookEvaluations()
        case 3:
            goToFeaturedNewDetails()
        default:
            break
        }
    }
}

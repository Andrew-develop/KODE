//
//  MainViewController.swift
//  KODE
//
//  Created by Sergio Ramos on 02.06.2021.
//

import UIKit

final class RecipesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var viewModel : MainViewModel!
    
    required convenience init(viewModel: MainViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        bindToViewModel()
        viewModel.getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpSearchBar()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        viewModel.recipeViewModelsTypes.forEach { $0.registerCell(tableView: tableView) }
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.setRightImage(normalImage: UIImage(named: "filter")!, highLightedImage: UIImage(named: "filter")!)
    }
    
    private func bindToViewModel() {
        viewModel.didUpdate = { [weak self] _ in
            self?.viewModelDidUpdate()
        }
        viewModel.didError = { [weak self] error in
            self?.viewModelDidError(error: error)
        }
    }
    
    private func viewModelDidUpdate() {
        UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
    private func viewModelDidError(error: String) {
        DialogManager.showErrorDialog(controller: self, title: "Error", message: error)
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.sort(sortMethod: TypeOfSort.byDate)
        case 1:
            viewModel.sort(sortMethod: TypeOfSort.byName)
        default:
            break
        }
        hideSortElements()
    }
}

extension RecipesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(text: searchBar.text ?? "")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(text: searchBar.text ?? "")
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if segmentControl.alpha == 0 {
            showSortElements()
        }
        else {
            hideSortElements()
        }
    }
    
    private func showSortElements() {
        UIView.animate(withDuration: 0.5) {
            self.tableView.frame.origin.y = self.sortLabel.frame.maxY + 8
            self.sortLabel.alpha = 1
            self.segmentControl.alpha = 1
        }
    }
    
    private func hideSortElements() {
        UIView.animate(withDuration: 0.5) {
            self.tableView.frame.origin.y = self.searchBar.frame.maxY + 8
            self.sortLabel.alpha = 0
            self.segmentControl.alpha = 0
        }
    }
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipeViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.recipeViewModels[indexPath.row].dequeueCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return viewModel.recipeViewModels[indexPath.row].cellSelected()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 2.5
    }
    
}

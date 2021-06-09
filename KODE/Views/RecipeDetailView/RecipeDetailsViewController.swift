//
//  RecipeViewController.swift
//  KODE
//
//  Created by Sergio Ramos on 02.06.2021.
//

import UIKit

class RecipeDetailsViewController: UIViewController {

    @IBOutlet weak var collectionViewForPictures: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var collectionViewForDifficulty: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var viewModel : RecipeDetailsViewModel!

    required convenience init(viewModel: RecipeDetailsViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViewForPictures()
        setUpCollectionViewForDifficulty()
        bindToViewModel()
        viewModel.getPictures()
        viewModel.getDifficulty()
    }
    
    private func bindToViewModel() {
        self.viewModel.didUpdate = { [weak self] _ in
            self?.viewModelDidUpdate()
        }
        self.viewModel.didError = { [weak self] error in
            self?.viewModelDidError(error: error)
        }
    }
    
    
    private func viewModelDidUpdate() {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.recipeDescription
        instructionsLabel.text = viewModel.instructions
        dateLabel.text = viewModel.lastUpdated
        collectionViewForDifficulty.reloadData()
        collectionViewForPictures.reloadData()
        pageControl.numberOfPages = viewModel.pictureViewModels.count
    }
    
    private func viewModelDidError(error: Error) {
        DialogManager.showErrorDialog(controller: self, title: "Error", message: error.localizedDescription)
    }
    
    private func setUpCollectionViewForDifficulty() {
        collectionViewForDifficulty.delegate = self
        collectionViewForDifficulty.dataSource = self
        viewModel.difficultyViewModelsTypes.forEach { $0.registerCell(collectionView: collectionViewForDifficulty) }
    }
    
    private func setUpCollectionViewForPictures() {
        collectionViewForPictures.delegate = self
        collectionViewForPictures.dataSource = self
        viewModel.pictureViewModelsTypes.forEach { $0.registerCell(collectionView: collectionViewForPictures) }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        viewModel.openRecipeList()
    }
}

extension RecipeDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewForPictures {
            return viewModel.pictureViewModels.count
        }
        else {
            return viewModel.difficultyViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewForPictures {
            return viewModel.pictureViewModels[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
        }
        else {
            return viewModel.difficultyViewModels[indexPath.row].dequeueCell(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewForPictures {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else {
            return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
        }
    }
}
    
extension RecipeDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = collectionViewForPictures.contentOffset.x
        let w = collectionViewForPictures.bounds.size.width
        pageControl.currentPage = Int(ceil(x/w))
    }
    
}

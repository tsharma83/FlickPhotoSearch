//
//  FlickrPhotosViewController.swift
//  FlickrPhotoSearch
//
//  Created by Tarun S on 01/07/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import UIKit

fileprivate let columnsPerRow: CGFloat = 3
fileprivate let padding: CGFloat = 20.0
fileprivate let oddCellColor = UIColor(red: (102/255.0), green: (204/255.0), blue:1.0, alpha: 1.0)
fileprivate let evenCellColor = UIColor(red: 1.0, green: (204/255.0), blue:(102/255.0), alpha: 1.0)
fileprivate let photoCellReuseIdentifier = "photoCell"
fileprivate let loadingFooterViewReuseIdentifier = "loadingFooterView"
fileprivate let footerViewWithLabelReuseIdentifier = "footerViewWithLabel"

class FlickrPhotosViewController: UICollectionViewController {
    
    //MARK: - Dependencies
    var viewModel:FlickrPhotosViewModel!
    
    // Overlay view for showing error/empty/initial message
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayViewLabel: UILabel!
    
    @IBOutlet private var searchField: UITextField!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photos"
        
        configureCollectionView()
        configureOverlay()
        bindViewModel()
        
        // TODO: If you use bindings b/w VC and VM then this should not be necessary.
        setAppropriateView(for: .untriggered)
    }
    
    //MARK: - Configuration
    private func configureOverlay() {
        view.addSubview(overlayView)
        setOverlayViewConstraints()
        overlayView.isHidden = true
    }
    
    private func configureCollectionView() {
        collectionView!.register(UINib(nibName: "LoadingFooterView", bundle: nil),
                                      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterViewReuseIdentifier)
    }
    
    private func bindViewModel() {
        viewModel.didChangeState = { [weak self] state in
            DispatchQueue.main.async {
                self?.setAppropriateView(for: state)
                self?.collectionView?.reloadData()
            }
        }
    }
    
    private func setAppropriateView(for state:State) {
        switch state {
        case .untriggered:
            overlayView.isHidden = false
            overlayViewLabel.text = "Please search above to start."
        case .error(let error):
            overlayView.isHidden = false
            overlayViewLabel.text = "Oops!! \(error.localizedDescription)"
        case .empty:
            print("Set the footer for empty")
            overlayView.isHidden = false
            overlayViewLabel.text = "No Photos found, try something else."
        case .loading,.paging,.populated:
            overlayView.isHidden = true
        }
    }
    
    private func setOverlayViewConstraints() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: UIView] = ["view": view!, "newView": overlayView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
    }
    
    private func footerViewSize()-> CGSize {
        switch viewModel.state {
        case .paging, .loading:
            return CGSize(width: collectionView!.bounds.size.width,
                          height: 55)
        default:
            return CGSize.zero
        }
    }
    
    //MARK: - Actions
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        
        if searchField.isHidden {
            searchField.isHidden = false
            navigationItem.titleView = searchField
            return
        }
        
        guard let query = searchField.text,!query.isEmpty else { return }
        
        navigationItem.titleView = nil
        title = searchField.text
        searchField.isHidden = true
        loadPhotos(matching: query)
    }
    
    fileprivate func loadPhotos(matching query:String) {
        viewModel.loadPhotos(matching: query)
    }
}

// MARK: UICollectionViewDataSource
extension FlickrPhotosViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.flickrPhotosCellModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:FlickrPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as! FlickrPhotoCell
        
        // Configure the cell
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = evenCellColor
        default:
            cell.backgroundColor = oddCellColor
        }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.configure(with: viewModel.flickrPhotosCellModels[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadingFooterViewReuseIdentifier, for: indexPath) as! LoadingFooterView
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadingFooterViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
}

// MARK: UIScrollViewDelegate
extension FlickrPhotosViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            viewModel.didReachedBottom()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FlickrPhotosViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = padding * (columnsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / columnsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: padding, bottom: 10.0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return footerViewSize()
    }
}


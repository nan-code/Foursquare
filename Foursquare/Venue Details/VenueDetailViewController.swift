//
//  VenueDetailViewController.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/14/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import Foundation
import UIKit

protocol VenueDetailViewInput: class {
    func didUpdate(withPhotos photos: [VenuePhoto])
    func didUpdate(withDetails details: VenueDetails)
}

protocol VenueDetailViewOutput: class {
    func dismiss()
}

class VenueDetailViewController: UIViewController {
    
    static var identifier = "VenueDetailViewController"
    
    @IBOutlet var pageContainerView: UIView!
    @IBOutlet var detailContainerView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var backButton: UIButton!
    
    var venue: Venue?
    var venuePhotos: [VenuePhoto] = []
    var venueDetails: VenueDetails?
    var pageViewController: UIPageViewController?
    var viewControllers: [UIViewController] = []
    
    var detailViewInput: VenueDetailTableViewInput?
    var output: VenueDetailViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
     
        configurePageViewController()
        configureHeaderView()
        configureBackButton()
        configureDetailView()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func loadData() {
        guard let details = venueDetails else { return }
        didUpdate(withDetails: details)
        let photos = Array(details.photos)
        didUpdate(withPhotos: photos)
    }
    
    private func configurePageViewController() {
        let pageViewController = UIPageViewController()
        pageViewController.dataSource = self
        
        let firstViewController = loadPageViewController(at: 0) ?? VenueDetailPhotoPageViewController()
        viewControllers = [firstViewController]
        
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        pageViewController.view.frame = pageContainerView.bounds
        addChild(pageViewController)
        pageContainerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        self.pageViewController = pageViewController
    }
    
    private func configureHeaderView() {
        let gradientLayer = CAGradientLayer()
        let startColor = UIColor.black.withAlphaComponent(0.8).cgColor
        let endColor = UIColor.clear.cgColor
        gradientLayer.colors = [endColor, startColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = headerView.bounds
        
        headerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureBackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(dismissDetailView), for: .touchUpInside)
    }
    
    private func configureDetailView() {
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: VenueDetailTableViewController.identifier) as? VenueDetailTableViewController else {
            return
        }
        
        detailViewController.view.frame = detailContainerView.bounds
        addChild(detailViewController)
        detailContainerView.addSubview(detailViewController.view)
        detailViewController.didMove(toParent: self)
        detailViewInput = detailViewController
    }
    
    @objc private func dismissDetailView() {
        output?.dismiss()
    }
}

extension VenueDetailViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoViewController = viewController as? VenueDetailPhotoPageViewController,
            photoViewController.pageIndex > 0 else {
            return nil
        }
        
        let beforeIndex = photoViewController.pageIndex - 1
        return loadPageViewController(at: beforeIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoViewController = viewController as? VenueDetailPhotoPageViewController else {
            return nil
        }
        
        let afterIndex = photoViewController.pageIndex + 1
        guard afterIndex == venuePhotos.count else {
            return nil
        }
        
        return loadPageViewController(at: afterIndex)
    }
    
    private func loadPageViewController(at index: Int) -> UIViewController? {
        guard !venuePhotos.isEmpty,
            index < venuePhotos.count,
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as? VenueDetailPhotoPageViewController else {
            return nil
        }
        
        viewController.pageIndex = index
        let photo = venuePhotos[index]
        if let prefix = photo.prefix, let suffix = photo.suffix {
            let url = URL(string: "\(prefix)original\(suffix)")
            viewController.imageURL = url
        }
        return viewController
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return venuePhotos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension VenueDetailViewController: VenueDetailViewInput {
    func didUpdate(withPhotos photos: [VenuePhoto]) {
        venuePhotos = photos
        let newPhotoDetailViewController = loadPageViewController(at: 0) ?? VenueDetailPhotoPageViewController()
        viewControllers = [newPhotoDetailViewController]
        pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
    }
    
    func didUpdate(withDetails details: VenueDetails) {
        venueDetails = details
     
        detailViewInput?.didUpdate(withDetails: details)
    }
}

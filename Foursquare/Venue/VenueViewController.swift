//
//  VenueViewController.swift
//  Foursquare
//
//  Created by Matthew Nanney on 1/12/19.
//  Copyright © 2019 Matthew Nanney. All rights reserved.
//

import UIKit
import CoreLocation
import PopupDialog

protocol VenueViewInput: class {
    func didUpdate(withVenues venues: [Venue], offset: Int)
    func didUpdate(withSuggestions suggestions: [SearchViewModel])
    func didUpdate(withLocation location: String?)
    func didUpdate(withErrorMessage message: String)
}

protocol VenueViewOutput: class {
    func didCheckLocation()
    func search(forVenue searchText: String?)
    func search(forLocation searchText: String?)
    func didTapVenue(at index: Int)
    func didSelectLocation(at index: Int)
    func feedItemWillDisplay(at index: Int)
}

class VenueViewController: UIViewController {
    
    static let identifier = "VenueViewController"
    static let currentLocationText = "📍 Current Location"
    
    var venueViewController: UICollectionViewController?
    var collectionView: UICollectionView? {
        return venueViewController?.collectionView
    }
    var searchViewController: UITableViewController?
    var tableView: UITableView? {
        return searchViewController?.tableView
    }
    var backgroundView: UIView?
    
    @IBOutlet var listContainerView: UIView!
    
    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    private var venues: [Venue] = []
    private var suggestions: [SearchViewModel] = []
    var output: VenueViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        registerCollectionViewCells()
        reloadCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
           locationTextField.becomeFirstResponder()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private extension VenueViewController {
    func configureViews() {
        let searchViewController = UITableViewController()
        searchViewController.tableView.backgroundColor = UIColor.white
        searchViewController.tableView.delegate = self
        searchViewController.tableView.dataSource = self
        addChild(searchViewController)
        searchViewController.view.frame = listContainerView.bounds
        searchViewController.didMove(toParent: self)
        self.searchViewController = searchViewController

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let venueViewController = UICollectionViewController(collectionViewLayout: layout)
        venueViewController.collectionView.backgroundColor = UIColor.clear
        venueViewController.collectionView.delegate = self
        venueViewController.collectionView.dataSource = self
        addChild(venueViewController)
        venueViewController.view.frame = listContainerView.bounds
        venueViewController.didMove(toParent: self)
        self.venueViewController = venueViewController
        
        searchImage.image = UIImage(named: "Search")?.withRenderingMode(.alwaysTemplate)
        searchImage.tintColor = UIColor.white
        locationImage.image = UIImage(named: "Location")?.withRenderingMode(.alwaysTemplate)
        locationImage.tintColor = UIColor.white
        
        searchTextField.delegate = self
        searchTextField.addDoneToolbar()
        locationTextField.delegate = self
        locationTextField.addDoneToolbar()
        locationTextField.text = "📍 Current Location"
        
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    func addListConstraints(to view: UIView) {
        let constraints = [
            NSLayoutConstraint(item: listContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: listContainerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: listContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: listContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func registerCollectionViewCells() {
        collectionView?.register(UINib(nibName: "VenueCell", bundle: nil), forCellWithReuseIdentifier: VenueCell.identifier)
    }

    func loadEmptyState(visible: Bool, withMessage message: String? = nil) {
        if visible, backgroundView == nil {
            let view = UIView(frame: listContainerView.bounds)
            view.backgroundColor = UIColor.white
            let label = UILabel(frame: listContainerView.bounds)
            label.contentMode = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.textAlignment = .center
            label.text = message ?? "No results here! Search away to find some new venues"
            view.addSubview(label)
            listContainerView.addSubview(view)
            listContainerView.bringSubviewToFront(view)
            backgroundView = view
        } else {
            backgroundView?.removeFromSuperview()
        }
    }
    
    func reloadTableView() {
        guard let searchView = searchViewController?.view else {
            return
        }
        listContainerView.addSubview(searchView)
        venueViewController?.view.removeFromSuperview()
        addListConstraints(to: searchView)
        tableView?.reloadData()
    }
    
    func reloadCollectionView() {
        guard let venueView = venueViewController?.view else {
            return
        }
        listContainerView.addSubview(venueView)
        searchViewController?.view.removeFromSuperview()
        addListConstraints(to: venueView)
        collectionView?.reloadData()
        loadEmptyState(visible: false)
    }
    
    @objc func search() {
        output?.search(forVenue: searchTextField.text)
    }
}

//MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension VenueViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !venues.isEmpty else {
            loadEmptyState(visible: true)
            return 0
        }
        loadEmptyState(visible: false)
        return venues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VenueCell.identifier, for: indexPath) as? VenueCell else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = VenueCellViewModel.makeViewModel(venue: venues[indexPath.item])
        cell.configure(with: cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.didTapVenue(at: indexPath.item)
        searchTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        output?.feedItemWillDisplay(at: indexPath.item)
    }
}

extension VenueViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 60)
    }
}

//MARK: - Search UITableViewDataSource & UITableViewDelegate
extension VenueViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = suggestions.count
        if count > 0 {
            // will be used for the current location option
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchResultCell")
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = VenueViewController.currentLocationText
        } else {
            let suggestion = suggestions[indexPath.row - 1] // -1 for the current location option
            cell?.textLabel?.text = suggestion.title
            cell?.detailTextLabel?.text = suggestion.subtitle
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didSelectLocation(at: indexPath.row - 1 )
        locationTextField.resignFirstResponder()
    }
}

//MARK: - UITextFieldDelegate
extension VenueViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard locationTextField == textField else {
            return
        }
        
        if locationTextField.text == VenueViewController.currentLocationText {
            output?.didCheckLocation()
        } else {
            output?.search(forLocation: locationTextField.text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isSearchTextEmpty = searchTextField.text?.isEmpty ?? false
        let islocationTextEmpty = locationTextField.text?.isEmpty ?? false
        guard !isSearchTextEmpty || !islocationTextEmpty else {
            Dialog.displayError(with: "Please enter a value or location to search venues", on: self)
            return true
        }
        
        search()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let searchText = text.replacingCharacters(in: textRange, with: string)
            switch textField {
            case searchTextField:
                output?.search(forVenue: searchText)
                break
            case locationTextField:
                output?.search(forLocation: searchText)
                break
            default: break
            }
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case searchTextField:
            output?.search(forVenue: "")
            break
        case locationTextField:
            output?.search(forLocation: "")
            break
        default: break
        }
        
        return true
    }
}

//MARK: - VenueViewInput
extension VenueViewController: VenueViewInput {
    func didUpdate(withSuggestions suggestions: [SearchViewModel]) {
        self.suggestions = suggestions
        
        guard !suggestions.isEmpty else {
            reloadCollectionView()
            return
        }
        reloadTableView()
    }
    
    func didUpdate(withVenues venues: [Venue], offset: Int) {
        if offset == 0 {
            self.venues = venues
            collectionView?.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        } else {
            self.venues.append(contentsOf: venues)
        }
        reloadCollectionView()
    }
    
    func didUpdate(withLocation location: String?) {
        locationTextField.text = location
    }
    
    func didUpdate(withErrorMessage message: String) {
        loadEmptyState(visible: true, withMessage: message)
    }
}

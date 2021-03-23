//
//  ViewController.swift
//  DownloadImages
//
//  Created by Andrew Trach on 20.03.2021.
//

import UIKit
import SDWebImage
import Alamofire

class ViewController: UIViewController {
    
    struct Constants {
        static let downloadTo = "Downloading image to gallery"
        static let cellIdentifier = "ImagesTableViewCell"
        static let placeholder = "placeholder.png"
        static let completed = "Completed"
        static let done = "100% completed"
        static let fontOfSize = 12.0
    }
    
    @IBOutlet weak var imageTableView: UITableView!
    
    private let networkService = NetworkService()
    private var albums = [DataModel]()
    private var downloadedUrls = [String]()
    
    
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
    }
    
    // MARK: - Private func
    
    private func getPhotos(){
        networkService.getPhotos { [weak self] (photos) in
            guard let self = self else { return }
            self.albums = photos
            self.imageTableView.reloadData()
        }
    }
    
    private func saveImage(image: UIImage, url: String) {
        downloadedUrls.append(url)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.showToast(message: Constants.downloadTo, font: .systemFont(ofSize: CGFloat(Constants.fontOfSize)))
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! ImagesTableViewCell
        let albumData = albums[indexPath.row]
        let url = URL(string: albumData.urls?.small ?? "")
        let fullUrl = albumData.urls?.full ?? ""
        
        if downloadedUrls.contains(fullUrl) {
            cell.isCompleted = true
        } else {
            cell.isCompleted = false
        }
        
        cell.photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constants.placeholder))
        cell.descriptionLabel.text = albumData.alt_description
        
        cell.buuttonCancelAction = { [weak self] in
            self?.networkService.fetchImageCancel()
            cell.isCompleted = false
        }
        
        cell.buttonTappedAction = { [weak self] in
            self?.networkService.fetchImage(fromUrl: fullUrl) { (progress) in
                if progress.localizedDescription == ViewController.Constants.done {
                    cell.startStopButton.setTitle(ViewController.Constants.completed, for: .normal)
                    cell.isCompleted = true
                }
                cell.loadProgressView.setProgress(Float(progress.fractionCompleted), animated: true)
                cell.loadLabel.text = progress.localizedDescription
            } responseImage: { [weak self] (image) in
                self?.saveImage(image: image, url: fullUrl)
            }
        }
        
        return cell
    }
}

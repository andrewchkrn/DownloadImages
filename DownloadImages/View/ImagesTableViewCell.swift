//
//  ImagesTableViewCell.swift
//  DownloadImages
//
//  Created by Andrew Trach on 20.03.2021.
//

import UIKit
import Alamofire


class ImagesTableViewCell: UITableViewCell {
    
    struct Constants {
        static let start = "Start"
        static let stop = "Stop"
        static let completed = "Completed"
        static let starValue = "0%"
        static let endValue = "100%"
    }
 
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var loadProgressView: UIProgressView!
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var buttonTappedAction: (() -> Void)?
    var buuttonCancelAction: (() -> Void)?
    
    var isCompleted = false {
        didSet {
            if isCompleted {
                startStopButton.setTitle(Constants.completed, for: .normal)
                loadProgressView.setProgress(100, animated: false)
                loadLabel.text = Constants.endValue
            } else {
                startStopButton.setTitle(Constants.start, for: .normal)
                loadProgressView.setProgress(0, animated: false)
                loadLabel.text = Constants.starValue
            }
        }
    }
    
    var isDownloading: Bool = false {
        didSet {
            if isDownloading {
                startStopButton.setTitle(Constants.stop, for: .normal)
                buttonTappedAction?()
            } else {
                startStopButton.setTitle(Constants.start, for: .normal)
                buuttonCancelAction?()
                loadProgressView.setProgress(0, animated: false)
                loadLabel.text = Constants.starValue
            }
        }
    }
    
    // MARK: - @IBAction func
    
    @IBAction func startDownloadButtonAction(_ sender: Any) {
        guard !isCompleted else { return }
        isDownloading = !isDownloading
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if isDownloading {
            startStopButton.setTitle(Constants.start, for: .normal)
        } else if isCompleted  {
            startStopButton.setTitle(Constants.completed, for: .normal)
            loadProgressView.setProgress(0, animated: true)
            loadLabel.text = Constants.starValue
        } else {
            startStopButton.setTitle(Constants.start, for: .normal)
            loadProgressView.setProgress(0, animated: true)
            loadLabel.text = Constants.starValue
        }
    }
}

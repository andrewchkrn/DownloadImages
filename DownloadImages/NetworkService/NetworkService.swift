//
//  NetworkService.swift
//  DownloadImages
//
//  Created by Andrew Trach on 21.03.2021.
//


import Alamofire
import Foundation

class NetworkService {
    
    var request: Alamofire.Request?
    
    let baseUrl = "https://api.unsplash.com/"
    let clientId = "ZJAOOE961G5KZ-CXLjo2uU12XC9E9VHKh_FUflRnPC8"
    
    func getPhotos(completion: @escaping ([DataModel]) -> Void) {
      
        AF.request(baseUrl + "photos/?client_id=\(clientId)").responseJSON { response in
            
            if let dictArray = response.value as? [[String: Any]] {
                var albums = [DataModel]()
                for dict in dictArray {
                    if let album = DataModel.init(dict: dict) {
                        albums.append(album)
                    }
                }
                completion(albums)
            }
        }
    }
   
    func fetchImageCancel() {
        self.request?.cancel()
    }

    func fetchImage(fromUrl url: String,
                    downoloadProgress: @escaping (Progress) -> Void,
                    responseImage: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        self.request = AF.request(url)
            .validate()
            .downloadProgress { (progress) in
                downoloadProgress(progress)
            }.response { (response) in
                guard let data = response.data, let image = UIImage(data: data) else { return }
                responseImage(image)
            }
    }
}

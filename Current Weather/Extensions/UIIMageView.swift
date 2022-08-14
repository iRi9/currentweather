//
//  UIIMageView.swift
//  Current Weather
//
//  Created by Giri Bahari on 14/08/22.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func setImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        image = nil

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }

            guard let imageToCache = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}

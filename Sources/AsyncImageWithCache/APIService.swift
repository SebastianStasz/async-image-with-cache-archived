//
//  APIService.swift
//  AsyncImagePresentation
//
//  Created by Sebastian Staszczyk on 21/05/2021.
//

import Combine
import Foundation
import SwiftUI

final class APIService {
    static let shared = APIService()
    
    func fetchImage(from urlString: String) -> AnyPublisher<UIImage, ImageLoaderError> {
        switch getURLFromString(urlString) {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { [unowned self] in try transformToUIImage($0.data) }
                .mapError { err in
                    if let err = err as? URLError {
                        return ImageLoaderError.urlError(error: err)
                    } else if let _ = err as? ImageLoaderError {
                        return ImageLoaderError.invalidData
                    } else {
                        return ImageLoaderError.other(error: err)
                    }
                }
               .eraseToAnyPublisher()
            
        case .failure(let error):
            return Fail(error: ImageLoaderError.urlError(error: error)).eraseToAnyPublisher()
        }
    }
    
    private func transformToUIImage(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.invalidData
        }
      
        return image
    }

    private func getURLFromString(_ urlString: String) -> Result<URL, URLError> {
        guard let url = URL(string: urlString) else {
            let error = URLError(.badURL, userInfo: [NSURLErrorKey: urlString])
            return .failure(error)
        }
      
        return .success(url)
    }
}




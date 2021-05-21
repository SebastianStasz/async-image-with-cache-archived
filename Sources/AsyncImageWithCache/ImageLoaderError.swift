//
//  ImageLoaderError.swift
//  AsyncImagePresentation
//
//  Created by Sebastian Staszczyk on 21/05/2021.
//

import Foundation

enum ImageLoaderError: Error {
    case invalidData
    case other(error: Error)
    case urlError(error: URLError)
}

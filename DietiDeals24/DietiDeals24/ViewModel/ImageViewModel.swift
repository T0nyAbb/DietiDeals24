//
//  ImageViewModel.swift
//  DietiDeals24
//
//  Created by Antonio Abbatiello on 12/03/24.
//

import Foundation
import SwiftUI
import Amplify
import AWSS3
import AWSS3StoragePlugin

@Observable
class ImageViewModel {
    
    var uiImage: UIImage?

    
    
    
    func uploadProfilePicture(username: String) async throws -> String {
        let data = Data(((uiImage?.jpegData(compressionQuality: 0.5)!)!))
        let uploadTask = Amplify.Storage.uploadData(
            key: username,
            data: data,
            options: .init(accessLevel: .guest)
        )
        Task {
            for await progress in await uploadTask.progress {
                print("Progress: \(progress)")
            }
        }
        let value = try await uploadTask.value
        print("Completed: \(value)")
        return value
    }
    
    func uploadAuctionPicture(auction: Auction) async throws -> String {
        let data = Data(((uiImage?.jpegData(compressionQuality: 0.5)!)!))
        let uploadTask = Amplify.Storage.uploadData(
            key: auction.id!.description,
            data: data,
            options: .init(accessLevel: .guest)
        )
        Task {
            for await progress in await uploadTask.progress {
                print("Progress: \(progress)")
            }
        }
        let value = try await uploadTask.value
        print("Completed: \(value)")
        return value
    }
    
    func downloadProfilePicture(username: String) async throws -> UIImage {
        let downloadTask = Amplify.Storage.downloadData(key: username)
        Task {
            for await progress in await downloadTask.progress {
                print("Progress: \(progress)")
            }
        }
        let data = try await downloadTask.value
        print("Completed: \(data)")
        let image = UIImage(data: data)
        return image!
    }
    
    func downloadAuctionPicture(auctionID: Int) async throws -> UIImage {
        let downloadTask = Amplify.Storage.downloadData(key: auctionID.description)
        Task {
            for await progress in await downloadTask.progress {
                print("Progress: \(progress)")
            }
        }
        let data = try await downloadTask.value
        print("Completed: \(data)")
        let image = UIImage(data: data)
        return image!
    }
    
    func getProfilePictureUrl(username: String) -> String {
        let url = Constants.CLOUDFRONT_URL.appendingPathComponent(username)
        print("Completed: \(url)")
        return url
    }
    
    func getAuctionPictureUrl(auction: Auction) -> String {
        let url = Constants.CLOUDFRONT_URL.appending(auction.id!.description)
        print("Completed: \(url)")
        return url
    }
    
    
}

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
            data: data
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
            data: data
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
    
    func getProfilePictureUrl(username: String) async throws -> String {
        let url = try await Amplify.Storage.getURL(key: username, options: .init(expires: 604_800)) //expiration set to 7 days in seconds)
        print("Completed: \(url)")
        return url.absoluteString
    }
    
    func getAuctionPictureUrl(auction: Auction) async throws -> String {
        let url = try await Amplify.Storage.getURL(key: auction.id!.description, options: .init(expires: 604_800)) //expiration set to 7 days in seconds
        print("Completed: \(url)")
        return url.absoluteString
    }
    
    
}

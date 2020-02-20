//
//  API.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import Foundation

//MARK: Ticket Master
struct Ticket: Codable {
    let _embedded: TicketEmbedded
}

struct TicketEmbedded: Codable {
    let events: [Event]
}

struct Event: Codable {
    let name: String
    let type: String
    let id: String
    let url: String
    let images: [Image]
    let priceRanges: [PriceRange]?
    let dates: Dates
    let info: String?
    
}

struct PriceRange: Codable {
    let currency = "USD"
    let min, max: Double
}

struct Dates: Codable {
    let start: Start
}

struct Start: Codable {
    let localDate: String
}

struct Image: Codable {
    let url: String
}


final class TicketAPIClient {
    private init() {}
    static let shared = TicketAPIClient()
    
    func getEvents(search: String, completionHandler: @escaping (Result<[Event], AppError>) -> Void) {
        let urlStr = "https://app.ticketmaster.com/discovery/v2/events.json?city=\(search)&apikey=\(Secrets.ticketKey)"
        
        guard let url = URL(string: urlStr) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure(let error) :
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let TicketWrapper = try JSONDecoder().decode(Ticket.self, from: data)
                    completionHandler(.success(TicketWrapper._embedded.events))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
}
//======================================================================================================================
//MARK: RijksStudio

struct Museum:Codable {
    let artObjects: [ArtObject]
}

struct ArtObject: Codable {
    let id, objectNumber, title: String
    let hasImage: Bool
    let principalOrFirstMaker, longTitle: String
    let showImage, permitDownload: Bool
    let webImage: Images
    
}

struct Images: Codable {
    let url: String
}


final class RijksAPIClient {
    
    private init() {}
    
    static let shared = RijksAPIClient()
    
    func getArt(search: String ,completionHandler: @escaping (Result<[ArtObject], AppError>) -> () ) {
        
        let stringURL = "https://www.rijksmuseum.nl/api/en/collection?key=\(Secrets.rijksKey)&involvedMaker=\(search.replacingOccurrences(of: " ", with: "+"))"
        //print(stringURL)
        guard let url = URL(string: stringURL) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get, completionHandler: { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let Data = try JSONDecoder().decode(Museum.self, from: data)
                    completionHandler(.success(Data.artObjects ))
                } catch {
                    print(error)
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        })
    }
}

//MARK: Rijks detail info

struct ArtDetail: Codable {
    let artObject: ArtInfo
}

struct ArtInfo: Codable {
    let links: Links
    let title: String
    let webImage: WebImage
    let longTitle, scLabelLine: String
    let label: Label
}

struct Links: Codable {
    let search: String
}

struct WebImage: Codable {
    let url: String
}

struct Dating: Codable {
    let presentingDate: String
    let sortingDate, period, yearEarly, yearLate: Int
}

struct Label: Codable {
    let labelDescription: String
    let date: String
}


final class RijksDetailAPI {
    
    private init() {}
    
    static let shared = RijksDetailAPI()
    
    func getDetail(artID: String ,completionHandler: @escaping (Result<ArtInfo, AppError>) -> () ) {
        
        let stringURL = "https://www.rijksmuseum.nl/api/en/collection/\(artID)?key=\(Secrets.rijksKey)"
        guard let url = URL(string: stringURL) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get, completionHandler: { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let artData = try JSONDecoder().decode(ArtDetail.self, from: data)
                    completionHandler(.success(artData.artObject))
                } catch {
                    print(error)
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        })
    }
    
    //For testing
    static func getArtDetail(from data: Data) -> ArtDetail {
        do {
            let art = try JSONDecoder().decode(ArtDetail.self, from: data)
            return art
        } catch let decodeError {
            fatalError("could not decode info \(decodeError)")
            
        }
    }
    
}








//MARK: self made string for refrence

struct APIList{
    static var list = ["Ticket Master","Rijks Studio"]
}

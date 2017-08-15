//
//  Slack.swift
//  SlackApi
//
//  Created by Jeff Lett on 8/15/17.
//  Copyright © 2017 Jeff Lett. All rights reserved.
//

import Foundation

public class Slack {
    
    public static var loggingEnabled = false
    
    public enum SlackError: Error {
        case unableToCreateURL
    }
    
    public init() {}
    
    /** Posts a message to a Slack chat room
     *
     * - Parameters:
     * - urlSlug: the Slack room's API Url Slug (T00000000/B0000000/XXXXXXXXXXXXX)
     * - message: the message to be posted
     * - completion: completion block to be run after the method finishes.
     * - Throws: This method can throw a SlackError
     */
    public func postMessage(urlSlug: String, message: String, completion: @escaping (Data?, Error?) -> ()) throws {
        if Slack.loggingEnabled {
            print("*** Constructing Slack URL.")
        }
       
        let urlString = "https://hooks.slack.com/services/" + urlSlug
        guard let url = URL(string: urlString) else {
            throw SlackError.unableToCreateURL
        }
        
        if Slack.loggingEnabled {
            print("*** Done Constructing Slack URL: (\(url.absoluteString))")
            print("*** Constructing JSON Body.")
        }
 
        let json = "{\"text\":\"\(message)\"}"
        if Slack.loggingEnabled {
            print("*** Done Constructing JSON Body. (\(json))")
        }
 
        // url session & configuration
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: configuration)
 
        // url request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
 
        // post body
        let bodyData = json.data(using: String.Encoding.utf8, allowLossyConversion: true)
        urlRequest.httpBody = bodyData
        if Slack.loggingEnabled {
            print("*** HTTP Body: \(bodyData!)")
        }
        
        // do it now
        if Slack.loggingEnabled {
            print("*** Posting Message to Slack.")
        }
        urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if Slack.loggingEnabled {
                print("*** Done Posting Message to Slack.")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if Slack.loggingEnabled {
                    print("*** ResponseCode: \(httpResponse.statusCode)")
                }
            }
 
            if let error = error {
                if Slack.loggingEnabled {
                    print("*** Error encountered: \(error)")
                }
                completion(nil, error)
                return
            }
            
            completion(data, nil)
 
        }).resume()
 
    }
}

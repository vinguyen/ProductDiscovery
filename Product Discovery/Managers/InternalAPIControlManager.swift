//
//  InternalAPIControlManager.swift
//  Product Discovery
//
//  Created by vi nguyen on 8/31/19.
//  Copyright © 2019 vi nguyen. All rights reserved.
//

import Foundation
import Alamofire

protocol InternalAPIControlManager {
    func performNonAuthRequest(with url: URL,
                               method: HTTPMethod,
                               parameters: Parameters?,
                               headers: HTTPHeaders?,
                               completion: @escaping (Result<InternalAPIResponse>) -> Void)
}

class InternalAPIControlManagerImpl: InternalAPIControlManager {
    
    let sessionManager: SessionManager
    
    init(enabledCertificatePinning: Bool = false) {
        
        let serverTrustPolicy = ServerTrustPolicy.pinCertificates(
            certificates: ServerTrustPolicy.certificates(),
            validateCertificateChain: true,
            validateHost: true
        )
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://listing-stg.services.teko.vn": serverTrustPolicy
        ]
        
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
        
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = TimeInterval(InternalAPIContants.requestTimeout)
        
        sessionManager = SessionManager(
            configuration: urlSessionConfiguration,
            serverTrustPolicyManager: enabledCertificatePinning ? serverTrustPolicyManager : nil)
    }
    
    func performNonAuthRequest(with url: URL,
                               method: HTTPMethod,
                               parameters: Parameters?,
                               headers: HTTPHeaders?,
                               completion: @escaping (Result<InternalAPIResponse>) -> Void) {
        
        var headers = headers ?? [String: String]()
        headers["application/json"] = InternalAPIContants.contentType
        sessionManager
            .request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    guard let responseData = response.data else {
                        completion(.failure(InternalAPIError.failedResponseParsing))
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization
                            .jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                        if let json = json as? JSONDictionary,  let response = InternalAPIResponse(with: json) {
                            completion(.success(response))
                        } else {
                            completion(.failure(InternalAPIError.failedResponseParsing))
                        }
                    } catch {
                        completion(.failure(InternalAPIError.failedResponseParsing))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}

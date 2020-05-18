//
//  NetworkManager.swift
//  ProyectoOpenBank
//
//  Created by Juan Jimenez de Muñana Rivas on 17/05/2020.
//  Copyright © 2020 Juan Jimenez de Muñana Rivas. All rights reserved.
//

import Foundation
import Alamofire

struct ApiConnector {
    
    static var dataModel = dataVariables.init()
    static private var connector = AlamofireConnector()
    static private func getHeaders() -> HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
    }
    static private func getUrl(from api: String) -> URL? {
        let BASE_URL = ""
        let apiUrl = api.contains("http") ? api : BASE_URL + api
        return URL(string: apiUrl)
    }
    
    static private func getParams() -> [String: String] {
        return [
            "apikey": dataModel.apikey,
            "hash": dataModel.hash,
            "ts": "1"
        ]
    }
    
    static public func additionalParams(limit: Int) -> [String: String]{

        let limitStr = String(limit)
        return [
            "apikey": dataModel.apikey,
            "hash": dataModel.hash,
            "ts": "1",
            "offset": limitStr
        ]
    }
    
    static func request(_ api: String,
                        method: HTTPMethod,
                        params: [String: Any]? = nil,
                        headers: HTTPHeaders? = nil,
                        successJsonAction: ((_ result: AnyObject) -> Void)? = nil,
                        successDataAction: ((Data) -> Void)? = nil,
                        failAction: ((_ error: knError) -> Void)? = nil) {
        let finalHeaders = headers ?? getHeaders()
        let parameters = params ?? getParams()
        let apiUrl = getUrl(from: api)
        connector.run(withApi: apiUrl,
                      method: method,
                      params: parameters,
                      headers: finalHeaders,
                      successJsonAction: successJsonAction,
                      successDataAction: successDataAction,
                      failAction: failAction)
    }
    
    static func requestMore(_ api: String,
                        method: HTTPMethod,
                        params: [String: Any]? = nil,
                        headers: HTTPHeaders? = nil,
                        successJsonAction: ((_ result: AnyObject) -> Void)? = nil,
                        successDataAction: ((Data) -> Void)? = nil,
                        failAction: ((_ error: knError) -> Void)? = nil, offset: Int) {
        let finalHeaders = headers ?? getHeaders()
        let parameters = params ?? additionalParams(limit: offset)
        let apiUrl = getUrl(from: api)
        connector.run(withApi: apiUrl,
                      method: method,
                      params: parameters,
                      headers: finalHeaders,
                      successJsonAction: successJsonAction,
                      successDataAction: successDataAction,
                      failAction: failAction)
    }
}

struct AlamofireConnector {
    fileprivate func run(withApi api: URL?,
                         method: HTTPMethod,
                         params: [String: Any]? = nil,
                         headers: HTTPHeaders? = nil,
                         successJsonAction: ((_ result: AnyObject) -> Void)? = nil,
                         successDataAction: ((Data) -> Void)? = nil,
                         failAction: ((_ error: knError) -> Void)?) {
        guard let api = api else {
            failAction?(InvalidAPIError(api: "nil"))
            return
        }
        let encoding: ParameterEncoding = method == .get ?
            URLEncoding.queryString :
            JSONEncoding.default
        AF.request(api, method: method,
                          parameters: params,
                          encoding: encoding,
                          headers: headers)
            .responseJSON { (returnData) in
                self.answer(response: returnData,
                            successJsonAction: successJsonAction,
                            successDataAction: successDataAction,
                            failAction: failAction)

//                print("PARAMS: \(params)")
        }
    }
    
    private func answer(response: AFDataResponse<Any>,
                        successJsonAction: ((_ result: AnyObject) -> Void)? = nil,
                        successDataAction: ((Data) -> Void)? = nil,
                        failAction fail: ((_ error: knError) -> Void)?) {
        if let statusCode = response.response?.statusCode {
            if statusCode == 500 {
                return
            }
            // handle status code here: 401 -> show logout; 500 -> show error
        }
        
        if let error = response.error {
            let err = knError(code: "unknown", message: error.localizedDescription)
            fail?(err)
            return
        }
        
        guard let json = response.result as AnyObject?, let data = response.data else {
            // handle unknown error
            return
        }
        
        // handle special error convention from server
        // ...
        
        if let successDataAction = successDataAction {
            successDataAction(data)
            return
        }
        successJsonAction?(json)
    }
}

class knError {
    var code: String = "unknown"
    var message: String?
    var rawData: AnyObject?
    var displayMessage: String {
        return message ?? code
    }
    
    init() {}
    init(code: String, message: String? = nil, rawData: AnyObject? = nil) {
        self.code = code
        self.message = message
        self.rawData = rawData
    }
}

class InvalidAPIError: knError {
    private override init() {
        super.init()
    }
    
    private override convenience init(code: String, message: String? = nil, rawData: AnyObject? = nil) {
        self.init()
    }
    convenience init(api: String) {
        self.init()
        code = "404"
        message = "Invalid API Endpoint"
        rawData = api as AnyObject
    }
}

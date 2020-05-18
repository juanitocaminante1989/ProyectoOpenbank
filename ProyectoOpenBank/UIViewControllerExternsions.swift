//
//  UIViewControllerExternsions.swift
//  ProyectoOpenBank
//
//  Created by Juan Jimenez de Muñana Rivas on 18/05/2020.
//  Copyright © 2020 Juan Jimenez de Muñana Rivas. All rights reserved.
//

import Foundation
import UIKit

class UIViewControllerExtension: UIViewController {
    
    var numOfRows = 0
    var result : response?
    var characters : [Character] = []
    var dataModel = dataVariables.init()
    
    func decode(api: String, completion: @escaping (_ success: Bool) -> Void) {
        ApiConnector.request(api, method: .get, successDataAction: { (data) in
            do {
                self.result = try JSONDecoder().decode(response.self, from: data)
                completion(true)
            } catch let jsonErr {
                print("Fail to decode json", jsonErr)
            }
        })
    }
    
    func loadMore(api: String, offset: Int, completion:@escaping (_ success: Bool) -> Void) {
        ApiConnector.requestMore(api, method: .get, successDataAction: { (data) in
            do {
                self.result = try JSONDecoder().decode(response.self, from: data)
                completion(true)
            } catch let jsonErr {
                print("Fail to decode json", jsonErr)
            }
        }, offset: numOfRows)
    }
}

//
//  DetailViewController.swift
//  ProyectoOpenBank
//
//  Created by Juan Jimenez de Muñana Rivas on 18/05/2020.
//  Copyright © 2020 Juan Jimenez de Muñana Rivas. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewControllerExtension {
    
    var api = ""
    var character : DetailCharacter?
    
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decode(api: api) { (success) -> Void in
            self.getData()
        }
    }
    
    
    
    func getData(){
        for index in 0..<((result?.data.results.count)!){
            let characterRaw = result?.data.results[index]
            character = DetailCharacter()
            if let id = characterRaw?.id {
                character!.id = id
            }else{
                character!.id = 0
            }
            
            if let name = characterRaw?.name {
                character!.name = name
            }else{
                character!.name = ""
            }
            
            if let path = (characterRaw?.thumbnail.path) {
                if let extensin = characterRaw?.thumbnail.extensin {
                    character!.path = path + "." + extensin
                }else{
                    character!.path = path + ".jpg"
                }
            }else{
                character!.path = ""
            }
            
            if let description = characterRaw?.description {
                if description.isEmpty {
                    character?.description = "No description available"
                }else{
                    character!.description = description
                }
            }else{
                character?.description = "No description available"
            }
            
            characterName.text = character?.name
            let path = character!.path
            let url = URL(string: path)
            characterImage.kf.setImage(with: url)
            characterDescription.text = character?.description
            
        }
    }
}




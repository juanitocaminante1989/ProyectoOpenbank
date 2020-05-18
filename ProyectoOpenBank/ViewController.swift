//
//  ViewController.swift
//  ProyectoOpenBank
//
//  Created by Juan Jimenez de Muñana Rivas on 17/05/2020.
//  Copyright © 2020 Juan Jimenez de Muñana Rivas. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewControllerExtension, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! CustomCell
        let index : Int = indexPath.row
        
        let charactr = characters[index]
        let text = (charactr.name)

        cell.label.text = text
        let path = charactr.path
        let url = URL(string: path)
        cell.imageCell.kf.setImage(with: url)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = numOfRows - 1
        if indexPath.row == lastElement {
            
            numOfRows = numOfRows + (result?.data.count)!
            loadMore(api: dataModel.api, offset: numOfRows){ (success) -> Void in
                self.getData(updateRows: false
                )
            }
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.api = dataModel.api + "/\(characters[indexPath.row].id)"
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        decode(api: dataModel.api) { (success) -> Void in
            self.getData(updateRows: true)
        }
       
    }
    
    
    
    func getData(updateRows: Bool) -> Void{
        if updateRows {
            if let nRows = self.result?.data.count {
                numOfRows = nRows
            }else{
                numOfRows = 0
            }
        }
        
        for index in 0..<((result?.data.results.count)!){
            let characterRaw = result?.data.results[index]
            let character = Character()
            
            if let id = characterRaw?.id {
                character.id = id
            }else{
                character.id = 0
            }
            
            if let name = characterRaw?.name {
                character.name = name
            }else{
                character.name = ""
            }
            
            if let path = (characterRaw?.thumbnail.path) {
                if let extensin = characterRaw?.thumbnail.extensin {
                    character.path = path + "." + extensin
                }else{
                     character.path = path + ".jpg"
                }
            }else{
                character.path = ""
            }
            
            characters.append(character)
        }
        tableView.reloadData()
    }
}




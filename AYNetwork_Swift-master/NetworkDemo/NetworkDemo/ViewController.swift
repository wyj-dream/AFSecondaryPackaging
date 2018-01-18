//
//  ViewController.swift
//  NetworkDemo
//
//  Created by Andy on 2017/7/17.
//  Copyright © 2017年 AndyCuiYTT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
//        Bundle.main.path(forResource: "123", ofType: "zip")
//        
//        
//        let data = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "123", ofType: "png")!))
//        
//        print(data)
//        
//        NetworkManager.networkUpload("http://localhost:8080/MavenDemo/userApi", params: ["id":"12", "method":"uploadfile","dddd":"sddssd"], filesData: [data,data,data,data], fileName: "image", fileExtensions: "png", contentType: "image/png", result: { (data) in
//            print(data)
//        }) { (error) in
//            print(error)
//        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func test(_ sender: Any) {
        
        YTTNetworkManager.post("http://localhost:8080/MavenDemo/userApi", params: ["id":"12","method":"getUser"], isCache: true, result: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
        

        
        
    }

}


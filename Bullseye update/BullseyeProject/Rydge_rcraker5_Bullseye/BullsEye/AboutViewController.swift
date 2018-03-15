//
//  AboutViewController.swift
//  BullsEye
//
//  Created by Rydge Craker on 1/25/18.
//  Copyright © 2018 Cooley, Jon. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Find the bullseye html file by getting the url to it.
        if let url = Bundle.main.url(forResource: "BullsEye", withExtension: "html"){
            //Convert to data we can use
            if let htmlData = try? Data(contentsOf: url){
                //obtain base URL for the project
                let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                
                //Load the data into the web view
                webView.load(htmlData, mimeType: "text/html", characterEncodingName: "UTF-8", baseURL: baseURL)
                
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func close(){
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

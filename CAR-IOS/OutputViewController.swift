//
//  OutputViewController.swift
//  CAR-IOS
//
//  Created by 生广明 on 19/8/2020.
//  Copyright © 2020 生广明. All rights reserved.
//

import UIKit

class OutputViewController: UIViewController {

    @IBOutlet weak var DownScaleImageView: UIImageView!
    @IBOutlet weak var UpScaleImageView: UIImageView!
    @IBOutlet weak var CloseButton: UIButton!
    
    var DownScaleImage : UIImage!
    var UpScaleImahge : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func Close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

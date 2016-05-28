//
//  ViewControllerDoctorEdit.swift
//  MedHelp
//
//  Created by Luiz Daniel Ramos Franca on 5/27/16.
//  Copyright © 2016 MedHelp. All rights reserved.
//

import UIKit

class ViewControllerDoctoEdit: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    var userType : String = ""
    var id : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.styleCircleForImage(self.profilePicture)
    }
    
    func styleCircleForImage(image:UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2.0
        image.clipsToBounds = true
        image.userInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        NSLog("tap")
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

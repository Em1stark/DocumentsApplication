//
//  ChangeObjectViewController.swift
//  MyDocs
//
//  Created by Алексей Шахов on 18.12.2021.
//

import UIKit



class FullPictureViewController: UIViewController {

    @IBOutlet weak var fullImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullImage.layer.cornerRadius = 32
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                        fullImage.addGestureRecognizer(tapGR)
                        fullImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    @objc func imageTapped(sender: UITapGestureRecognizer) {
                    if sender.state == .ended {
                        dismiss(animated: true, completion: nil)
                    }
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

//
//  ResultViewController.swift
//  YFSMM
//
//  Created by wb on 2017/9/11.
//  Copyright © 2017年 Alvin. All rights reserved.
//

import UIKit



class ResultViewController: BaseVC {
    
    @IBOutlet weak var resultContent: UILabel!
    
    @IBOutlet weak var waterup: UILabel!
    
    @IBOutlet weak var oile: UILabel!
    
    @IBOutlet weak var jinzhi: UILabel!
    
    @IBOutlet weak var tanxin: UILabel!
    @IBOutlet weak var closeBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeBtn.setCornerBorderWithCornerRadii(self.closeBtn.frame.height / 2 , width: 1, color: UIColorHex("999999"))

        // Do any additional setup after loading the view.
        let max: UInt32 = 15
        let min: UInt32 = 5
        
        let water:UInt32 = (arc4random_uniform(max - min) + min)
        waterup.text = "\(water)"
        
        let oi:UInt32 = (arc4random_uniform(9 - min) + min)
        oile.text = "\(oi)";
        
        let tanmax: UInt32 = 6
        let tanmin: UInt32 = 2
        let jin:Float = (Float(arc4random_uniform(tanmax - tanmin) + tanmin))
        let ss:Float = Float(arc4random() % 10)
        let jinxiaoshu:Float = ss / 10;
        let jinresult:Float = jin + jinxiaoshu;
        jinzhi.text = "\(jinresult)";
        
        let tan:Float = (Float(arc4random_uniform(tanmax - tanmin) + tanmin))
        let yy:Float = Float(arc4random() % 10)
        let tanxiaoshu:Float = yy / 10;
        let tanresult:Float = tan + tanxiaoshu;
        tanxin.text = "\(tanresult)";
        
        let jinInt:UInt32 = UInt32(jin)
        let tanInt:UInt32 = UInt32(tan)
        
        let sum:UInt32 = water + oi + jinInt + tanInt
        resultContent.text = "颜值上升约"+"\(sum)";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

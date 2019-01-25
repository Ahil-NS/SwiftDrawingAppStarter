//
//  ViewController.swift
//  SwiftDrawingAppStarter
//
//  Created by MacBook on 1/24/19.
//  Copyright © 2019 Ahil. All rights reserved.
//

import UIKit

class MainDrawerVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    //he point with location (0,0).
    var lastPoint = CGPoint.zero
    
    var swiped = false
    var red : CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var lineWidth: CGFloat = 4.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        changeLabel()
    }

    //one or more new touches occurred in a view or window.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = false
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
        
    }
    // when one or more touches associated with an event changed.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLine(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    // one or more fingers are raised from a view or window.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped{
            drawLine(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint){
        
        //Creates a bitmap-based graphics context and makes it the current context.
        UIGraphicsBeginImageContext(view.frame.size)
        
        //Returns the current graphics context.
        let context = UIGraphicsGetCurrentContext()
        
        //Draws the entire image in the specified rectangle, scaling it as needed to fi
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        //Removes the current bitmap-based graphics context from the top of the stack.
        UIGraphicsEndImageContext()
        
        
    }
    
    
    @IBAction func redTapped(_ sender: Any) {
        (red,green,blue) = (255,0,0)
    }
    
    @IBAction func greenTapped(_ sender: Any) {
        (red,green,blue) = (0,255,0)
    }
    
    @IBAction func whiteEraserTapped(_ sender: Any) {
         (red,green,blue) = (255,255,255)
    }
    @IBAction func increaseLineWidth(_ sender: Any) {
        lineWidth += 1
        changeLabel()
    }
    @IBAction func reduceLineWidth(_ sender: Any) {
        lineWidth -= 1
        changeLabel()
    }
    
    func changeLabel(){
        self.widthLabel.text = String(format: "%.0f", lineWidth)
        
        if(lineWidth == 20){
            plusButton.isEnabled = false
            plusButton.alpha = 0.5
        }
        else if(lineWidth == 1){
            minusButton.isEnabled = false
            minusButton.alpha = 0.5
        }
        else{
            plusButton.isEnabled = true
            minusButton.isEnabled = true
            plusButton.alpha = 1
            minusButton.alpha = 1
        }
    }
    @IBAction func resetButtonPressed(_ sender: Any) {
        imageView.image = nil
    }
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        if
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingVC =  segue.destination as? SettingsVC else{return}
        settingVC.delegate = self
        settingVC.brushSize = lineWidth
        settingVC.red = self.red
        settingVC.green = self.green
        settingVC.blue = self.blue
    }
}


extension MainDrawerVC: settingVCDelegate{
    func settingVCFinishEditing(settingVC: SettingsVC) {
        self.lineWidth = settingVC.brushSize
        self.red = settingVC.red
        self.green = settingVC.green
        self.blue = settingVC.blue
        
        changeLabel()
    }
    
  
    
    
}

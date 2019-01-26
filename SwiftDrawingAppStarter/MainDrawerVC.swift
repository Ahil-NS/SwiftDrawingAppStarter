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
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    //he point with location (0,0).
    var lastPoint = CGPoint.zero
    
    var swiped = false
    var red : CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    var opacity: CGFloat = 1.0
    
    var lineWidth: CGFloat = 4.0
    
    var hideState = false
    
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
    //Get first imageview and second imageview and combined them both here
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped{
            drawLine(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        UIGraphicsBeginImageContext(secondImageView.frame.size)
        
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        secondImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        secondImageView.image = nil
        
    }
    
    //Draw in second imageview after finishing it place it in to first imageview
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint){
        
        //Creates a bitmap-based graphics context and makes it the current context.
        UIGraphicsBeginImageContext(view.frame.size)
        
        //Returns the current graphics context.
        let context = UIGraphicsGetCurrentContext()
        
        //Draws the entire image in the specified rectangle, scaling it as needed to fi
        secondImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        secondImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        secondImageView.alpha = opacity
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingVC =  segue.destination as? SettingsVC else{return}
        settingVC.delegate = self
        settingVC.brushSize = lineWidth
        settingVC.red = self.red
        settingVC.green = self.green
        settingVC.blue = self.blue
        settingVC.opacity = self.opacity 
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //view controller that you use to offer standard services from your app.
        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func hideRevalButtonTapped(_ sender: Any) {
        
        if(hideState){
            bottomStackView.isHidden = false
            resetButton.isHidden = false
            settingButton.isHidden = false
            saveButton.isHidden = false
            hideButton.setTitle("Hide", for: .normal)
            hideButton.alpha = 1
            hideState = false
        }
        else{
            bottomStackView.isHidden = true
            resetButton.isHidden = true
            settingButton.isHidden = true
            saveButton.isHidden = true
            hideButton.setTitle("Reveal", for: .normal)
            hideButton.alpha = 0.3
            hideState = true
            
        }
        
    }
    
}


extension MainDrawerVC: settingVCDelegate{
    func settingVCFinishEditing(settingVC: SettingsVC) {
        self.lineWidth = settingVC.brushSize
        self.red = settingVC.red
        self.green = settingVC.green
        self.blue = settingVC.blue
        self.opacity = settingVC.opacity
        
        
        changeLabel()
    }
    
    
    
    
}

//
//  SettingsVC.swift
//  SwiftDrawingAppStarter
//
//  Created by MacBook on 1/25/19.
//  Copyright © 2019 Ahil. All rights reserved.
//

import UIKit


protocol settingVCDelegate {
    func settingVCFinishEditing(settingVC : SettingsVC)
}
class SettingsVC: UIViewController {
    
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var brushOpacitySlider: UISlider!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var brushSizeLabel: UILabel!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var brushSize: CGFloat = 5.0
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    
    var delegate: settingVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        brushSizeSlider.value = Float(brushSize)
        brushSizeLabel.text = String(format: "%.0f", brushSize)
        
        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
        
        redLabel.text = String(format: "%.0f", redSlider.value)
        greenLabel.text = String(format: "%.0f", greenSlider.value)
        blueLabel.text = String(format: "%.0f", blueSlider.value)
    }
    
    override func viewDidAppear(_ animated: Bool) {
          updatePreview()
    }
    @IBAction func brushSizeChanged(_ sender: Any) {
        brushSize = CGFloat(brushSizeSlider.value)
        brushSizeLabel.text = String(format: "%.0f", brushSize)
        updatePreview()
        
    }
    
    
    @IBAction func brushOpacityChanged(_ sender: Any) {
        
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        delegate?.settingVCFinishEditing(settingVC: self)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func redSliderChanged(_ sender: Any) {
        red = CGFloat(redSlider.value/255)
        redLabel.text = String(format: "%.0f", redSlider.value)
        updatePreview()
    }
    
    @IBAction func greenSliderChanged(_ sender: Any) {
        green = CGFloat(greenSlider.value/255)
        greenLabel.text = String(format: "%.0f", greenSlider.value)
        updatePreview()
    }
    
    @IBAction func blueSliderChanged(_ sender: Any) {
        blue = CGFloat(blueSlider.value/255)
        blueLabel.text = String(format: "%.0f", blueSlider.value)
        updatePreview()
    }
    
    
    func updatePreview(){
        UIGraphicsBeginImageContext(imageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1)
        context?.move(to: CGPoint(x: 60, y: 60))
        context?.addLine(to: CGPoint(x: 60, y: 60))
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

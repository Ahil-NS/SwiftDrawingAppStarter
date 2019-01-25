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
    
    //he point with location (0,0).
    var lastPoint = CGPoint.zero
    
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        context?.setLineWidth(5.0)
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
        context?.setBlendMode(CGBlendMode.normal)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        //Removes the current bitmap-based graphics context from the top of the stack.
        UIGraphicsEndImageContext()
        
        
    }

}


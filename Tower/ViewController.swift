//
//  ViewController.swift
//  Tower
//
//  Created by Juan Manuel Jimenez Sanchez on 31/01/17.
//  Copyright © 2017 Juan Manuel Jimenez Sanchez. All rights reserved.
//

import UIKit

enum BoxColor: Int {
    case Blue = 0
    case Green = 1
    case Red = 2
    case Orange = 3
    case Yellow = 4
}

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var gravity: UIGravityBehavior!
    var collition: UICollisionBehavior!
    var animator: UIDynamicAnimator!
    
    var boxCounter: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gravity = UIGravityBehavior()
        self.collition = UICollisionBehavior()
        self.collition.collisionDelegate = self
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        self.animator.addBehavior(self.gravity)
        self.animator.addBehavior(self.collition)
        //Esta linea hace que el punto de colisión sea el borde la ventana
        self.collition.setTranslatesReferenceBoundsIntoBoundary(with: .zero)
    }
    
    func viewTapped(tapGesture: UITapGestureRecognizer) {
        let point = tapGesture.location(ofTouch: 0, in: self.view)
        self.addBox(x:Int(point.x), y:Int(point.y))
    }
    
    func addBox(x: Int, y: Int) {
        self.boxCounter += 1
        
        let randomColor = self.randomColor()
        let randomSize = self.randomSize()
        
        let view = UIView(frame: CGRect(x: CGFloat(x - randomSize.width/2), y: CGFloat(y), width: CGFloat(randomSize.width), height: CGFloat(randomSize.height)))
        
        view.tag = self.boxCounter
        view.backgroundColor = randomColor
        self.view.addSubview(view)
        
        self.gravity.addItem(view)
        self.collition.addItem(view)
    }

    func randomColor() -> UIColor {
        let randomNumber = Int(arc4random_uniform(UInt32(5)))
        let color: BoxColor = BoxColor(rawValue: randomNumber)!
        
        switch color {
        case .Blue:
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .Green:
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .Red:
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .Orange:
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        case .Yellow:
            return #colorLiteral(red: 0.9450980392, green: 0.768627451, blue: 0.05882352941, alpha: 1)
        }
    }
    
    func randomSize() -> (width:Int, height:Int) {
        let height = Int(arc4random_uniform(UInt32(100))) + 30
        let width = Int(arc4random_uniform(UInt32(100))) + 30
        
        return (width, height)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        print("Identificador: \(identifier)")
        if let view = item as? UIView {
            if view.tag > 1 {
                let alertVC = UIAlertController(title: "Game Over", message: "You lose!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                
                alertVC.addAction(alertAction)
                present(alertVC, animated: true, completion: { 
                    //Eliminamos todas las cajas
                    for view in self.view.subviews {
                        self.gravity.removeItem(view)
                        self.collition.removeItem(view)
                        view.removeFromSuperview()
                    }
                    self.boxCounter = 0
                })
            }
        }
    }
}


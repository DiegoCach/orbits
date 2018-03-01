//
//  ViewController.swift
//  pruebas_orbitas3
//
//  Created by alumnos on 21/2/18.
//  Copyright © 2018 cev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var a = 40.0
    var cornerRad = 20.0
    var arrPos:[Double] = [Double]()
    var arrFin:[Double] = [Double]()
    var b = 3.000
    
    var arrayShapes:[UIView] = [UIView]()
    
    @objc var timer = Timer()
    var seconds = 0
    
    var pos = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addCircle(_ sender: Any) {
        if a < 200.0   && !arrPos.contains(a) {
            arrPos.append(a)
            arrFin.append(a)
            let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: a, height: a))
            
            circle.center = self.view.center
            circle.layer.cornerRadius = CGFloat(cornerRad)
            circle.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            circle.layer.borderWidth = CGFloat(b)
            circle.layer.borderColor = UIColor.red.cgColor
            //circle.layer.backgroundColor = UIColor.yellow.cgColor
            
            circle.clipsToBounds = true
            
            let pinchCircle = UIPinchGestureRecognizer(target: self, action: #selector(changeSize))
            //let longPressCircle = UILongPressGestureRecognizer(target: self, action: #selector(erraseCircle))
            circle.addGestureRecognizer(pinchCircle)
            //circle.addGestureRecognizer(longPressCircle)
            
            self.view.addSubview(circle)
            arrayShapes.append(circle)

            a += 40.0
            cornerRad += 20.0
        } else {
            //print("EXISTE \(a)")
            while arrPos.contains(a) || a == 200.0{
                if arrPos.contains(40.0) && arrPos.contains(80.0) && arrPos.contains(120.0) && arrPos.contains(160.0){
                    break
                }
                
                if a == 200.0{
                    a = 0
                    cornerRad = 0
                }
                a += 40.0
                cornerRad += 20.0
                addCircle((Any).self)
                if arrPos.contains(40.0) && arrPos.contains(80.0) && arrPos.contains(120.0) && arrPos.contains(160.0){
                    break
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func changeSize(sender: UIPinchGestureRecognizer) {
        
        if let view = sender.view {
            if sender.state == .changed {
                view.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    
                let maxScale: CGFloat = 300 //Anything
                let minScale: CGFloat = 0.5 //Anything
                let scale = view.frame.size.width
                if scale > maxScale {
                    view.transform = CGAffineTransform(scaleX: maxScale / scale, y: maxScale / scale)
                    arrFin[pos] = Double(view.frame.size.width)
                }
                else if scale < minScale {
                    view.transform = CGAffineTransform(scaleX: minScale / scale, y: minScale / scale)
                    arrFin[pos] = Double(view.frame.size.width)
                } else {
                    arrFin[pos] = Double(view.frame.size.width)
                }

                for (i, _) in arrayShapes.enumerated() {
                    if arrayShapes[i].frame.width < view.frame.size.width{
                        self.view.sendSubview(toBack: view)
                    }
                }
            }
            
            if sender.state == .ended {
                for (z, _) in arrFin.enumerated() where z != pos{
                    print("INSIDE LOOP --------> \(arrFin[pos])")
                    let sum = arrFin[pos] - arrFin[z]
                    let res = arrFin[z] - arrFin[pos]
                    if arrFin[pos] == arrFin[z] || sum <= 20 || res >= -20{
                        arrFin[pos] = arrPos[pos]
                        sender.view?.layer.masksToBounds = true
                        print("___________________")
                        print(sender.view?.frame.size.width)
                        //sender.view?.frame.size.width = CGFloat(arrPos[pos])
                       // sender.view?.frame.size.height = CGFloat(arrPos[pos])
                        sender.view?.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: CGFloat(arrPos[pos]), height: CGFloat(arrPos[pos]))
                        sender.view?.center = self.view.center
                        print(sender.view?.frame.size.width)
                        sender.view?.layer.cornerRadius = CGFloat((sender.view?.frame.size.width)! / 2.0)
                        
                        print(sender.view?.layer.cornerRadius)
                        
                        
                        print(arrPos[pos])
                        break
                    }
                }
            }
        }
        
        timer.invalidate()
        seconds = 0
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,with event: UIEvent?){
        print("-----> IN TOUCEHES ENDED")
        let point = touches.first?.location(in: self.view)
        for (i, _) in arrayShapes.enumerated() {
            if let  myLayer = arrayShapes[i] as? UIView{ // If you hit a layer and if its a Shapelayer
                if (myLayer.frame.contains(point!)) { // Optional, if you are inside its content path
                    if seconds >= 3 {
                        print(myLayer) // Do something
                        myLayer.removeFromSuperview()
                        arrayShapes.remove(at: i)
                        arrPos.remove(at: i)
                        arrFin.remove(at: i)
                        print(seconds)
                        break
                    }
                } else {
                    print("NOT TOUCHED")
                }
            }
        }
        timer.invalidate()
        seconds = 0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(arrFin)
        let point = touches.first?.location(in: self.view)
        for (i, _) in arrayShapes.enumerated() {
            if let  myLayer = arrayShapes[i] as? UIView{ // If you hit a layer and if its a Shapelayer
                if (myLayer.frame.contains(point!)) { // Optional, if you are inside its content path
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
                    pos = i
                        break
                }
            }
        }
    }
    
    @objc func updateTimer(){
        seconds += 1
    }

}


//
//  ChatViewController.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

import AudioToolbox

class ChatViewController: UIViewController {

    var nickname: String!
    
    
    struct HeartAttributes {
        static let heartSize: CGFloat = 36
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTouchPos()
        listenTouchEnded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            SocketIOManager.sharedInstance.sendTouchPosition(position: position, withNickname: nickname)
            self.showTheLove(location: position)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            SocketIOManager.sharedInstance.sendTouchPosition(position: position, withNickname: nickname)
             self.showTheLove(location: position)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            SocketIOManager.sharedInstance.sendTouchEnded(nickname: nickname)
        }
    }
    
}


extension ChatViewController{
    
    func prepareView(){
    }
    
    func showTheLove(location: CGPoint) {
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //DPVibrateHelper.vibrate(with: DPVibration(duration: 50, delayDuration: 0))
        let heart = HeartView(frame: CGRect(x:0, y:0, width:HeartAttributes.heartSize, height:HeartAttributes.heartSize))
        view.addSubview(heart)
        heart.center = CGPoint(x: location.x, y: location.y)
        heart.animateInView(view: view)
    }
}

extension ChatViewController{
    
    func getTouchPos(){
        SocketIOManager.sharedInstance.getTouchPosition { (touchInfo) -> Void in
            let senderName = touchInfo["nickname"] as! String
            if senderName == self.nickname {
                return
            }
            
            let posDict = touchInfo["position"] as! [String: CGFloat]
            let position = CGPoint(x: posDict["x"]!, y: posDict["y"]!)
            
            DispatchQueue.main.async {
               self.showTheLove(location: position)
            }
        }
    }
    
    func listenTouchEnded(){
        SocketIOManager.sharedInstance.listenTouchEnded { (touchInfo) -> Void in
            let senderName = touchInfo["nickname"] as! String
            if senderName == self.nickname {
                return
            }
            DispatchQueue.main.async {
                
            }
        }

    }

}

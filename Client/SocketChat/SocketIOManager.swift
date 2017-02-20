//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Alex Manukyan on 2/16/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://10.18.205.238:3000")!, config:nil)
    
    override init() {
        super.init()
    }
}

extension SocketIOManager{
    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
        
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
        
        //listenForOtherMessages()
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
    
    
    func sendTouchPosition(position: CGPoint, withNickname nickname: String) {
        var pos = [String: Any]()
        pos["x"] = position.x
        pos["y"] = position.y
        socket.emit("touchPosition", nickname, pos)
    }
    
    func getTouchPosition(completionHandler: @escaping (_ touchInfo: [String: Any]) -> Void) {
        socket.on("newTouchPosition") { (dataArray, socketAck) -> Void in
            var touchDictionary = [String: AnyObject]()
            touchDictionary["nickname"] = dataArray[0] as AnyObject?
            touchDictionary["position"] = dataArray[1] as AnyObject?
            touchDictionary["date"] = dataArray[2] as AnyObject?
            
            completionHandler(touchDictionary)
            
        }
    }
    
    func sendTouchEnded(nickname: String) {
        socket.emit("touchEnded", nickname)
    }
    
    func listenTouchEnded(completionHandler: @escaping (_ touchInfo: [String: Any]) -> Void){
        socket.on("touchEnded") { (dataArray, socketAck) -> Void in
            var touchDictionary = [String: AnyObject]()
            touchDictionary["nickname"] = dataArray[0] as AnyObject?
            touchDictionary["date"] = dataArray[1] as AnyObject?
            completionHandler(touchDictionary)
        }
    }
    
    private func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
}

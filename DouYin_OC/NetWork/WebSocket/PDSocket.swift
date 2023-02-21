//
//  File.swift
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/12.
//

import Foundation
import SocketIO

@objcMembers
open class PDSocketManager: NSObject {
    private var ServerIP = "http://192.168.110.88:3000"
    private var date:Date?
    open class var shared: PDSocketManager {
       struct Static{
            static let instance = PDSocketManager()
        }
        return Static.instance
    }
    private var socket: SocketIOClient?
    private var manager: SocketManager?
    private weak var Receivedelegate : PDReceiveSocketDelegate?
    private weak var Chatdelegate : PDSocketChatDelegate?
    private weak var VideoSenddelegate : PDVideoSendSocketDelegate?
    private weak var VistorSenddelegate : PDVistorSendSocketDelegate?
    private weak var ConcernSenddelegate : PDConcernSendSocketDelegate?
    
    public override init(){}
    
    @objc open func SetReceiveDeleaget(Delgate delegate:PDReceiveSocketDelegate){
        self.Receivedelegate = delegate
    }
    

    @objc open func SetChatDeleaget(Delgate delegate:PDSocketChatDelegate){
        self.Chatdelegate = delegate
    }
    
    @objc open func SetVideoSenddelegate(Delgate delegate:PDVideoSendSocketDelegate){
        self.VideoSenddelegate = delegate
    }
    
    @objc open func SetVistorSenddelegate(Delgate delegate:PDVistorSendSocketDelegate){
        self.VistorSenddelegate = delegate
    }
    
    @objc open func SetConcernSenddelegate(Delgate delegate:PDConcernSendSocketDelegate){
        self.ConcernSenddelegate = delegate
    }
    
    
    @objc open func ConnectToServer(MyID:String,completion: (() -> Void)? = nil) {
        if(self.manager == nil){
            self.manager = SocketManager(socketURL: URL(string: ServerIP)!, config: [.log(true), .reconnects(true), .extraHeaders(["header": "customheader"])])
        }
        
        if(self.socket == nil){
            self.socket = manager?.defaultSocket
            
            self.socket!.on("chat") { [weak self]data, ack in
                // 收到的聊天消息
                if(self?.Chatdelegate != nil){
                    self?.Chatdelegate!.DidReceiveChatMessage(received: data)
                }
                if(self?.Receivedelegate != nil){
                    self?.Receivedelegate?.DidReceiveChatMessage(received:data)
                }
                if(self?.Chatdelegate != nil){
                    self?.Chatdelegate!.DidReceiveOtherMessage()
                }
                ack.with("DidReceived")
            }
            
            self.socket!.on("ReadResponse") { [weak self]data, ack in
                // 收到的已读消息
                if(self?.Chatdelegate != nil){
                    var string : String = ""
                    for item in data as! [String] {
                        string.append(item)
                    }
                    if(string == MyID){
                        self?.Chatdelegate?.DidReadMyMessage(didRead: string)
                    }
                }
            }
            
            self.socket!.on("Concern") { [weak self]data, ack in
                print("\(data)Concern")
                if(self?.Receivedelegate != nil){
                    self?.Receivedelegate?.DidReceiveConcern(received:data)
                }
                if(self?.Chatdelegate != nil){
                    self?.Chatdelegate!.DidReceiveOtherMessage()
                }
                ack.with("DidReceived")
            }
            
            self.socket!.on("Vistor") {[weak self]data, ack in
                // 收到别人访问的主页消息
//                var string : String = ""
//                for item in data as! [String] {
//                    string.append(item)
//                }
                print("\(data)Vistor")
                if(self?.Receivedelegate != nil){
                    self?.Receivedelegate?.DidReceiveVistor(received: data)
                }
                if(self?.Chatdelegate != nil){
                    self?.Chatdelegate!.DidReceiveOtherMessage()
                }
                ack.with("DidReceived")
            }
            
            self.socket!.on("Comment") { [weak self]data, ack in
                // 收到别人评论我的消息
                print("\(data)Comment")
                if(self?.Receivedelegate != nil){
                    self?.Receivedelegate?.DidReceiveComment(received: data)
                }
                if(self?.Chatdelegate != nil){
                    self?.Chatdelegate!.DidReceiveOtherMessage()
                }
                ack.with("DidReceived")
            }
            
            self.socket!.on("CommentLike") { [weak self]data, ack in
                // 收到别人评论我的消息
                print("\(data)CommentLike")
                if(self?.Receivedelegate != nil){
                    self?.Receivedelegate?.DidReceiveCommentLike(received: data)
                }
                if(self?.Chatdelegate != nil){
                    self?.Chatdelegate!.DidReceiveOtherMessage()
                }
                ack.with("DidReceived")
            }
            
            self.socket!.on("LikeVideo") { [weak self]data, ack in
                // 收到别人点赞我的视频消息
//                var string : String = ""
//                for item in data as! [String] {
//                    string.append(item)
//                }
                print("\(data)LikeVideo")
                if(self?.Receivedelegate != nil){
                    self?.Receivedelegate?.DidReceiveVideoLike(received: data)
                }
                if(self?.Chatdelegate != nil){
                    self?.Chatdelegate!.DidReceiveOtherMessage()
                }
                ack.with("DidReceived")
            }
            
            self.socket!.on("ChatinputState") { [weak self] data, ack in
                // 别人回复的时候的状态 正在输入中、停止输入
//                var string : String = ""
//                for item in data as! [String] {
//                    string.append(item)
//                }
                print("\(data)ChatinputState")
                if(self?.Chatdelegate != nil){
                    self?.Chatdelegate?.DidReceiveChatInputState(received: data)
                }
            }
            self.JoinRoom(RoomID: MyID)
        }
        
        if(self.manager!.status != SocketIOStatus.connected){
            self.socket!.connect()
            self.socket!.once(clientEvent: .connect, callback: { (data, emitter) in
                if completion != nil{
                    completion!()
                }
            })
        }
    }
    
    
    @objc open func JoinRoom(RoomID:String){
        self.socket!.emitWithAck("joinRoom", RoomID).timingOut(after: 3) { callBack in
            // 加入只有自己一个人存在房间
            var string : String = ""
            for item in callBack as! [String] {
                string.append(item)
            }
            if( self.Receivedelegate != nil ){
                self.Receivedelegate?.DidSendJoinRoom(callBack: string)
            }
        }
    }
    
    
    @objc open func SendChatinputState(RoomID:String,State:String,MyID:String){
        self.socket!.emit("ChatinputState", [
            "RoomID":RoomID,
            "Message":[
                "status":MyID,
                "msg":State
            ]
        ])
    }
    
    @objc open func SendVideoLove(ObjectId:String,MyID:String,likeVideoID:String){
        self.socket!.emitWithAck("LikeVideo", [
            "Message":[
                "likeID":MyID,
                "likeVideoID":likeVideoID
            ],
            "ObjectId":ObjectId,
        ]).timingOut(after: 3) { callback in
            if(self.VideoSenddelegate != nil){
                var string : String = ""
                for item in callback as! [String] {
                    string.append(item)
                }
                self.VideoSenddelegate?.DidSendVideoLike(callBack: string)
            }
        }
    }
    
    @objc open func SendVistor(VistorId:String,MyID:String,likeVideoID:String){
        self.socket!.emitWithAck("Vistor", [
            "Message":MyID,
            "ObjectId":VistorId,
        ]).timingOut(after: 3) { callback in
            if(self.VistorSenddelegate != nil){
                var string : String = ""
                for item in callback as! [String] {
                    string.append(item)
                }
                self.VistorSenddelegate?.DidSendVistor(callBack: string)
            }
        }
    }
    
    @objc open func SendObjectConcern(ConcernObjectId:String,MyID:String,MyName:String){
        self.socket!.emitWithAck("Concern", [
            "Message":[
                "status":MyName,
                "msg":MyID
            ],
            "ObjectId":ConcernObjectId,
        ]).timingOut(after: 3) { callback in
            if(self.ConcernSenddelegate != nil){
                print("ConcernSenddelegate\(callback)")
//                var string : String = ""
//                for item in callback as! [String] {
//                    string.append(item)
//                }
//                self.ConcernSenddelegate?.DidSendConcern(callBack: string)
            }
        }
    }
    
    @objc open func SendComment(CommentObjectID:String,MyID:String,CommentMessage:String){
        // 知道你评论的是谁 我是谁 评论的内容
        self.socket!.emitWithAck("Comment", [
            "Message":[
                "status":MyID,
                "msg":CommentMessage
            ],
            "ObjectId":CommentObjectID,
        ]).timingOut(after: 3) { callback in
            if(self.VideoSenddelegate != nil){
                var string : String = ""
                for item in callback as! [String] {
                    string.append(item)
                }
                self.VideoSenddelegate?.DidSendComment(callBack: string)
            }
        }
    }
    
    @objc open func SendCommentLike(CommentObjectID:String,MyID:String,VideoID:String,CommentID:String){
        // 知道喜欢我的评论是谁 喜欢的评论是哪一个
        self.socket!.emitWithAck("CommentLike", [
            "Message":MyID,
            "ObjectId":CommentObjectID,
        ]).timingOut(after: 3) { callback in
            if(self.VideoSenddelegate != nil){
                var string : String = ""
                for item in callback as! [String] {
                    string.append(item)
                }
                self.VideoSenddelegate?.DidSendCommentLike(callBack: string)
            }
        }
    }
    
    @objc open func SendMessageWithRoomID(ID RoomID:String,message Message:String,MyName:String){
        self.socket!.emitWithAck("TalkInRoomWithID", [
            "RoomID":RoomID,
            "Message":[
                "status":MyName,
                "msg":Message
            ]
        ]).timingOut(after: 3) { callback in
            if(self.Chatdelegate != nil){
                print("\(callback.first)TalkInRoomWithIDCallBack")
                var string : String = ""
                for item in callback.first as! [String] {
                    string.append(item)
                }
                self.Chatdelegate?.DidSendChatMessage(callBack:string)
            }
        }
    }
    
    @objc open func HasReadMessage(RoomId:String,ObjectID:String){
        self.socket!.emit("ReadResponse", [
            "RoomID":RoomId,
            "Message":ObjectID,
        ])
    }
    
    private func connect()  {
        socket?.connect()
    }

    private func disconnect()  {
        socket?.disconnect()
    }
}



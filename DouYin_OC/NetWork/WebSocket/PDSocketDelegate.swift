//
//  PDSocketDelegate.swift
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/12.
//

import Foundation
import SocketIO

@objc public protocol PDReceiveSocketDelegate{
    // 从服务器中接受得到的消息
    func DidReceiveConcern(received:[Any])->Void
    func DidReceiveVistor(received:[Any])->Void
    func DidReceiveComment(received:[Any])->Void
    func DidReceiveCommentLike(received:[Any])->Void
    func DidReceiveVideoLike(received:[Any])->Void
    func DidReceiveChatMessage(received:[Any])->Void
    
    func DidSendJoinRoom(callBack:String)->Void
}


@objc public protocol PDVideoSendSocketDelegate{
    func DidSendComment(callBack:String) -> Void
    func DidSendCommentLike(callBack:String) -> Void
    func DidSendVideoLike(callBack:String) -> Void
}

@objc public protocol PDVistorSendSocketDelegate{
    func DidSendVistor(callBack:String) -> Void
}

@objc public protocol PDConcernSendSocketDelegate{
    func DidSendConcern(callBack:String) -> Void
}

@objc public protocol PDSocketChatDelegate{
    func DidReceiveOtherMessage()->Void
    func DidReceiveChatMessage(received:[Any])->Void
    func DidReceiveChatInputState(received:[Any])->Void
    func DidReadMyMessage(didRead:String)->Void
    
    func DidSendChatMessage(callBack:String) -> Void
}



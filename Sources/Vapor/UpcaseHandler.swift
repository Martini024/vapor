//
//  UpcaseHandler.swift
//  
//
//  Created by Martini Reinherz on 28/7/22.
//

import NIO

final class UpcaseHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias InboundOut = String
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        print("UpcaseHandler")
        let inBuff = self.unwrapInboundIn(data)
        let str = inBuff.getString(at: 0, length: inBuff.readableBytes)
        
        let result = str?.uppercased() ?? ""
        
        context.fireChannelRead(self.wrapInboundOut(result))
    }
}

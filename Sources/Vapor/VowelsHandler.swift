//
//  VowelsHandler.swift
//  
//
//  Created by Martini Reinherz on 28/7/22.
//

import NIO

final class VowelsHandler: ChannelInboundHandler {
    public typealias InboundIn = String
    public typealias InboundOut = ByteBuffer
    
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let str = self.unwrapInboundIn(data)
        
        let vowels: [Character] = ["a","e","i","o","u", "A", "E", "I", "O", "U"]
        let result = String(str.map { return vowels.contains($0) ? "*" : $0 })
        
        var buffOut = context.channel.allocator.buffer(capacity: result.count )
        buffOut.writeString(result)
        
        context.fireChannelRead(self.wrapInboundOut(buffOut))
    }
}

import NIO
import NIOHTTP1

public final class Application {
    public let eventLoopGroupProvider: EventLoopGroupProvider
    public let eventLoopGroup: EventLoopGroup
    var channel: Channel? = nil

    public enum EventLoopGroupProvider {
        case shared(EventLoopGroup)
        case createNew
    }
    
    public init(_ eventLoopGroupProvider: EventLoopGroupProvider) {
        self.eventLoopGroupProvider = eventLoopGroupProvider
        switch eventLoopGroupProvider {
        case .shared(let eventLoopGroup):
            self.eventLoopGroup = eventLoopGroup
        case .createNew:
            self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        }
    }
    
    public func run() throws {
        let bootstrap = ServerBootstrap(group: eventLoopGroup)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .serverChannelInitializer { channel in
                var handlers: [RemovableChannelHandler] = []
                handlers.append(ByteToMessageHandler(HTTPRequestDecoder(
                    leftOverBytesStrategy: .forwardBytes
                )))
                return channel.pipeline.addHandlers(handlers)
            }
            .childChannelOption(ChannelOptions.tcpOption(.tcp_nodelay), value: 1)
            .childChannelOption(ChannelOptions.socketOption(.so_reuseaddr), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
        
        let defaultHost = "127.0.0.1"
        let defaultPort = 8080
        
        self.channel = try bootstrap.bind(host: defaultHost, port: defaultPort).wait()
    }
}


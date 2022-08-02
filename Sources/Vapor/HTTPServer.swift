//
//  File.swift
//  
//
//  Created by Martini Reinherz on 1/8/22.
//

public enum HTTPVersionMajor {
    case one
    case two
}

public final class HTTPServer {
    public struct Configuration {
        public static let defaultHostname = "127.0.0.1"
        public static let defaultPort = 8080
    }
}

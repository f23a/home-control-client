//
//  HTTPURLResponse.swift
//  home-control-client
//
//  Created by Christoph Pageler on 28.09.24.
//

import Foundation

extension HTTPURLResponse {
    var statusCodeType: HTTPStatusCodeType? { .init(statusCode: statusCode) }
}

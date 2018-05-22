//
// Created by Ryan Liang on 5/19/18.
// Copyright (c) 2018 Ryan Liang. All rights reserved.
//

import Foundation

protocol Provider {
    associatedtype T where T: Endpoint
}

class RegularProvider<Target: Endpoint>: Provider {

    typealias T = Target

    typealias Completion<Type> = (Result<Type>, URLResponse?) -> Void

    @discardableResult
    func getData(_ target: Target, completionHandler: @escaping Completion<Data>) -> URLSessionDataTask? {

        do {

            let request = try target.urlRequest()
            let task = URLSession.shared.dataTask(with: request) {

                data, response, error in

                if let error = error, let _ = data {

                    completionHandler(Result.failure(error), response)
                    return
                }

                completionHandler(Result.success(data!), response)
            }

            task.resume()
            return task
        } catch {

            completionHandler(Result.failure(error), nil)
        }

        return nil
    }

    public init() {

    }
}

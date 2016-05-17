//
//  CRNetWorkMannager.swift
//  Flipboard
//
//  Created by jiangbo on 16/5/11.
//  Copyright © 2016年 chenrui. All rights reserved.
//

import UIKit

class CRNetWorkMannager: NSObject {
    
    class func Post(url:String,params:NSDictionary?,success:(session: NSURLSessionDataTask, response: AnyObject?)->(),faliure:(session: NSURLSessionDataTask?, error: NSError)->()) {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/html") as? Set<String>
        manager.requestSerializer = AFJSONRequestSerializer()
        
        manager.POST(url, parameters: params, success: { (session: NSURLSessionDataTask, response: AnyObject?) in
            print(response)
            success(session: session, response: response)
        }) { (session: NSURLSessionDataTask?,error: NSError) in
                print(error)
                faliure(session: session, error: error)
        }
    }
}

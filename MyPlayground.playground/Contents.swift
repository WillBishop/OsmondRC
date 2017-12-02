//: Playground - noun: a place where people can play

import UIKit
import Alamofire

var str = "Hello, playground"

Alamofire.request("https://example.com")
	.responseString { response in
		print(response.result.value)
}

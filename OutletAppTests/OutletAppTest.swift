//
//  OutletAppTest.swift
//  OutletAppTests
//
//  Created by Akshay C Khanna on 13/06/2018.
//  Copyright © 2018 Akshay C Khanna. All rights reserved.
//

import XCTest

class OutletAppTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWebService() {
        var locaArr = Array<Any>()
        ProductWebService.getProductJSON { closureArr in
            locaArr = closureArr!
            XCTAssertTrue(locaArr is [ProductDetails])
            return nil
        }
    }
    
    func testProductNameReceivedFromWebService() {
        let expectation = self.expectation(description: "WebService returns Product correctly!")
        var locaArr = Array<Any>()
        ProductWebService.getProductJSON { closureArr in
            locaArr = closureArr!
            //Perform tasks
            let firstProduct:ProductDetails = locaArr[0] as! ProductDetails
            //print(filmDetailFirstObj.filmTitle)
            XCTAssertEqual(firstProduct.name, "Button-embellished striped cotton-jersey top")
            expectation.fulfill()
            return nil
        }
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    
    func testImageURLReceivedFromWebService() {
        let expectation = self.expectation(description: "filmWebServiceImageURL")
        var locaArr = Array<Any>()
        ProductWebService.getProductJSON { closureArr in
            locaArr = closureArr!
            //Perform tasks
            let firstProduct:ProductDetails = locaArr[0] as! ProductDetails
            XCTAssertEqual(firstProduct.images.urlTemplate, "{{scheme}}//cache.net-a-porter.com/images/products/1066074/1066074_{{shot}}_{{size}}.jpg")
            expectation.fulfill()
            return nil
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    

   
}

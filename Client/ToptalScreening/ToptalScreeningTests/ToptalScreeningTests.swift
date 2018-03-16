//
//  ToptalScreeningTests.swift
//  ToptalScreeningTests
//
//  Created by Shbli on 2018-03-02.
//  Copyright © 2018 Shbli. All rights reserved.
//

import XCTest
@testable import ToptalScreening

class ToptalScreeningTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAccountModel() {
        //Test JSONDecoder().decode for AccountModel
        let jsonAccountModelData = "{\"id\": 1,\"username\": \"shbli\",\"first_name\": \"Ahmed\",\"last_name\": \"Shbli\",\"email\": \"info@shbli.com\",\"token\": \"this_is_a_test_token\",\"groups\": [1]}".data(using: .utf8)
        guard let testAccountModel = try? JSONDecoder().decode(AccountModel.self, from: jsonAccountModelData!) else {
            XCTAssert(false, "Couldn't decode data into AccountModel")
            return
        }
        
        XCTAssertEqual(testAccountModel.id!, 1)
        XCTAssertEqual(testAccountModel.username!, "shbli")
        XCTAssertEqual(testAccountModel.first_name!, "Ahmed")
        XCTAssertEqual(testAccountModel.last_name!, "Shbli")
        XCTAssertEqual(testAccountModel.email!, "info@shbli.com")
        XCTAssertEqual(testAccountModel.token!, "this_is_a_test_token")
        XCTAssertEqual(testAccountModel.accountType(), AccountType.Admin)
        
        //Test the copy feature of the account model with all the fields
        let testAccountModelCopy = testAccountModel.copy()
        
        XCTAssertEqual(testAccountModel.id!, testAccountModelCopy.id!)
        XCTAssertEqual(testAccountModel.username!, testAccountModelCopy.username!)
        XCTAssertEqual(testAccountModel.first_name!, testAccountModelCopy.first_name!)
        XCTAssertEqual(testAccountModel.last_name!, testAccountModelCopy.last_name!)
        XCTAssertEqual(testAccountModel.email!, testAccountModelCopy.email!)
        XCTAssertEqual(testAccountModel.token!, testAccountModelCopy.token!)
        XCTAssertEqual(testAccountModel.accountType(), testAccountModelCopy.accountType())

        //Test the static method for validating an account model
        XCTAssert(AccountModel.validateEmail(email: "CorrectEmail@domain.com") == true)
        XCTAssert(AccountModel.validateEmail(email: "IncorrectEmail@domain") == false)
        XCTAssert(AccountModel.validateEmail(email: "IncorrectEmail@") == false)
        XCTAssert(AccountModel.validateEmail(email: "IncorrectEmail") == false)
    }
    
    func testJogModel() {
        let jsonJogModelString = "{\"id\":10, \"author\":1, \"notes\":\"Jog 4\",\"activity_start_time\":\"2018-03-07T02:22:08Z\",\"distance\":1000,\"time\":25,\"created\":\"2018-03-07T02:22:19Z\",\"modified\":\"2018-03-08T05:21:20Z\"}"
        let jsonJogModeDatal = jsonJogModelString.data(using: .utf8)
        let decoder: JSONDecoder =  JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let testJogModel = try? decoder.decode(Jog.self, from: jsonJogModeDatal!) else {
            XCTAssert(false, "Couldn't decode data into Jog")
            return
        }
        
        XCTAssertEqual(testJogModel.id!, 10)
        XCTAssertEqual(testJogModel.notes!, "Jog 4")
        XCTAssertEqual(testJogModel.distance!, 1000)
        XCTAssertEqual(testJogModel.time!, 25)
        XCTAssertEqual(testJogModel.author!, 1)

        let formatter = ISO8601DateFormatter()
        XCTAssertEqual(formatter.string(from: testJogModel.activity_start_time!), "2018-03-07T02:22:08Z")
        XCTAssertEqual(formatter.string(from: testJogModel.created!), "2018-03-07T02:22:19Z")
        XCTAssertEqual(formatter.string(from: testJogModel.modified!), "2018-03-08T05:21:20Z")

        //TODO: Test jog model sorting method
        var jogList = [Jog]()
        
        //add 5 jogs to it
        guard let testJogModel1 = try? decoder.decode(Jog.self, from: jsonJogModeDatal!) else {
            XCTAssert(false, "Couldn't decode data into Jog")
            return
        }
        guard let testJogModel2 = try? decoder.decode(Jog.self, from: jsonJogModeDatal!) else {
            XCTAssert(false, "Couldn't decode data into Jog")
            return
        }
        guard let testJogModel3 = try? decoder.decode(Jog.self, from: jsonJogModeDatal!) else {
            XCTAssert(false, "Couldn't decode data into Jog")
            return
        }
        guard let testJogModel4 = try? decoder.decode(Jog.self, from: jsonJogModeDatal!) else {
            XCTAssert(false, "Couldn't decode data into Jog")
            return
        }
        guard let testJogModel5 = try? decoder.decode(Jog.self, from: jsonJogModeDatal!) else {
            XCTAssert(false, "Couldn't decode data into Jog")
            return
        }
        
        testJogModel1.activity_start_time = formatter.date(from: "2011-03-07T02:22:08Z")
        testJogModel2.activity_start_time = formatter.date(from: "2018-03-07T02:22:08Z")
        testJogModel3.activity_start_time = formatter.date(from: "2012-03-07T02:22:08Z")
        testJogModel4.activity_start_time = formatter.date(from: "2016-03-07T02:22:08Z")
        testJogModel5.activity_start_time = formatter.date(from: "2014-03-07T02:22:08Z")

        jogList.append(testJogModel1)
        jogList.append(testJogModel2)
        jogList.append(testJogModel3)
        jogList.append(testJogModel4)
        jogList.append(testJogModel5)
        
        jogList.sort(by: Jog.sortComparator)
        
        for i in 1...jogList.count-1 {
            XCTAssert(jogList[i-1].activity_start_time! >= jogList[i].activity_start_time!)
        }
    }
    
    func testWeeklyReportModel() {
        //TODO: Test weekly report model
        /*[{"author_id":3,"week":9,"year":2018,"avg_distance":10.0,"avg_time":5.0},{"author_id":3,"week":10,"year":2018,"avg_distance":340.0,"avg_time":11.666666666666666}]*/
        let jsonWeeklyReportData = "{\"author_id\":3,\"week\":9,\"year\":2018,\"avg_distance\":10.0,\"avg_time\":5.0}".data(using: .utf8)
        guard let testWeeklyReportModel = try? JSONDecoder().decode(JogWeeklyReport.self, from: jsonWeeklyReportData!) else {
            XCTAssert(false, "Couldn't decode data into JogWeeklyReport")
            return
        }
        
        XCTAssertEqual(testWeeklyReportModel.week!, 9)
        XCTAssertEqual(testWeeklyReportModel.year!, 2018)
        XCTAssertEqual(testWeeklyReportModel.avg_distance!, 10.0)
        XCTAssertEqual(testWeeklyReportModel.avg_time!, 5.0)
    }
    
    func testRestAPIsFullCycle() {
        let expectation = XCTestExpectation(description: "TestRestAPIsFullCycle for regular user")
        //try login
        SharedAccountService.authUser(username: "user", password: "user12345", onSuccess: {
            
        //passed the login feature
        XCTAssert(true)
        
        //try the rest of the APIs
        //get all jogs
        SharedJogTrackingService.getJogRecords(onSuccess: { (jogs) in
            XCTAssert(true)
        }, onError: { (error) in
            XCTAssert(false, error)
        })
            
        //get jog report
        SharedJogTrackingService.getJogWeeklyReport(onSuccess: { (reportList) in
            XCTAssert(true)
        }, onError: { (error) in
            XCTAssert(false, error)
        })

        //now let's create a new jog (In parrel to the above APIs, this runs)
        SharedJogTrackingService.createJogRecord(author: UserAccountModel!.id!, notes: "Random note", activity_start_time: Date(), distance: 1000, time: 10, created: Date(), modified: Date(), onSuccess: { (jog) in

        XCTAssertEqual(jog.notes!, "Random note")
        XCTAssertEqual(jog.distance!, 1000)
        
        //we success, let's update that jog
        SharedJogTrackingService.updateJogRecord(id: jog.id!, author: UserAccountModel!.id!, notes: "Updated note", activity_start_time: jog.activity_start_time!, distance: 500, time: 2, created: jog.created!, modified: Date(), onSuccess: { (jog) in
            
        XCTAssertEqual(jog.notes!, "Updated note")
        XCTAssertEqual(jog.distance!, 500)
        
        //now we try to delete that jog finally
        SharedJogTrackingService.deleteJogRecord(id: jog.id!, onSuccess: {
            XCTAssert(true)
            expectation.fulfill()
        }, onError: { (error) in
            XCTAssert(false, error)
        })
            
        }, onError: { (error) in
            XCTAssert(false, error)
        })
            
        }, onError: { (error) in
            XCTAssert(false, error)
        })
        }) { (error) in
            XCTAssert(false, error)
        }
        
        //the below test max out of 10 seconds
        wait(for: [expectation], timeout: 10.0)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}

//
//
//  Created by David Truong on 10/3/17.
//  Migrated to Swift by Tapash Majumder on 7/10/18.
//  Copyright © 2018 Iterable. All rights reserved.
//

import XCTest

@testable import IterableSDK

class InAppHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNotificationCreation() {
        //call showIterableNotificationHTML with fake data
        //Check the top level dialog
        
        let htmlString = "<a href=\"http://www.iterable.com\" target=\"http://www.iterable.com\">test</a>"
        let baseNotification = IterableInAppHTMLViewController(data: htmlString)
        let html = baseNotification.getHtml()
        XCTAssertEqual(html, htmlString)
    }
    
    func testGetPaddingInvalid() {
        let insets = InAppHelper.getPadding(fromInAppSettings: [:])
        XCTAssertEqual(insets, UIEdgeInsets.zero)
    }
    
    func testGetPaddingFull() {
        let payload: [AnyHashable : Any] = [
            "top" : ["percentage" : "0"],
            "left" : ["percentage" : "0"],
            "bottom" : ["percentage" : "0"],
            "right" : ["right" : "0"],
        ]
        
        let insets = InAppHelper.getPadding(fromInAppSettings: payload)
        XCTAssertEqual(insets, UIEdgeInsets.zero)
        
        var padding = UIEdgeInsets.zero
        padding.top = CGFloat(InAppHelper.decodePadding(payload["top"]))
        padding.left = CGFloat(InAppHelper.decodePadding(payload["left"]))
        padding.bottom = CGFloat(InAppHelper.decodePadding(payload["bottom"]))
        padding.right = CGFloat(InAppHelper.decodePadding(payload["right"]))
        XCTAssertEqual(padding, UIEdgeInsets.zero)
    }
    
    func testGetPaddingCenter() {
        let payload: [AnyHashable : Any] = [
            "top" : ["displayOption" : "AutoExpand"],
            "left" : ["percentage" : "0"],
            "bottom" : ["displayOption" : "AutoExpand"],
            "right" : ["right" : "0"],
            ]
        
        let insets = InAppHelper.getPadding(fromInAppSettings: payload)
        XCTAssertEqual(insets, UIEdgeInsets(top: -1, left: 0, bottom: -1, right: 0))
        
        var padding = UIEdgeInsets.zero
        padding.top = CGFloat(InAppHelper.decodePadding(payload["top"]))
        padding.left = CGFloat(InAppHelper.decodePadding(payload["left"]))
        padding.bottom = CGFloat(InAppHelper.decodePadding(payload["bottom"]))
        padding.right = CGFloat(InAppHelper.decodePadding(payload["right"]))
        XCTAssertEqual(padding, UIEdgeInsets(top: -1, left: 0, bottom: -1, right: 0))
    }
    
    func testGetPaddingTop() {
        let payload: [AnyHashable : Any] = [
            "top" : ["percentage" : "0"],
            "left" : ["percentage" : "0"],
            "bottom" : ["displayOption" : "AutoExpand"],
            "right" : ["right" : "0"],
            ]
        
        let insets = InAppHelper.getPadding(fromInAppSettings: payload)
        XCTAssertEqual(insets, UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0))
        
        var padding = UIEdgeInsets.zero
        padding.top = CGFloat(InAppHelper.decodePadding(payload["top"]))
        padding.left = CGFloat(InAppHelper.decodePadding(payload["left"]))
        padding.bottom = CGFloat(InAppHelper.decodePadding(payload["bottom"]))
        padding.right = CGFloat(InAppHelper.decodePadding(payload["right"]))
        XCTAssertEqual(padding, UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0))
    }
    
    func testGetPaddingBottom() {
        let payload: [AnyHashable : Any] = [
            "top" : ["displayOption" : "AutoExpand"],
            "left" : ["percentage" : "0"],
            "bottom" : ["percentage" : "0"],
            "right" : ["right" : "0"],
            ]
        
        let insets = InAppHelper.getPadding(fromInAppSettings: payload)
        XCTAssertEqual(insets, UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0))
        
        var padding = UIEdgeInsets.zero
        padding.top = CGFloat(InAppHelper.decodePadding(payload["top"]))
        padding.left = CGFloat(InAppHelper.decodePadding(payload["left"]))
        padding.bottom = CGFloat(InAppHelper.decodePadding(payload["bottom"]))
        padding.right = CGFloat(InAppHelper.decodePadding(payload["right"]))
        XCTAssertEqual(padding, UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0))
    }
    
    func testNotificationPaddingFull() {
        let notificationType = IterableInAppHTMLViewController.location(fromPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        XCTAssertEqual(notificationType, .full)
    }

    func testNotificationPaddingTop() {
        let notificationType = IterableInAppHTMLViewController.location(fromPadding: UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0))
        XCTAssertEqual(notificationType, .top)
    }
    
    func testNotificationPaddingBottom() {
        let notificationType = IterableInAppHTMLViewController.location(fromPadding: UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0))
        XCTAssertEqual(notificationType, .bottom)
    }

    func testNotificationPaddingCenter() {
        let notificationType = IterableInAppHTMLViewController.location(fromPadding: UIEdgeInsets(top: -1, left: 0, bottom: -1, right: 0))
        XCTAssertEqual(notificationType, .center)
    }

    func testNotificationPaddingDefault() {
        let notificationType = IterableInAppHTMLViewController.location(fromPadding: UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0))
        XCTAssertEqual(notificationType, .center)
    }
    
    func testDoNotShowMultipleTimes() {
        let shownFirstTime = InAppHelper.showIterableNotificationHTML("", callbackBlock: nil)
        let shownSecondTime = InAppHelper.showIterableNotificationHTML("", callbackBlock: nil)
        XCTAssertTrue(shownFirstTime)
        XCTAssertFalse(shownSecondTime)
    }
    
    func testGetBackgroundAlpha() {
        XCTAssert(InAppHelper.getBackgroundAlpha(fromInAppSettings: nil) == 0)
        XCTAssert(InAppHelper.getBackgroundAlpha(fromInAppSettings: ["backgroundAlpha" : "x"]) == 0)
        XCTAssert(InAppHelper.getBackgroundAlpha(fromInAppSettings: ["backgroundAlpha" : 0.5]) == 0.5)
        XCTAssert(InAppHelper.getBackgroundAlpha(fromInAppSettings: ["backgroundAlpha" : 1]) == 1.0)
    }
    
    func testTrackInAppClickWithButtonUrl() {
        let messageId = "message1"
        let buttonUrl = "http://somewhere.com"
        let expectation1 = expectation(description: "track in app click")

        let networkSession = MockNetworkSession(statusCode: 200)
        IterableAPI.initializeForTesting(apiKey: InAppHelperTests.apiKey, networkSession: networkSession)
        IterableAPI.userId = InAppHelperTests.userId
        networkSession.callback = {(_, _, _) in
            TestUtils.validate(request: networkSession.request!,
                               requestType: .post,
                               apiEndPoint: .ITBL_ENDPOINT_API,
                               path: .ITBL_PATH_TRACK_INAPP_CLICK,
                               queryParams: [(name: AnyHashable.ITBL_HEADER_API_KEY, value: InAppHelperTests.apiKey),
                ])
            let body = networkSession.getRequestBody() as! [String : Any]
            TestUtils.validateMatch(keyPath: KeyPath("messageId"), value: messageId, inDictionary: body)
            TestUtils.validateMatch(keyPath: KeyPath("clickedUrl"), value: buttonUrl, inDictionary: body)
            TestUtils.validateMatch(keyPath: KeyPath("userId"), value: InAppHelperTests.userId, inDictionary: body)
            expectation1.fulfill()
        }
        IterableAPI.track(inAppClick: messageId, buttonURL: buttonUrl)
        wait(for: [expectation1], timeout: testExpectationTimeout)
    }

    func testTrackInAppClickWithButtonIndex() {
        let messageId = "message1"
        let buttonIndex = "1"
        let expectation1 = expectation(description: "track in app click")
        
        let networkSession = MockNetworkSession(statusCode: 200)
        IterableAPI.initializeForTesting(apiKey: InAppHelperTests.apiKey, networkSession: networkSession)
        IterableAPI.email = InAppHelperTests.email
        networkSession.callback = {(_, _, _) in
            TestUtils.validate(request: networkSession.request!,
                               requestType: .post,
                               apiEndPoint: .ITBL_ENDPOINT_API,
                               path: .ITBL_PATH_TRACK_INAPP_CLICK,
                               queryParams: [(name: AnyHashable.ITBL_HEADER_API_KEY, value: InAppHelperTests.apiKey),
                                             ])
            let body = networkSession.getRequestBody() as! [String : Any]
            TestUtils.validateMatch(keyPath: KeyPath("messageId"), value: messageId, inDictionary: body)
            TestUtils.validateMatch(keyPath: KeyPath("buttonIndex"), value: buttonIndex, inDictionary: body)
            TestUtils.validateMatch(keyPath: KeyPath("email"), value: InAppHelperTests.email, inDictionary: body)
            expectation1.fulfill()
        }
        IterableAPI.track(inAppClick: messageId, buttonIndex: buttonIndex)
        wait(for: [expectation1], timeout: testExpectationTimeout)
    }

    func testTrackInAppOpen() {
        let messageId = "message1"
        let expectation1 = expectation(description: "track in app open")
        
        let networkSession = MockNetworkSession(statusCode: 200)
        IterableAPI.initializeForTesting(apiKey: InAppHelperTests.apiKey, networkSession: networkSession)
        IterableAPI.email = InAppHelperTests.email
        networkSession.callback = {(_, _, _) in
            TestUtils.validate(request: networkSession.request!,
                               requestType: .post,
                               apiEndPoint: .ITBL_ENDPOINT_API,
                               path: .ITBL_PATH_TRACK_INAPP_OPEN,
                               queryParams: [(name: AnyHashable.ITBL_HEADER_API_KEY, value: InAppHelperTests.apiKey),
                                             ])
            let body = networkSession.getRequestBody() as! [String : Any]
            TestUtils.validateMatch(keyPath: KeyPath(AnyHashable.ITBL_KEY_MESSAGE_ID), value: messageId, inDictionary: body)
            TestUtils.validateMatch(keyPath: KeyPath(AnyHashable.ITBL_KEY_EMAIL), value: InAppHelperTests.email, inDictionary: body)
            expectation1.fulfill()
        }
        IterableAPI.track(inAppOpen: messageId)
        wait(for: [expectation1], timeout: testExpectationTimeout)
    }
    
    func testCustomPayloadParsing() {
        IterableAPI.initializeForTesting()
        
        let customPayload: [AnyHashable : Any] = ["string1" : "value1", "bool1" : true, "date1" : Date()]
        
        let payload = createInAppPayload(withCustomPayload: customPayload)
        
        let messages = InAppHelper.inAppMessages(fromPayload: payload, internalApi: IterableAPI.internalImplementation!)
        
        XCTAssertEqual(messages.count, 1)
        let obtained = messages[0].customPayload
        XCTAssertEqual(obtained?["string1"] as? String, "value1")
        XCTAssertEqual(obtained?["bool1"] as? Bool, true)
    }
    
    func testInAppPayloadWithNoTrigger() {
        let payload = """
        {
            "inAppMessages" : [
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageIdxxx",
                    "campaignId" : "campaignIdxxx"
                }
            ]
        }
        """.toJsonDict()
        let messages = InAppHelper.inAppMessages(fromPayload: payload, internalApi: IterableAPI.internalImplementation!)
        XCTAssertEqual(messages[0].trigger.type, IterableInAppTriggerType.immediate)
    }
    
    func testInAppPayloadWithKnownTrigger() {
        let payload = """
        {
            "inAppMessages" : [
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageIdxxx",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "event",
                        "something" : "else"
                    }
                }
            ]
        }
        """.toJsonDict()
        let messages = InAppHelper.inAppMessages(fromPayload: payload, internalApi: IterableAPI.internalImplementation!)
        XCTAssertEqual(messages[0].trigger.type, IterableInAppTriggerType.event)
        XCTAssertEqual(messages[0].trigger.dict["something"] as? String, "else")
    }

    func testInAppPayloadWithUnKnownTrigger() {
        let payload = """
        {
            "inAppMessages" : [
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageIdxxx",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    }
                }
            ]
        }
        """.toJsonDict()
        let messages = InAppHelper.inAppMessages(fromPayload: payload, internalApi: IterableAPI.internalImplementation!)
        XCTAssertEqual(messages[0].trigger.type, IterableInAppTriggerType.never)
        let dict = messages[0].trigger.dict as! [String : Any]
        TestUtils.validateMatch(keyPath: KeyPath("myPayload.var1"), value: "val1", inDictionary: dict, message: "Expected to find val1")
    }
    
    // Remove this test when backend is fixed
    // This test assumes that certain parts of payload
    // are in 'customPayload' element instead of the right places.
    func testInAppPayloadParsingWithPreprocessing() {
        let customPayloadStr1 = """
        {
            "messageId": "overridden",
            "var1" : "value1",
            "obj1" : {
                "something" : true,
                "nothing" : "is nothing"
            },
        }
        """
        var customPayload1 = customPayloadStr1.toJsonDict()
        customPayload1["inAppType"] = "default"
        customPayload1["contentType"] = "html"
        
        let customPayloadStr2 = """
        {
            "promoteToContent" : {
                "title" : "title",
                "subTitle" : "subtitle",
                "imageUrl" : "http://somewhere.com/something.jpg"
            }
        }
        """
        var customPayload2 = customPayloadStr2.toJsonDict()
        customPayload2["inAppType"] = "inbox"
        customPayload2["contentType"] = "html"
        
        let payload = """
        {
            "inAppMessages" : [
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageId1",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    },
                    "customPayload" : \(customPayload1.toJsonString())
                },
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageId2",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    },
                    "customPayload" : \(customPayload2.toJsonString())
                },
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageId3",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    },
                    "customPayload" : {}
                },
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageId4",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    }
                }
            ]
        }
        """.toJsonDict()
        let messages = InAppHelper.inAppMessages(fromPayload: payload, internalApi: IterableAPI.internalImplementation!)
        
        XCTAssertEqual(messages.count, 4)
        let message1 = messages[0]
        XCTAssertEqual(message1.messageId, "messageId1")
        XCTAssertEqual(message1.inAppType, .default)
        XCTAssertTrue(TestUtils.areEqual(dict1: message1.customPayload!, dict2: customPayloadStr1.toJsonDict()))
        
        let message2 = messages[1]
        XCTAssertEqual(message2.inAppType, .inbox)
        XCTAssertTrue(TestUtils.areEqual(dict1: message2.customPayload!, dict2: customPayloadStr2.toJsonDict()))
        
        let message3 = messages[2]
        XCTAssertEqual(message3.inAppType, .default)
        
        let message4 = messages[3]
        XCTAssertEqual(message4.inAppType, .default)
    }

    
    func testInAppPayloadParsing() {
        let customPayloadStr1 = """
        {
            "var1" : "value1",
            "obj1" : {
                "something" : true,
                "nothing" : "is nothing"
            }
        }
        """
        let customPayloadStr2 = """
        {
            "promoteToContent" : {
                "title" : "title",
                "subTitle" : "subtitle",
                "imageUrl" : "http://somewhere.com/something.jpg"
            }
        }
        """

        let payload = """
        {
            "inAppMessages" : [
                {
                    "content" : {
                        "contentType" : "html",
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageIdxxx",
                    "campaignId" : "campaignIdxxx",
                    "inAppType" : "default",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    },
                    "customPayload" : \(customPayloadStr1)
                },
                {
                    "inAppType" : "inbox",
                    "content" : {
                        "contentType" : "html",
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageIdxxx",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    },
                    "customPayload" : \(customPayloadStr2)
                },
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageIdxxx",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    },
                    "customPayload" : {}
                },
                {
                    "content" : {
                        "html" : "<a href=\\"http://somewhere.com\\">Click here</a>"
                    },
                    "messageId" : "messageIdxxx",
                    "campaignId" : "campaignIdxxx",
                    "trigger" : {
                        "type" : "myNewKind",
                        "myPayload" : {"var1" : "val1"}
                    }
                }
            ]
        }
        """.toJsonDict()
        let messages = InAppHelper.inAppMessages(fromPayload: payload, internalApi: IterableAPI.internalImplementation!)
        
        XCTAssertEqual(messages.count, 4)
        let message1 = messages[0]
        XCTAssertEqual(message1.inAppType, .default)
        XCTAssertTrue(TestUtils.areEqual(dict1: message1.customPayload!, dict2: customPayloadStr1.toJsonDict()))
        
        let message2 = messages[1]
        XCTAssertEqual(message2.inAppType, .inbox)
        XCTAssertTrue(TestUtils.areEqual(dict1: message2.customPayload!, dict2: customPayloadStr2.toJsonDict()))
        
        let message3 = messages[2]
        XCTAssertEqual(message3.inAppType, .default)

        let message4 = messages[3]
        XCTAssertEqual(message4.inAppType, .default)
    }

    private func createInAppPayload(withCustomPayload customPayload: [AnyHashable : Any]) -> [AnyHashable : Any] {
        return [
            "inAppMessages" : [[
                "content" : [
                    "html" : "<a href='href1'>Click Here</a>",
                    "inAppDisplaySettings" : ["backgroundAlpha" : 0.5, "left" : ["percentage" : 60], "right" : ["percentage" : 60], "bottom" : ["displayOption" : "AutoExpand"], "top" : ["displayOption" : "AutoExpand"]],
                ],
                "messageId" : "messageIdxxx",
                "campaignId" : "campaignIdxxx",
                "customPayload" : customPayload
            ]]
        ]
    }
    
    // nil host
    func testCallbackUrlParsingAppleWebdataScheme1() {
        let url = URL(string: "applewebdata://")!
        XCTAssertNil(InAppHelper.parse(inAppUrl: url))
    }

    
    func testCallbackUrlParsingAppleWebdataScheme2() {
        let url = URL(string: "applewebdata://this-is-uuid/the-real-url")!
        let parsed = InAppHelper.parse(inAppUrl: url)!
        if case let InAppHelper.InAppClickedUrl.localResource(name: name) = parsed {
            XCTAssertEqual(name, "the-real-url")
        } else {
            XCTFail("could not parse")
        }
    }

    func testCallbackUrlParsingCustomActionScheme() {
        let url = URL(string: "action://buyProduct")!
        if case let InAppHelper.InAppClickedUrl.customAction(name: name) = InAppHelper.parse(inAppUrl: url)! {
            XCTAssertEqual(name, "buyProduct")
        } else {
            XCTFail("Could not parse")
        }
    }

    func testCallbackUrlParsingRegularScheme() {
        let url = URL(string: "https://host/path")!
        if case let InAppHelper.InAppClickedUrl.regularUrl(parsedUrl) = InAppHelper.parse(inAppUrl: url)! {
            XCTAssertEqual(parsedUrl, url)
        } else {
            XCTFail("Could not parse")
        }
    }

    private static let apiKey = "zeeApiKey"
    private static let email = "user@example.com"
    private static let userId = "userId1"
}

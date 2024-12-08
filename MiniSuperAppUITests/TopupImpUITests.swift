//
//  TopupImpUITests.swift
//  MiniSuperAppUITests
//
//  Created by Jimin Park on 12/8/24.
//

import XCTest
import Swifter

final class TopupImpUITests: XCTestCase {
    private var app: XCUIApplication!
    private var server: HttpServer!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        server = HttpServer()
        
        app = XCUIApplication()
    }
    
    func testTopupSuccess() throws {
        // given
        let cardOnFileJsonpath = try TestUtil.path(for: "cardOnFile.json", in: type(of: self))
        server["/cards"] = shareFile(cardOnFileJsonpath)
        
        let topupResponse = try TestUtil.path(for: "TopupSuccessResponse.json", in: type(of: self))
        server["/topup"] = shareFile(topupResponse)
        
        // when
        try server.start()
        app.launch()
        
        // then
        app.tabBars.buttons["superpay_home_tab_bar_item"].tap()
        app.buttons["superpay_dashboard_topup_button"].tap()
        
        let textField = app.textFields["topup_enteramoun_textfield"]
        textField.tap()
        textField.typeText("10000")
        
        app.buttons["topup_enteramount_confirm_button"].tap()
        
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "superpay_dashboard_balance_label").label, "10,000")
    }
    
}

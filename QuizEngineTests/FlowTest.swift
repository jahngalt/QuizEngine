//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Oleg Kudimov on 11/24/21.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    let router = RouterSpy()
    
    
    
    func test_start_withNoQiestions_doesNotRoutToQuestions() {
        
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    
    func test_start_withOneQiestions_RoutToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    
    func test_start_withOneQiestions_RoutToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    
    func test_start_withTwoQiestions_RoutesToFirstQuestion() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    
    func test_startTwise_withTwoQiestions_RoutesToFirstQuestionTwice() {
        
        let sut  = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQiestions_RoutesToSecondAndThirdQuestion() {
        let sut  = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    
    func test_startAndAnswerFirstQuestion_withOneQiestion_doesNotRouteToAnotherQuestion() {
        let sut  = makeSUT(questions: ["Q1"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    
    // MARK: - Helpers
    func makeSUT(questions: [String]) -> Flow  {
        return  Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router {
    
        var routedQuestions: [String] = []
        var answerCallback: Router.AnswerCallback = {_ in }
        
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
    }
}

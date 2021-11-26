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
        
        let sut  = Flow(questions: [], router: router)
        sut.start()
        
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    
    func test_start_withOneQiestions_RoutToCorrectQuestion() {
        
        let sut  = Flow(questions: ["Q1"], router: router)
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    
    func test_start_withOneQiestions_RoutToCorrectQuestion_2() {
        let router = RouterSpy()
        let sut  = Flow(questions: ["Q2"], router: router)
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    
    func test_start_withTwoQiestions_RoutesToFirstQuestion() {
        
        let sut  = Flow(questions: ["Q1", "Q2"], router: router)
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    
    func test_startTwise_withTwoQiestions_RoutesToFirstQuestionTwice() {
        
        let sut  = Flow(questions: ["Q1", "Q2"], router: router)
        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    
    func test_startAndAnswerFirstQuestion_withTwoQiestions_RoutesToSecondQuestion() {
        
        let sut  = Flow(questions: ["Q1", "Q2"], router: router)
        sut.start()
        
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    
    class RouterSpy: Router {
    
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = {_ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
    }
}

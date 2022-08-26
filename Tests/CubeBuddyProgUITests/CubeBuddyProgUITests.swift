//
//  CubeBuddyProgUITests.swift
//  CubeBuddyProgUITests
//
//  Created by Isaac Farr on 7/1/22.
//

import XCTest
@testable import CubeBuddyProgUI

class CubeBuddyProgUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovesDontRepeatThreeTimesOrMore() {
        for _ in 1...100 {
            let scrambleMoves = CBBrain.getScramble().dropFirst("Scramble:\n".count).split(separator: " ")
//            let scrambleMoves = "F F F R R".split(separator: " ")
            for (i, _) in scrambleMoves.enumerated() {
                guard i != scrambleMoves.count - 3 else { break }
                if scrambleMoves[i] == scrambleMoves[i + 1] && scrambleMoves[i] == scrambleMoves[i + 2] {
                    XCTFail("A move repeated three times.")
                }
            }
        }
    }
    
    func testMovesArentFollowedWithCounterMove() {
        for _ in 1...100 {
            let scrambleMoves = CBBrain.getScramble().dropFirst("Scramble:\n".count).split(separator: " ")
            for (i, move) in scrambleMoves.enumerated() {
                guard i != scrambleMoves.count - 2 else { break }
                if move.count == 1 {
                    if (scrambleMoves[i + 1].count == 2) && (scrambleMoves[i + 1].first == move.first) {
                        XCTFail("There was a move that immediately countered the previous move.")
                    }
                } else {
                    if scrambleMoves[i + 1].count == 1 && (scrambleMoves[i + 1].first == move.first) {
                        XCTFail("There was a move that immediately countered the previous move.")
                    }
                }
            }
        }
    }

}

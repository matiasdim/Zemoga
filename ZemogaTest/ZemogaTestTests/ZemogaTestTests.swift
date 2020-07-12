//
//  ZemogaTestTests.swift
//  ZemogaTestTests
//
//  Created by Matías Gil Echavarría on 7/10/20.
//  Copyright © 2020 Matías Gil Echavarría. All rights reserved.
//

import XCTest
@testable import ZemogaTest

class ZemogaTestTests: XCTestCase {
    let post = Post(id: 1, userId: 1, title: "Titletesting", body: "Body Testing")
    let comment = Comment(id: 1, name: "Matías", email: "matias@cc.cc", postId: 1, body: "Bdody test")
    let user = User(id: 1, name: "Matías", email: "matias@ccc.cc", phone: "222-2221-12", website: "google.com")
    
    /* ********* API Calls ********* */
        
    // Sucessfull Posts pull includes an array of posts or emptyarray but not nil
    func testPostsGet() {
        let e = expectation(description: "GetPosts")
        Post.getPosts { (posts) in
            XCTAssertNotNil(posts)
            e.fulfill()
        }
        wait(for: [e], timeout: 10.0)
    }
    
    // Sucessfull Users pull includes an array of posts or emptyarray but not nil
    func testUsersGet() {
        let e = expectation(description: "GetUsers")
        User.getUsers { (users) in
            XCTAssertNotNil(users)
            e.fulfill()
        }
        wait(for: [e], timeout: 10.0)
    }
        
    
    // Sucessfull Post comments pull includes an array of posts or emptyarray but not nil
    func testPostCommentsGet() {
        let e = expectation(description: "GetPostComments")
        Comment.getComments(for: post, callback: { (comments) in
            XCTAssertNotNil(comments)
            e.fulfill()
        })
        wait(for: [e], timeout: 10.0)
    }
    
    
    /* ********* Common decoder ********* */
    
    let arrayStringData = """
    ["Matías"]
    """.data(using: .utf8)!
        
    func testCommonDecoderExpectedStiringType () {
        let array = CommonDecoder.decodeObject(objectType: [String].self, data: arrayStringData)
        XCTAssertNotNil(array)
    }

    func testCommonDecoderUnexpectedType () {
        let array = CommonDecoder.decodeObject(objectType: [Bool].self, data: arrayStringData)
        XCTAssertNil(array)
    }
    
    /* ********* Codable tests ********* */
    // Basic Codable tests for models (Includes CodkingKeys)
    func testPostCoding() throws {
        let dataEncoded = try JSONEncoder().encode(post)
        let postDecoded = try JSONDecoder().decode(Post.self, from: dataEncoded) as Post

        XCTAssertEqual(post, postDecoded)
    }
    
    func testUserCoding() throws {
        let dataEncoded = try JSONEncoder().encode(user)
        let userDecoded = try JSONDecoder().decode(User.self, from: dataEncoded) as User

        XCTAssertEqual(user, userDecoded)
    }
    
    func testCommentCoding() throws {
        let dataEncoded = try JSONEncoder().encode(comment)
        let commentDecoded = try JSONDecoder().decode(Comment.self, from: dataEncoded) as Comment

        XCTAssertEqual(comment, commentDecoded)
    }
    
    /* ********* Model Init ********* */
    
    // Post model
    let expectedPostId = 1
    let expectedPostUserId = 1
    let expectedPostTitle = "Titletesting"
    let expectedPostBody = "Body Testing"
    
    func testPostInitIdInit() {
        XCTAssertEqual(expectedPostId, post.id)
    }
    
    func testPostInitUserIdInit() {
        XCTAssertEqual(expectedPostUserId, post.userId)
    }
    
    func testPostInitTitleInit() {
        XCTAssertEqual(expectedPostTitle, post.title)
    }
    
    func testPostInitBodyInit() {
        XCTAssertEqual(expectedPostBody, post.body)
    }
    
    // User model
    let expectedUserId = 1
    let expectedUserName = "Matías"
    let expectedUserEmail = "matias@ccc.cc"
    let expectedUserPhone = "222-2221-12"
    let expectedUserWebsite = "google.com"
    
    func testUserIdInit() {
        XCTAssertEqual(expectedUserId, user.id)
    }
    
    func testUserNameInit() {
        XCTAssertEqual(expectedUserName, user.name)
    }
    
    func testUserEmailInit() {
        XCTAssertEqual(expectedUserEmail, user.email)
    }
    
    func testUserPhoneInit() {
        XCTAssertEqual(expectedUserPhone, user.phone)
    }
    
    func testUserWebsiteInit() {
        XCTAssertEqual(expectedUserWebsite, user.website)
    }
        
    // Comment model
    let expectedCommentId = 1
    let expectedCommentName = "Matías"
    let expectedCommentEmail = "matias@cc.cc"
    let expectedCommentPostId = 1
    let expectedCommentBody = "Bdody test"
    
    func testCommentIdInit() {
        XCTAssertEqual(expectedCommentId, comment.id)
    }
    
    func testCommentNameInit() {
        XCTAssertEqual(expectedCommentName, comment.name)
    }
    
    func testCommentEmailInit() {
        XCTAssertEqual(expectedCommentEmail, comment.email)
    }
    
    func testCommentPostIdInit() {
        XCTAssertEqual(expectedCommentPostId, comment.postId)
    }
    
    func testCommentBodyInit() {
        XCTAssertEqual(expectedCommentBody, comment.body)
    }
}

// Models needs to be Equatable in order to beable to be compared with XCTAssertEqual
extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return true
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return true
    }
}

extension Comment: Equatable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return true
    }
}


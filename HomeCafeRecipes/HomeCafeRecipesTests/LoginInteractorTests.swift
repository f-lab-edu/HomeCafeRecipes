//
//  LoginInteractorTests.swift
//  HomeCafeRecipesTests
//
//  Created by 김건호 on 1/17/25.
//

import XCTest

import RxSwift

@testable
import HomeCafeRecipes

final class LoginInteractorTests: XCTestCase {
    
    var loginUsecase: LoginUsecaseMock!
    var tokensaveUsecase: TokenSaveUsecaseMock!
    var disposeBag: DisposeBag!
    
    
    final class LoginUsecaseMock: LoginUseCase {
        var loginUsecaseCallCount: Int = 0
        var executeStub: Single<Result<Token, LoginError>> = .just(
            .success(
                Token(
                    accessToken: "testAccessToken",
                    refreshToken: "testRefreshToken"
                )
            )
        )
        func execute(userID: String, password: String) -> Single<Result<Token, LoginError>> {
            loginUsecaseCallCount += 1
            return executeStub
        }
    }
    
    
    final class TokenSaveUsecaseMock: TokenSaveUseCase {
        var tokensaveCallCount: Int = 0
        var savedAccessToken: String?
        var savedRefreshToken: String?
        
        func saveTokens(accessToken: String, refreshToken: String) {
            tokensaveCallCount += 1
            savedAccessToken = accessToken
            savedRefreshToken = refreshToken
        }
    }
    
    func createInteractor() -> LoginInteractor {
        let interactor = LoginInteractorImpl(
            loginUseCase: loginUsecase,
            tokensaveUsecase: tokensaveUsecase
        )
        return interactor
    }
    
    override func setUpWithError() throws {
        loginUsecase = LoginUsecaseMock()
        tokensaveUsecase = TokenSaveUsecaseMock()
        disposeBag = DisposeBag()
    }
    
    func test_로그인_성공시_토큰저장_호출합니다() {
        // Given
        let interactor = createInteractor()
        let expectedAccessToken = "testAccessToken"
        let expectedRefreshToken = "testRefreshToken"
        
        // When
        interactor.login(userID: "testID", password: "testPassword")
            .subscribe()
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(loginUsecase.loginUsecaseCallCount, 1, "LoginUsecaseMock의 execute 메서드가 호출되지 않았습니다.")
        XCTAssertEqual(tokensaveUsecase.tokensaveCallCount, 1, "TokenSaveUsecaseMock의 saveTokens 메서드가 호출되지 않았습니다.")
        XCTAssertEqual(tokensaveUsecase.savedAccessToken, expectedAccessToken, "저장된 AccessToken이 예상과 다릅니다.")
        XCTAssertEqual(tokensaveUsecase.savedRefreshToken, expectedRefreshToken, "저장된 RefreshToken이 예상과 다릅니다.")
    }
}

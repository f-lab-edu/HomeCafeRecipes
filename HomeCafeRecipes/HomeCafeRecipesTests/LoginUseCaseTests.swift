//
//  LoginUseCaseTests.swift
//  HomeCafeRecipesTests
//
//  Created by 김건호 on 9/24/24.
//

import XCTest

import RxSwift

@testable
import HomeCafeRecipes

final class LoginUseCaseTests: XCTestCase {
    var loginRepository: LoginRepositoryMock!
    var disposeBag: DisposeBag!
    
    final class LoginRepositoryMock: LoginRepository {
        var loginCallCount: Int = 0
        var loginStub: Single<Result<Token, LoginError>> = .just(
            .success(
                Token(
                    accessToken: "testAccessToken",
                    refreshToken: "testRefreshToken"
                )
            )
        )
        
        func login(userID: String, password: String) -> Single<Result<Token, LoginError>> {
            loginCallCount += 1
            return loginStub
        }
    }
    
    func createUsecase() -> LoginUseCase {
        let usecase = LoginUseCaseImpl(repository: loginRepository)
        return usecase
    }
    
    func assertLoginError(
        _ actual: Error,
        equals expectedError: LoginError,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard let actualError = actual as? LoginError else {
            XCTFail("Expected error of type \(expectedError) but got \(actual)", file: file, line: line)
            return
        }
        
        switch (actualError, expectedError) {
        case (.IDIsEmpty, .IDIsEmpty),
            (.passwordIsEmpty, .passwordIsEmpty):
            return
        case (.genericError(let actual), .genericError(let expected)):
            XCTAssertEqual(
                actual.localizedDescription,
                expected.localizedDescription,
                "Error descriptions do not match",
                file: file,
                line: line
            )
        default:
            XCTFail("Expected \(expectedError) but got \(actualError)", file: file, line: line)
        }
    }
    
    override func setUpWithError() throws {
        loginRepository = .init()
        disposeBag = .init()
    }
}

extension LoginUseCaseTests {
    func test_execute를_호출하면_loginRepository의_login을_호출합니다(){
        let usecase = createUsecase()
        
        usecase.execute(
            userID: "testID",
            password: "testPassword"
        )
        .subscribe()
        .disposed(by: disposeBag)
        
        XCTAssertEqual(loginRepository.loginCallCount, 1)
    }
    
    func test_excute를_호출할때_ID가_비워있으면_IDIsEmptyError을_return합니다() {
        let usecase = createUsecase()
        usecase.execute(
            userID: "",
            password: "testPassword"
        )
        .subscribe { result in
            switch result {
            case .success(let loginResult):
                switch loginResult {
                case .failure(let error):
                    XCTAssertEqual(self.loginRepository.loginCallCount, 0)
                    self.assertLoginError(error, equals: .IDIsEmpty)
                case .success:
                    XCTFail("Expected failure but got success")
                }
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        .disposed(by: disposeBag)
    }
    
    func test_excute를_호출할때_password가_비워있으면_passwordIsEmpty을_return합니다() {
        let usecase = createUsecase()
        
        usecase.execute(
            userID: "testID",
            password: ""
        )
        .subscribe { result in
            switch result {
            case .success(let loginResult):
                switch loginResult {
                case .failure(let error):
                    XCTAssertEqual(self.loginRepository.loginCallCount, 0)
                    self.assertLoginError(error, equals: .passwordIsEmpty)
                case .success:
                    XCTFail("Expected failure but got success")
                }
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        .disposed(by: disposeBag)
    }
    
    func test_excute를_호출할때_성공할경우_Token정보를_return합니다() {
        let usecase = createUsecase()
        let expectedAccessToken = "testAccessToken"
        let expectedRefreshToken = "testRefreshToken"
        
        usecase.execute(
            userID: "testId",
            password: "testPassword"
        ).subscribe(onSuccess: { loginResult in
            switch loginResult {
                
            case .success(let tokens):
                XCTAssertEqual(self.loginRepository.loginCallCount, 1)
                XCTAssertEqual(tokens.accessToken, expectedAccessToken)
                XCTAssertEqual(tokens.refreshToken, expectedRefreshToken)
                
            case .failure:
                XCTFail("Expected success but got failure")
                
            }
        }, onFailure: { error in
            XCTFail("Expected success but got failure with error: \(error.localizedDescription)")
        })
        .disposed(by: disposeBag)
    }
    
    func test_execute를_호출할때_잘못된자격증명으로_실패를_return합니다() {
        // Given
        let expectedNSError = NSError(
            domain: "TestErrorDomain",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"]
        )
        
        loginRepository.loginStub = .error(LoginError.genericError(expectedNSError))
        let usecase = createUsecase()
        
        
        // When
        usecase.execute(
            userID: "wrongID@test.com",
            password: "wrongPassword"
        ).subscribe(onSuccess: { _ in
            XCTFail("Expected failure but got success")
        }, onFailure: { error in
            // Then
            XCTAssertEqual(self.loginRepository.loginCallCount, 1)
            self.assertLoginError(
                error,
                equals: .genericError(expectedNSError)
            )
        })
        .disposed(by: disposeBag)
    }
}

//
//  SplashViewModel.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/11.
//

import Foundation

class SplashVM {
    
    func isLoggedIn() -> Bool {
        //TODO: 추후 실제 API 연동하여 RefreshToken까지 구현하기
        // 현재 API서버에서 토큰 만료기간 거의 무한으로 되어있음.
        
        // Keychain 이용하여 로그인 여부 감지
        return !KeychainManager.shared.tokenKey.isEmpty
    }
}

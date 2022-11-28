//
//  MyCustom+Extension.swift
//  MyBeaconTest
//
//  Created by nyeong heo on 2022/11/28.
//

import Foundation

/// 디버깅용 프린트 로그
/// - Parameters:
///   - object: 출력하고자 하는 내용
///   - functionName: 함수명
///   - fileName: Swift 파일이름
///   - lineNumber: 라인
public func debugLog(_ object: Any..., functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
  #if DEBUG
    let className = (fileName as NSString).lastPathComponent
    var log: String = ""
    
    for add in object {
        log += "\(String(describing: add))"
    }
    
    print("<\(className)> \(functionName) [#\(lineNumber)]| \(log)\n")
  #endif
}


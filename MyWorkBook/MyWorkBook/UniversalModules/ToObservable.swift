//
//  ToObservable.swift
//  MyWorkBook
//
//  Created by yuqing on 2023/3/10.
//

import Foundation
import RxSwift

//让存储的属性可以变成一个可观测序列的属性包装器
@propertyWrapper struct ToObservable<T> {
    private let observable: BehaviorSubject<T>
    var wrappedValue: T {
        didSet {
            self.observable.onNext(wrappedValue)
        }
    }

    init(wrappedValue: T) {
        observable = BehaviorSubject<T>.init(value: wrappedValue)
        self.wrappedValue = wrappedValue
    }

    public var projectedValue: Observable<T> {
        get {
            observable
        }
    }
}

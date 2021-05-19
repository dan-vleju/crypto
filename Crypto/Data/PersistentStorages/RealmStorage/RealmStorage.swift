//
//  RealmStorage.swift
//  Crypto
//
//  Created by Dan Vleju on 18.05.2021.
//

import Foundation
import Realm
import RealmSwift
import Combine

final class RealmStorage<T: RealmRepresentable> where T == T.RealmType.DomainType, T.RealmType: Object {

    private var realm: Realm {
        return try! Realm()
    }

    init() {
        print("URL: \(RLMRealmPathForFile("default.realm"))")
    }

    func queryAll() -> AnyPublisher<[T], Never> {
        return Future<[T], Never> { promise in
            let realm = self.realm
            let results = realm.objects(T.RealmType.self)
            promise(.success(results.map({ $0.asDomain() })))
        }
        .eraseToAnyPublisher()
    }

    func query(primaryKey: String) -> AnyPublisher<T?, Never> {
        return Future<T?, Never> { promise in
            let realm = self.realm
            let object = realm.object(ofType: T.RealmType.self, forPrimaryKey: primaryKey)
            promise(.success(object?.asDomain()))
        }
        .eraseToAnyPublisher()
    }

    func save(entities: [T]) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            let realm = self.realm
            try! realm.write {
                realm.add(entities.map({ $0.asRealm() }), update: .modified)
            }
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }

    func delete(entities: [T]) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            let realm = self.realm
            try! realm.write {
                realm.delete(realm.objects(T.RealmType.self))
            }
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}

protocol RealmRepresentable {
    associatedtype RealmType: DomainConvertibleType

    func asRealm() -> RealmType
}

protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomain() -> DomainType
}

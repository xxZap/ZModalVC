//
//  Nibable.swift
//  ZModalVC_Example
//
//  Created by Alessio Boerio on 01/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public protocol ZReusable: class, NSObjectProtocol {
    static var reusableIdentifier: String { get }
}
public extension ZReusable {
    public static var reusableIdentifier: String { return String(describing: self) }
}

public protocol ZNibable: class, NSObjectProtocol {
    static var nib: UINib { get }
    static var nibName: String { get }
}
public extension ZNibable {
    public static var nib: UINib { return UINib(nibName: nibName, bundle: Bundle(for: self)) }
    public static var nibName: String { return String(describing: self) }
    public static func fromNib() -> Self? { return nib.instantiate(withOwner: nil, options: nil).compactMap { $0 as? Self }.first }
}

extension UIView: ZNibable { }
extension UITableViewCell: ZReusable { }
extension UITableViewHeaderFooterView : ZReusable { }
extension UICollectionReusableView: ZReusable { }
extension UIViewController: ZNibable { }

public extension UITableView {
    func registerCellNib<T: ZNibable>(_ classType: T.Type) where T: ZReusable { register(classType.nib, forCellReuseIdentifier: classType.reusableIdentifier) }
    func registerCellClass<T: ZReusable>(_ classType: T.Type) { register(classType, forCellReuseIdentifier: classType.reusableIdentifier) }
    func dequeueReusableCell<T: ZReusable>(_ classType: T.Type, indexPath: IndexPath) -> T? { return dequeueReusableCell(withIdentifier: classType.reusableIdentifier, for: indexPath) as? T }
    func safeDequeueReusableCell<T: UITableViewCell>(_ classType: T.Type, indexPath: IndexPath) -> T { return dequeueReusableCell(classType.self, indexPath: indexPath) ?? T() }

    func registerHeaderFooterNib<T: ZNibable>(_ classType: T.Type) where T: ZReusable { register(classType.nib, forHeaderFooterViewReuseIdentifier: classType.reusableIdentifier) }
    func registerHeaderFooterClass<T: ZReusable>(_ classType: T.Type) { register(classType, forHeaderFooterViewReuseIdentifier: classType.reusableIdentifier) }
    func dequeueHeaderFooter<T: ZReusable>(_ classType: T.Type) -> T? { return dequeueReusableHeaderFooterView(withIdentifier: classType.reusableIdentifier) as? T }
}


public extension UICollectionView {
    func registerCellNib<T: ZNibable>(_ classType: T.Type) where T: ZReusable { register(classType.nib, forCellWithReuseIdentifier: classType.reusableIdentifier) }
    func registerCellClass<T: ZReusable>(_ classType: T.Type) { register(classType, forCellWithReuseIdentifier: classType.reusableIdentifier) }
    func dequeueReusableCell<T: ZReusable>(_ classType: T.Type, indexPath: IndexPath) -> T? { return dequeueReusableCell(withReuseIdentifier: classType.reusableIdentifier, for: indexPath) as? T }

    func registerSupplementaryViewNib<T: ZNibable>(_ classType: T.Type, kind: String) where T: ZReusable { register(classType.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: classType.reusableIdentifier) }
    func registerSupplementaryViewClass<T: ZReusable>(_ classType: T.Type, kind: String) { register(classType, forSupplementaryViewOfKind: kind, withReuseIdentifier: classType.reusableIdentifier) }
    func dequeueSupplementaryView<T: ZReusable>(_ classType: T.Type, kind: String, indexPath: IndexPath) -> T? { return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: classType.reusableIdentifier, for: indexPath) as? T }
}

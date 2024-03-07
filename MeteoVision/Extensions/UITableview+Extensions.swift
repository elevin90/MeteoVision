//
//  UITableview+Extensions.swift
//  MeteoVision
//
//  Created by YAUHENI LEVIN on 7.03.24.
//

import UIKit

extension UITableViewCell: ReusableView {}

extension UITableViewHeaderFooterView: ReusableView {}

public protocol ViewModelConfigurable {
    associatedtype ViewModel
    func configure(with: ViewModel)
}

// Extend UITableView to take advantage of ReusableView
public extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            #if DEBUG
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
            #else
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
            #endif
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(
        _ cellType: T.Type,
        for indexPath: IndexPath,
        viewModel: T.ViewModel) -> UITableViewCell where T: ViewModelConfigurable {
        let cell = dequeueReusableCell(cellType, for: indexPath)
        if let customCell = cell as? T {
            customCell.configure(with: viewModel)
        }
        return cell
    }
}

public protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    /// Default implementation of defaultReuseIdentifier
    static var defaultReuseIdentifier: String {
        return className
    }
}

public extension NSObject {
    var className: String {
        return type(of: self).className
    }
    
    static var className: String {
        guard let name = NSStringFromClass(self).components(separatedBy: ".").last else {
            fatalError()
        }
        return name
    }
    
    var classBundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    static var classBundle: Bundle {
        return Bundle(for: self)
    }
    
    func loadNibNamed(nibName: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: nibName, bundle: classBundle).instantiate(withOwner: self, options: nil).first as? UIView
    }
}

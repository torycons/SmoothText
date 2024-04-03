//
//  ConstraintView.swift
//  SmoothText
//
//  Created by Thanapat Sorralump on 21/3/2567 BE.
//

import UIKit

open class ConstraintUIView: UIView {
    fileprivate var view: UIView!

    open var nibName: String {
        return String(describing: self.classForCoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    fileprivate func xibSetup() {
        view = loadViewFromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        ])
    }

    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return view
    }
}

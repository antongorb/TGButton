//
//  TGButton.swift
//  TGButton
//
//  Created by Anthony Gorb on 12.04.2020.
//  Copyright © 2020 Anthony Gorb. All rights reserved.
//

import UIKit

@IBDesignable
open class TGButton: UIControl {
    
    enum TouchAlphaValues: CGFloat {
        case touched = 0.7
        case untouched = 1
    }
    
    let touchDisableRadius: CGFloat = 100
    
    private var rootView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bgContentView: UIView!
    @IBOutlet private weak var radioContentView: UIView!
    @IBOutlet private weak var radioInnerView: UIView!
    @IBOutlet private weak var badgeLabel: UILabel!
    @IBOutlet private weak var badgeContainerView: UIView!
    
    @IBInspectable var defaultColor: UIColor = UIColor.gray {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var selectedColor: UIColor = UIColor.orange {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var labelText: String = "" {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var badgeText: String = "" {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var selectedState: Bool = false {
        didSet{
            setupView()
        }
    }
    
    var touchAlpha: TouchAlphaValues = .untouched {
        didSet {
            updateTouchAlpha()
        }
    }
    
    var pressed: Bool = false {
        didSet {
            touchAlpha = pressed ? .touched : .untouched
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupView()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        setupView()
    }
    
    override open func layoutSubviews() {
        setupRootView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        setupView()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        setupView()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        pressed = true
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        if pressed {
            sendActions(for: .touchUpInside)
        }
        pressed = false
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        if let touchLoc = touches.first?.location(in: self) {
            if (touchLoc.x < -touchDisableRadius ||
                touchLoc.y < -touchDisableRadius ||
                touchLoc.x > bounds.size.width + touchDisableRadius ||
                touchLoc.y > bounds.size.height + touchDisableRadius) {
                pressed = false
            } else if touchAlpha == .untouched {
                pressed = true
            }
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        pressed = false
    }
}

private extension TGButton {
    
    func setupView() {
        
        layer.masksToBounds = false
        setupTitle()
        setupBadge()
        setupRootView()
        setupBadgeContainerView()
        setupRadioInnerView()
        setupRadioContentView()
        setupBgContentView()
    }
    
    func setupBgContentView() {
        bgContentView.clipsToBounds = true
        bgContentView.layer.cornerRadius = frame.size.height/2
    }
    
    func setupRadioInnerView() {
        radioInnerView.backgroundColor = defaultColor
        radioInnerView.clipsToBounds = true
        radioInnerView.layer.cornerRadius = radioInnerView.bounds.height / 2
        radioInnerView.isHidden = !selectedState
        radioInnerView.backgroundColor = selectedState ? selectedColor : .clear
    }
    
    func setupBadgeContainerView() {
        badgeContainerView.backgroundColor = selectedState ? selectedColor : defaultColor
        badgeContainerView.layer.cornerRadius = frame.size.height / 2
        badgeContainerView.layer.maskedCorners = [.layerMinXMaxYCorner]
        badgeContainerView.isHidden = badgeText.isEmpty
    }
    
    func setupRadioContentView() {
        radioContentView.clipsToBounds = true
        radioContentView.layer.cornerRadius = radioContentView.bounds.height / 2
        radioContentView.backgroundColor = .clear
        radioContentView.layer.borderWidth = 3
        radioContentView.layer.borderColor = selectedState
            ? selectedColor.cgColor : defaultColor.cgColor
    }
    
    func setupRootView() {
        layer.cornerRadius = frame.size.height/2
        layer.borderColor = selectedState ? selectedColor.cgColor : defaultColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    func setupTitle() {
        titleLabel.text = labelText
        titleLabel.textColor = selectedState ? selectedColor : defaultColor
    }
    
    func setupBadge() {
        badgeLabel.text = badgeText
        badgeLabel.textColor = selectedState ? .white : .black
    }
    
    func xibSetup() {
        guard rootView == nil else { return }
        rootView = loadViewFromNib()
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(rootView)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: TGButton.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func updateTouchAlpha() {
        if alpha != touchAlpha.rawValue {
            UIView.animate(withDuration: 0.3) {
                self.alpha = self.touchAlpha.rawValue
            }
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        sendActions(for: .touchUpInside)
    }
}

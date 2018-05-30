import UIKit

class PhotoBrowserBottomBar: UIView {
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(asset: "Delete"), for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    var deleteHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.deleteButton.frame = CGRect(x: 8.0,
                                         y: (self.bounds.height - 44.0) * 0.5,
                                         width: 44.0,
                                         height: 44.0)
    }
    
}

// MARK: - Button events
private extension PhotoBrowserBottomBar {

    @objc func didTapDeleteButton(sender: UIButton) {
        self.deleteHandler?()
    }
    
}

// MARK: - Private
private extension PhotoBrowserBottomBar {
    
    func setupUI() {
        self.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.8)
        
        self.addSubview(self.deleteButton)
    }
    
}

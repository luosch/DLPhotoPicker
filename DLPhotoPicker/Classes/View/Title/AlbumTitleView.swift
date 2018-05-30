import UIKit

internal class AlbumTitleView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(hex: 0x333333)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(asset: "AlbumPickerIndicator")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var title: String? {
        set {
            self.titleLabel.text = newValue
            self.layoutSubviews()
        }
        get {
            return self.titleLabel.text
        }
    }
    
    var clickHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: self.bounds.size.height)
        self.titleLabel.sizeToFit()
        
        let titleLabelWidth = min((self.bounds.width-10.0-12.0), self.titleLabel.bounds.width)
        let titleLabelHeight = min(self.titleLabel.bounds.height, self.bounds.size.height)
        
        self.titleLabel.frame = CGRect(x: (self.bounds.width - (titleLabelWidth + 10.0 + 12.0)) * 0.5,
                                       y: (self.bounds.height - titleLabelHeight) * 0.5,
                                       width: titleLabelWidth,
                                       height: titleLabelHeight)
        
        self.indicatorImageView.frame = CGRect(x: self.titleLabel.frame.maxX + 10.0,
                                               y: (self.bounds.height - 5.0) * 0.5,
                                               width: 12.0,
                                               height: 5.0)
        
//        self.frame = CGRect(x: self.frame.minX,
//                            y: self.frame.minY,
//                            width: self.titleLabel.bounds.width + self.indicatorImageView.bounds.width + 10.0,
//                            height: self.titleLabel.bounds.height)
    }
    
    func setupUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.indicatorImageView)
    }

    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        self.clickHandler?()
    }
    
}

import UIKit

internal class AlbumTableViewCell: UITableViewCell {

    lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(hex: 0x333333)
        label.textAlignment = .left
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hex: 0xADADB6)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let paddingLeft: CGFloat = 10.0
        let paddingRight: CGFloat = 10.0
        let paddingTop: CGFloat = 5.0
        
        let thumbnailImageHeight: CGFloat = self.contentView.bounds.height - paddingTop*2.0
        let thumbnailImageWidth: CGFloat = thumbnailImageHeight
        let countLabelWidth: CGFloat = 40.0
        
        self.thumbnailImageView.frame = CGRect(
            x: paddingLeft,
            y: paddingTop,
            width: thumbnailImageWidth,
            height: thumbnailImageHeight
        )
        
        self.titleLabel.frame = CGRect(x: self.thumbnailImageView.frame.maxX + 10.0,
                                       y: paddingTop,
                                       width: self.contentView.bounds.width - paddingLeft - thumbnailImageWidth - 10.0 - countLabelWidth - paddingRight,
                                       height: thumbnailImageHeight)
        
        self.countLabel.frame = CGRect(x: self.contentView.bounds.width - paddingRight - countLabelWidth,
                                       y: paddingTop,
                                       width: countLabelWidth,
                                       height: thumbnailImageHeight)
    }
    
    func setupUI() {
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.countLabel)
    }
    
}

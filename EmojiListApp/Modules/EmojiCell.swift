import UIKit

class EmojiCell: UICollectionViewCell {
    static let cellIdentifier = "EmojiCell"
    var index: Int?
    
    var emojiLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.font = UIFont(name: "Rockwell", size: 35)
        return label
    }()
    
    var emojiName: UILabel = {
        var label = UILabel(frame: CGRect(x: 8, y: 0, width: 20, height: 100))
        label.font = UIFont(name: "Rockwell", size: 12)
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let deleteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "minus.circle.fill"))
        imageView.tintColor = .systemRed
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        emojiName.preferredMaxLayoutWidth = contentView.bounds.width
        setupEmojiLabelConstraints()
        setupEmojiNameConstraints()
        setupEmojiDeleteImageViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(emoji: Emoji){
        if let character = emoji.character, let name = emoji.name{
            emojiLabel.text = character
            emojiName.text = name
        }
        hideDeleteIcon()
    }
    
    func addViews() {
        contentView.addSubview(emojiLabel)
        contentView.addSubview(emojiName)
        contentView.addSubview(deleteImageView)
        contentView.clipsToBounds = true
    }
    
    func setupEmojiLabelConstraints() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
        ])
    }
    
    func setupEmojiNameConstraints() {
        emojiName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiName.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            emojiName.centerXAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerXAnchor),
        ])
    }
    
    func setupEmojiDeleteImageViewConstraints() {
        deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            deleteImageView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
  
    func showDeleteIcon() {
        deleteImageView.isHidden = false
    }
    
    func hideDeleteIcon() {
        deleteImageView.isHidden = true
    }
    
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 5
        shakeAnimation.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        shakeAnimation.fromValue = NSValue(cgPoint: fromPoint)
        shakeAnimation.toValue = NSValue(cgPoint: toPoint)
        
        layer.add(shakeAnimation, forKey: "position")
    }
}



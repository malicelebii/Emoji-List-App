import UIKit

class DetailsViewController: UIViewController {
    var favoritesViewModel = FavoritesViewModel()
    
    var emojiLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        label.font = UIFont(name: "Rockwell", size: 150)
        return label
    }()

    var emojiName: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.font = UIFont(name: "Rockwell", size: 20)
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    var addToFavoritesButton: UIButton = {
        var button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.configuration = .filled()
        button.setTitle("Add to favorites", for: .normal)
        return button
    }()
    
    var emoji: Emoji?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureEmojiLabel()
        configureEmojiName()
        configureAddToFavoritesButton()
        setupEmojiLabelConstraints()
        setupEmojiNameConstraints()
        setupAddToFavoritesButtonConstraints()
    }
    
    @objc func addToFavorites() {
        if let emoji = emoji {
            favoritesViewModel.addToFavorites(emoji: emoji) {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.presentingViewController?.view.showToast(message: "Emoji added successfully !")
                }
            }
        }
    }
    
    func addViews() {
        view.addSubview(emojiLabel)
        view.addSubview(emojiName)
        view.addSubview(addToFavoritesButton)
    }
    
    func configureEmojiLabel() {
        if let emoji = emoji {
            emojiLabel.text = emoji.character
        }
    }
    
    func configureEmojiName() {
        if let emoji = emoji {
            emojiName.text = emoji.name
        }
    }
    
    func configureAddToFavoritesButton() {
        addToFavoritesButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
    }
    
    func setupEmojiLabelConstraints() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80),
        ])
    }
    
    func setupEmojiNameConstraints() {
        emojiName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func setupAddToFavoritesButtonConstraints() {
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToFavoritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToFavoritesButton.topAnchor.constraint(equalTo: emojiName.bottomAnchor, constant: 100 ),
        ])
    }
}

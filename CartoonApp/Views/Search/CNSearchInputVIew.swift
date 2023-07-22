//
//  CNSearchInputVIew.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/14/23.
//

import UIKit

protocol CNSearchInputViewDelegate: AnyObject {
    func cnSearchInputView(_ inputView: CNSearchInputView, didSelectOption option: CNSearchInputViewViewModel.DynamicOption)
}

class CNSearchInputView: UIView {

    weak var delegate: CNSearchInputViewDelegate?

    private var viewModel: CNSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()

    private let button: UIButton = {
        let button = UIButton()

        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViewHierarchy()
        setupViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {
        addSubviews(searchBar, stackView)
    }

    private func setupViewLayout() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 62),

            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func createOptionSelectionViews(options: [CNSearchInputViewViewModel.DynamicOption]) {

        for i in 0..<options.count {
            let option = options[i]
            let button = createButton(with: option, tag: i)
            stackView.addArrangedSubview(button)
        }
    }

    private func createButton(with option: CNSearchInputViewViewModel.DynamicOption, tag: Int) -> UIButton {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18, weight: .medium), .foregroundColor: UIColor.label]
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        button.setAttributedTitle(NSAttributedString(string: option.rawValue, attributes: attributes), for: .normal)

        return button
    }

    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selectedOption = options[tag]

        delegate?.cnSearchInputView(self, didSelectOption: selectedOption)
    }

    public func configure(with viewModel: CNSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        // TODO: make zero heigth when no button options
        self.viewModel = viewModel
    }

    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }

    public func update(option:  CNSearchInputViewViewModel.DynamicOption, value: String) {
        guard let allOptions = viewModel?.options, let index = allOptions.firstIndex(of: option), let buttons = stackView.arrangedSubviews as? [UIButton] else {
            return
        }

        let button: UIButton = buttons[index]

        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18, weight: .medium), .foregroundColor: UIColor.link]

        button.setAttributedTitle(NSAttributedString(string: value.uppercased()+" \u{2714}", attributes: attributes), for: .normal)
    }
}

//
//  CNSearchOptionPickerViewController.swift
//  CartoonApp
//
//  Created by Anton Veldanov on 7/16/23.
//

import UIKit

final class CNSearchOptionPickerViewController: UIViewController {

    private let option: CNSearchInputViewModel.DynamicOption
    private let selectionBlock: ((String) -> Void)

    private let tabelView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    // MARK: - Init

    init(option: CNSearchInputViewModel.DynamicOption, selectionBlock: @escaping (String) -> Void) {
        self.selectionBlock = selectionBlock
        self.option = option
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        tabelView.delegate = self
        tabelView.dataSource = self

        setupViewHierarchy()
        setupViewLayout()
    }

    private func setupViewHierarchy() {
        view.addSubview(tabelView)
    }

    private func setupViewLayout() {
        tabelView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tabelView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tabelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CNSearchOptionPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.choices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let choice = option.choices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = choice.uppercased()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //Inform caller of choice
        let choice = option.choices[indexPath.row]
        self.selectionBlock(choice)

        dismiss(animated: true)
    }
}

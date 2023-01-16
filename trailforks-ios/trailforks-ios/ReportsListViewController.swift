//
// Created by Michael Pace on 1/16/23.
//

import Foundation
import UIKit

class ReportsListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: "ReportTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchReports), for: .valueChanged)
        return refreshControl
    }()

    private var reports = [TFReport]()

    private let trailforksAPI: TFAPI
    private let dispatchQueue: TFDispatchQueue

    init(
        trailforksAPI: TFAPI,
        dispatchQueue: TFDispatchQueue
    ) {
        self.trailforksAPI = trailforksAPI
        self.dispatchQueue = dispatchQueue

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = tableView
        navigationItem.title = "Trailforks Test"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchReports()
    }

    @objc private func fetchReports() {
        trailforksAPI.fetchReports { [weak self] result in
            guard let self = self else { return }

            self.dispatchQueue.async {
                self.refreshControl.endRefreshing()
            }

            switch result {
            case .success(let reports):
                self.dispatchQueue.async {
                    self.reports = reports
                    self.tableView.reloadData()
                }
            case .failure(let error): print(error)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ReportsListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !reports.isEmpty else {
            return 1
        }

        return reports.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !reports.isEmpty else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "EmptyCell")
            cell.textLabel?.text = "There are no reports!"
            cell.detailTextLabel?.text = "Pull to refresh."
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell") as? ReportTableViewCell else {
            return UITableViewCell()
        }

        cell.setupViews(report: reports[indexPath.row])

        return cell
    }
}

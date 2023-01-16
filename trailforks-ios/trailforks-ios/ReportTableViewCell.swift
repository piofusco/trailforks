//
// Created by Michael Pace on 1/16/23.
//

import Foundation
import UIKit

class ReportTableViewCell: UITableViewCell {
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter
    }()

    private lazy var statusCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(statusCircleView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorLabel)

        NSLayoutConstraint.activate([
            statusCircleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            statusCircleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            statusCircleView.heightAnchor.constraint(equalToConstant: 15),
            statusCircleView.widthAnchor.constraint(equalToConstant: 15),

            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        dateLabel.text = ""
        descriptionLabel.text = ""
        authorLabel.text = ""
    }

    func setupViews(report: TFReport) {
        switch report.status {
        case .clear: statusCircleView.backgroundColor = .green
        case .minorIssue: statusCircleView.backgroundColor = .yellow
        case .significantIssue: statusCircleView.backgroundColor = .red
        case .closed: statusCircleView.backgroundColor = .black
        }

        dateLabel.text = formatDate(epochString: report.created)
        descriptionLabel.text = report.description
        authorLabel.text = "By: \(report.username)"
    }

    private func formatDate(epochString: String) -> String {
        guard !epochString.isEmpty,
              let timeInterval = TimeInterval(epochString) else { return "" }

        return dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
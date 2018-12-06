//
//  GoalController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/2/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import Charts

class GoalController: UIViewController {
    var dailyStepsGoal: Int = 5000
    var weeklySteps = [Int]()
    var goalDataEntries: [GoalDataEntry]?
    lazy var lineChart: LineChart = {
        let chart = LineChart()
        chart.barLineValue = self.dailyStepsGoal
        return chart
    }()
    
    let weeklyGoalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let lineChartTitle: UILabel = {
        let label = UILabel()
        label.text = "Steps"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var progress: Double?
    lazy var progressBar: ProgressBar = {
        let barColor: UIColor
        if let progress = progress {
            switch progress {
            case 0..<0.44: barColor = .red
            case 0.44..<0.72: barColor = .yellow
            default: barColor = .green
            }
        } else {
            barColor = .blue
        }
        let pb = ProgressBar()
        pb.barColor = barColor
        return pb
    }()
    let countingLabel: CountingLabel = {
        let cl = CountingLabel()
        cl.font = UIFont.boldSystemFont(ofSize: 28)
        cl.textAlignment = .center
        return cl
    }()
    
    let snowflakeEmitter: CAEmitterLayer = Emitter.get(with: #imageLiteral(resourceName: "snowflake"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "goalBG.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        progressBar.backgroundColor = .clear
        view.addSubview(progressBar)
        progressBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, padding: UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 100))
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70).isActive = true
        countingLabel.endValue = progress ?? 0.0
        progressBar.addSubview(countingLabel)
        countingLabel.fillSuperView()
       
        
        view.addSubview(lineChart)
        lineChart.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .init(width: 0, height: 250))
        view.addSubview(lineChartTitle)
        NSLayoutConstraint.activate([
            lineChartTitle.widthAnchor.constraint(equalTo: lineChart.widthAnchor),
            lineChartTitle.bottomAnchor.constraint(equalTo: lineChart.topAnchor, constant: -10),
            lineChartTitle.leadingAnchor.constraint(equalTo: lineChart.leadingAnchor),
            lineChartTitle.trailingAnchor.constraint(equalTo: lineChart.trailingAnchor)
            ])
        
        goalDataEntries = [GoalDataEntry]()
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: today) ?? today
        (0..<7).forEach { (daysFromSevenDaysAgo) in
            let day = Calendar.current.date(byAdding: .day, value: daysFromSevenDaysAgo, to: sevenDaysAgo) ?? today
            let goalDataEntry: GoalDataEntry
            if weeklySteps.isEmpty {
                goalDataEntry = GoalDataEntry(date: day, steps: 0)
            } else if daysFromSevenDaysAgo == 6 && weeklySteps.count == 6 {
                // corner case: if today's data is unavailable yet 
                goalDataEntry = GoalDataEntry(date: day, steps: 0)
            } else {
                goalDataEntry = GoalDataEntry(date: day, steps: weeklySteps[daysFromSevenDaysAgo])
            }
            goalDataEntries?.append(goalDataEntry)
        }
        lineChart.goalDataEntries = goalDataEntries
        
        view.layer.addSublayer(snowflakeEmitter)
        
        if let progress = progress {
            let days = Int(progress * 7)
            weeklyGoalLabel.text = "Weekly exercise\n\(days) of 7 days\ndaily goal achieved"
        }
        view.addSubview(weeklyGoalLabel)
        NSLayoutConstraint.activate([
            weeklyGoalLabel.trailingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            weeklyGoalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            weeklyGoalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            weeklyGoalLabel.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor)
            ])
        setupEmitterLoc()
    }
    
    fileprivate func setupEmitterLoc() {
        snowflakeEmitter.emitterSize = .init(width: view.bounds.maxX, height: 1)
        snowflakeEmitter.emitterPosition = .init(x: view.bounds.midX, y: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBar.startAnimationTo = progress ?? 0.0
        lineChart.barLineValue = Settings.dailySteps
    }
}

struct GoalDataEntry {
    let date: Date
    let steps: Int
}

extension ChartDataEntry {
    convenience init(goalDataEntry: GoalDataEntry) {
        self.init()
        x = goalDataEntry.date.timeIntervalSince1970
        y = Double(goalDataEntry.steps)
    }
}

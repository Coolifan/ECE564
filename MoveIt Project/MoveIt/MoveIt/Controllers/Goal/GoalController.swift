//
//  GoalController.swift
//  MoveIt
//
//  Created by Haohong Zhao on 11/2/18.
//  Copyright © 2018 MoveIt. All rights reserved.
//

import UIKit
import Charts

//TODO: - learn costum trasition animation

class GoalController: UIViewController {
    var goalDataEntries: [GoalDataEntry]?
    let lineChart: LineChart = {
        let chart = LineChart()
        return chart
    }()
    
    var progress: Double?
    var progressBar: ProgressBar = {
        let pb = ProgressBar()
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
        view.backgroundColor = .white
        progressBar.backgroundColor = .white
        view.addSubview(progressBar)
        progressBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, padding: UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 100))
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countingLabel.endValue = progress ?? 0.0
        progressBar.addSubview(countingLabel)
        countingLabel.fillSuperView()
        
        view.addSubview(lineChart)
        lineChart.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .init(width: 0, height: 300))
        
        goalDataEntries = [GoalDataEntry]()
        let today = Date()
        (1...10).forEach { (daysFromToday) in
            let day = Calendar.current.date(byAdding: .day, value: daysFromToday, to: today) ?? today
            let goalDataEntry = GoalDataEntry(date: day, score: 3)
            goalDataEntries?.append(goalDataEntry)
        }
        lineChart.goalDataEntries = goalDataEntries
        
        view.layer.addSublayer(snowflakeEmitter)
        setupEmitterLoc()
    }
    
    fileprivate func setupEmitterLoc() {
        snowflakeEmitter.emitterSize = .init(width: view.bounds.maxX, height: 1)
        snowflakeEmitter.emitterPosition = .init(x: view.bounds.midX, y: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBar.startAnimationTo = progress ?? 0.0
        
    }
}

struct GoalDataEntry {
    let date: Date
    let score: Double
}

extension ChartDataEntry {
    convenience init(goalDataEntry: GoalDataEntry) {
        self.init()
        x = goalDataEntry.date.timeIntervalSince1970
        y = goalDataEntry.score
    }
}

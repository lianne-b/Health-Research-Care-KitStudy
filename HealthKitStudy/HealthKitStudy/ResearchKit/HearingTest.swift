//
//  HearingTest.swift
//  HealthKitStudy
//
//  Created by Ye Eun Choi on 2023/06/27.
//

import ResearchKit

let hearingTask = ORKOrderedTask.dBHLToneAudiometryTask(withIdentifier: "toneAudiometry", intendedUseDescription: "", options: .excludeAccelerometer)

let taskViewController = ORKTaskViewController(task: hearingTask, taskRun: UUID())

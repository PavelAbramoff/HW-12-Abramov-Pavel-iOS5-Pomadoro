//
//  ViewController.swift
//  HW-12-Abramov-Pavel-iOS5-Pomadoro
//
//  Created by Pavel Абрамов on 27.04.2022.
//

import UIKit

  class ViewController: UIViewController {
    
    enum IntervalType {
      case Pomodoro
      case RestBreak
    }
    
  var intervals: [IntervalType] = [.Pomodoro,.RestBreak,.Pomodoro,
                                     .RestBreak,.Pomodoro,.RestBreak,.Pomodoro]
    
  var currentInterval = 0
  let pomodoroIntervalTime = 10
  let restBreakIntervalTime = 5
  var timeRemaining = 0
  var timer = Timer()
    
  @IBOutlet weak var minutesLabel: UILabel!
  @IBOutlet weak var secondLabel: UILabel!
  @IBOutlet weak var intervalLabel: UILabel!
  @IBOutlet weak var startPauseButton: UIButton!
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var shapeViev: UIImageView!
    
  @IBAction func startPauseButton(_ sender: Any) {
                basivAnimation()
                if timer.isValid {
                startPauseButton.setTitle("Resume", for: .normal)
                    pauseAnimation(layer: shapeLayer)
                resetButton.isEnabled = true
                pauseTimer()
               
        } else {
           startPauseButton.setTitle("Pause", for: .normal)
           resetButton.isEnabled = false
           resumeAnimation(layer: shapeLayer)
        if currentInterval == 0 && timeRemaining == pomodoroIntervalTime {
           startNextInterval()
        } else {
          startTimer()
        }
    }
}
    
  @IBAction func resetButton(_ sender: Any) {
        if timer.isValid {
           timer.invalidate()
        }
           resetToBegining()
      }

   let shapeLayer = CAShapeLayer()
    
  override func viewDidLoad() {
        super.viewDidLoad()
         animationCircular()
         resetToBegining()
    }
        
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  func resetToBegining() {
        currentInterval = 0
        intervalLabel.text = "Готов"
        startPauseButton.setTitle("Start", for: .normal)
        resetButton.isEnabled = false
        timeRemaining = pomodoroIntervalTime
        updateDisplay()
    }
    
  func startNextInterval() {
     if currentInterval < intervals.count {
        if intervals[currentInterval] == .Pomodoro {
           timeRemaining = pomodoroIntervalTime
           intervalLabel.text = "За работу !"
        } else {
           timeRemaining = restBreakIntervalTime
           intervalLabel.text = "Отличная работа!"
        }
           updateDisplay()
           startTimer()
           currentInterval += 1
        } else {
           resetToBegining()
    }
  }
    
  func updateDisplay() {
      let (minutes, seconds) = minutesAndSeconds(from: timeRemaining)
      minutesLabel.text = formatMinuteOrSecond(minutes)
      secondLabel.text = formatMinuteOrSecond(seconds)
  }
    
  func startTimer() {
      basivAnimation()
      timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerTick),
                                     userInfo: nil,
                                     repeats: true
      )
      
  }
    
  @objc func timerTick() {
      if timeRemaining > 0 {
         timeRemaining -= 1
      print("time: \(timeRemaining)")
         updateDisplay()
      } else {
         timer.invalidate()
         startNextInterval()
   }
 }
    
  func pauseTimer() {
      timer.invalidate()
      intervalLabel.text = "Paused."
  }

  func minutesAndSeconds(from seconds: Int) -> (Int, Int) {
      return (seconds / 60, seconds % 60)
  }
      
  func formatMinuteOrSecond(_ number: Int) -> String {
      return String(format: "%02d", number)
  }
    
    // MARK: Animation
    
  func animationCircular() {
      let center = CGPoint(x: shapeViev.frame.width / 2,
                             y: shapeViev.frame.height / 2)
      let endAngle = (-CGFloat.pi / 2)
      let startAngle = 2 * CGFloat.pi + endAngle
      let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 112,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)

     shapeLayer.path = circularPath.cgPath
     shapeLayer.lineWidth = 62
     shapeLayer.fillColor = UIColor.clear.cgColor
     shapeLayer.strokeEnd = 1
     shapeLayer.lineCap = CAShapeLayerLineCap.round
     shapeLayer.strokeColor = UIColor.link.cgColor
     shapeViev.layer.addSublayer(shapeLayer)
  }
      
 func pauseAnimation(layer : CAShapeLayer){
    let pausedTime : CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime;
    }

  func resumeAnimation(layer : CAShapeLayer){
     let pausedTime: CFTimeInterval = layer.timeOffset
     layer.speed = 1.0
     layer.timeOffset = 0.0
     layer.beginTime = 0.0
     let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
     layer.beginTime = timeSincePause;
    }
      
  func basivAnimation() {
     let basivAnimation = CABasicAnimation(keyPath: "strokeEnd")
     basivAnimation.toValue = 0
     basivAnimation.duration = CFTimeInterval(pomodoroIntervalTime)
     basivAnimation.fillMode = CAMediaTimingFillMode.forwards
     basivAnimation.isRemovedOnCompletion = true
     shapeLayer.add(basivAnimation, forKey: "basivAnimation")
    }

  }

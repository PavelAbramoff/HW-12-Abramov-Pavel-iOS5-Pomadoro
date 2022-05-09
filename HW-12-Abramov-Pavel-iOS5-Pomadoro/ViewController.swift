
//  ViewController.swift
//  HW-12-Abramov-Pavel-iOS5-Pomadoro
//
//  Created by Pavel Абрамов on 27.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Elements
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var shapeViev: UIImageView!
    
    enum TimerMode {
        case rest
        case work
        case safe
        case pause
    }
    
    private let workIntervalTime = 10
    private let restIntervalTime = 5
    private let shapeLayer = CAShapeLayer()
    private lazy var mode: TimerMode = .safe
    private lazy var previousMode: TimerMode = .safe
    private lazy var currentIntervalTime = workIntervalTime
    private lazy var timer = Timer()
    private lazy var ms: Float = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationCircular()
        resetToBegining()
    }
    
    // MARK: - Private functions
    
    private func resetToBegining() {
        intervalLabel.text = "Готов"
        startPauseButton.setTitle("Start", for: .normal)
        mode = .safe
        resetButton.isEnabled = false
        currentIntervalTime = workIntervalTime
        basivAnimation()
        pauseAnimation(layer: shapeLayer)
        updateDisplay(time: currentIntervalTime)
    }
    
    private func changeMode(to mode: TimerMode) {
        timer.invalidate()
        switch mode {
        case .rest:
            currentIntervalTime = restIntervalTime
            self.mode = .rest
            basivAnimation()
            intervalLabel.text = "Отличная работа!"
        case .work:
            currentIntervalTime = workIntervalTime
            self.mode = .work
            basivAnimation()
            resumeAnimation(layer: shapeLayer)
            intervalLabel.text = "За работу !"
        case .pause:
            resumeAnimation(layer: shapeLayer)
            self.mode = previousMode
        default: break
        }
        startPauseButton.setTitle("Pause", for: .normal)
        startTimer()
        updateDisplay(time: currentIntervalTime)
    }
    
    private func updateDisplay(time: Int) {
        let (minutes, seconds) = minutesAndSeconds(from: time)
        minutesLabel.text = formatMinuteOrSecond(minutes)
        secondLabel.text = formatMinuteOrSecond(seconds)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001,
                                     target: self,
                                     selector: #selector(timerTick),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func pauseTimer() {
        timer.invalidate()
        intervalLabel.text = "Paused."
    }
    
    private func minutesAndSeconds(from seconds: Int) -> (Int, Int) {
        (seconds / 60, seconds % 60)
    }
    
    private func formatMinuteOrSecond(_ number: Int) -> String {
        String(format: "%02d", number)
    }
    
    // MARK: - Actions
    
    @IBAction func startPauseButton(_ sender: Any) {
        switch mode {
        case .rest:
            timer.invalidate()
            previousMode = mode
            mode = .pause
            resetButton.isEnabled = true
            startPauseButton.setTitle("Resume", for: .normal)
            pauseAnimation(layer: shapeLayer)
        case .work:
            timer.invalidate()
            previousMode = mode
            mode = .pause
            resetButton.isEnabled = true
            startPauseButton.setTitle("Resume", for: .normal)
            pauseAnimation(layer: shapeLayer)
        case .safe:
            mode = .work
            resetButton.isEnabled = false
            changeMode(to: .work)
        case .pause:
            resetButton.isEnabled = false
            changeMode(to: mode)
        }
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        timer.invalidate()
        resetToBegining()
    }
    
    @objc func timerTick() {
        ms += 1
        if ms > 999 {
            ms = 0
            if currentIntervalTime > 0 {
                currentIntervalTime -= 1
                updateDisplay(time: currentIntervalTime)
            } else {
                switch mode {
                case .rest:
                    changeMode(to: .work)
                case .work:
                    changeMode(to: .rest)
                default: break
                }
            }
        }
    }
    
    // MARK: Animation functions
    
    private func animationCircular() {
        let center = CGPoint(
            x: shapeViev.frame.width / 2,
            y: shapeViev.frame.height / 2
        )
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
    
    private func pauseAnimation(layer : CAShapeLayer){
        let pausedTime : CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    private func resumeAnimation(layer : CAShapeLayer){
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    private func basivAnimation() {
        let basivAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basivAnimation.toValue = 0
        basivAnimation.duration = CFTimeInterval(currentIntervalTime)
        basivAnimation.fillMode = CAMediaTimingFillMode.forwards
        basivAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basivAnimation, forKey: "basivAnimation")
    }
}

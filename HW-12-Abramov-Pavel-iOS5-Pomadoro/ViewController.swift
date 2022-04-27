//
//  ViewController.swift
//  HW-12-Abramov-Pavel-iOS5-Pomadoro
//
//  Created by Pavel Абрамов on 27.04.2022.
//

import UIKit

class ViewController: UIViewController {

    let leassonLable: UILabel = {
        let label = UILabel()
        label.text = "My Timer"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let shapeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "elips")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let timerLable: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .systemRed
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 35
        button.setTitle("START", for: .normal)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var timer = Timer()
    
    let shapeLayer = CAShapeLayer()
    
    var durationTimer = 20
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLable.text = "\(durationTimer)"
        
        view.backgroundColor = .blue
        
        setConstraints()
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    @objc func startButtonTapped() {
        
        basivAnimation()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(){
        
        durationTimer -= 1
        timerLable.text = "\(durationTimer)"
        print(durationTimer)
        
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = 20
            timer.invalidate()
            
        }
    }
    
    // MARK: Animation
    
    func animationCircular(){
        
        let center = CGPoint(x: shapeView.frame.width / 2, y: shapeView.frame.height / 2)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 120, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 80
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeView.layer.addSublayer(shapeLayer)
    }
    func basivAnimation() {
        
        let basivAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basivAnimation.toValue = 0
        basivAnimation.duration = CFTimeInterval(durationTimer)
        basivAnimation.fillMode = CAMediaTimingFillMode.forwards
        basivAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basivAnimation, forKey: "basivAnimation")
    }
}
extension ViewController {
    
    func setConstraints() {
    
    view.addSubview(leassonLable)
    NSLayoutConstraint.activate([
        leassonLable.topAnchor.constraint(equalTo: view.topAnchor,constant: 150),
        leassonLable.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
        leassonLable.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:  -20),
    ])
         
        view.addSubview(shapeView)
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shapeView.heightAnchor.constraint(equalToConstant: 300),
            shapeView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        shapeView.addSubview(timerLable)
        NSLayoutConstraint.activate([
            timerLable.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLable.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
            
        ])
        
    view.addSubview(startButton)
    NSLayoutConstraint.activate([
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        startButton.heightAnchor.constraint(equalToConstant: 70),
        startButton.widthAnchor.constraint(equalToConstant: 300)
    ])
                                              
    }
}

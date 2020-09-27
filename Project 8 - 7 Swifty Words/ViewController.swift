//
//  ViewController.swift
//  Project 8 - Game Entirely By Code
//
//  Created by Shana Pougatsch on 9/10/20.
//  Copyright © 2020 Shana Pougatsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//MARK:- Properties
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
 
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var level = 1
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var shownButtons = 0 {
        didSet {
            print(shownButtons)
        }
    }
//MARK:- Custom View Management (Manual Configuration)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black
        
        // UILabels
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.textColor = .white
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont (name: "Verdana", size: 22)
        cluesLabel.text = "CLUES"
        cluesLabel.textColor = .systemPink
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont(name: "Verdana", size: 22)
        answersLabel.text = "ANSWERS"
        answersLabel.textColor = .systemPink
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.attributedPlaceholder = NSAttributedString(string: "Tap letters to guess", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textColor = .white
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // UIButtons
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // NSLayout (auto-layout) constraints & anchors (using an array, add commas!)
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // pin the top of the clues label to te bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // pin the leading edge of the clues label to the leading edge of out layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            // buttonsView width = 750
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            // buttonsView height = 320
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            // buttonsView centered horizontally
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // set top anchor to be the bottom of the submit button, plus 20 pts
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            // pin it to the bottom of our layout margins, -20 so that it doesn't run quite to edge
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        // button w x h
        let width = 150
        let height = 80
        
        // create 20 buttons as a 4x5 grid
        for row in 0..<4 {
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                // give the button some temporary text so we can see it on screen
                letterButton.setTitle("JJJ", for: .normal)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to our letterButtons array
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
    }
            
//MARK:- View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }
//MARK:- Tapped Methods
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
        shownButtons += 1
    }
            
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
        
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            if shownButtons == 20 {
                if score % 7 == 0 {
                    let win = UIAlertController(title: "You got this!", message: "Are you ready for the next level?", preferredStyle: .alert)
                    win.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                    present(win, animated: true)
                } else if score <= 4 {
                    let lost = UIAlertController(title: "Almost!", message: nil, preferredStyle: .alert)
                    lost.addAction(UIAlertAction(title: "Try again!", style: .default, handler: restartLevel))
                    present(lost, animated: true)
                }
            }
        } else {
            let incorrectAC = UIAlertController(title: "Oops!", message: "Let's try that again!", preferredStyle: .alert)
            incorrectAC.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak currentAnswer] _ in
                currentAnswer?.text = ""
                
                for btn in self.activatedButtons {
                    btn.isHidden = false
                }
                
                self.activatedButtons.removeAll()
            })
            
            present (incorrectAC, animated: true)
            score -= 1
        }
    }

    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for btn in activatedButtons {
            btn.isHidden = false
           }
           
           activatedButtons.removeAll()
       }
//MARK:- Methods
  
    func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionsString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
                
            }
        }
        
        // configure the buttons and labels
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }

    func levelUp(action: UIAlertAction) {
        level += 1
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        showLetterButtons()
    }
        
    func restartLevel(action: UIAlertAction) {
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        showLetterButtons()
    }
            
    func showLetterButtons() {
        for btn in letterButtons {
        btn.isHidden = false
        }
    }
}
             
    
    







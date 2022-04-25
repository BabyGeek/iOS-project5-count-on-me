//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Modified by Paul Oggero on 13/04/2022.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = calculator.getShortenText()
        }
    }
    @IBOutlet weak var shortenButton: UIButton!
    @IBOutlet var numberButtons: [UIButton]!

    let calculator: CalculatorModel = CalculatorModel()

    var elements: [String] {
        textView.text.split(separator: " ").map { "\($0)" }
    }

    // Error check computed variables
    var expressionIsCorrect: Bool {
        calculator.checkExpressionIsCorrect()
    }

    var expressionHaveEnoughElement: Bool {
        calculator.checkCountElements()
    }

    var canAddOperator: Bool {
        calculator.checkIfCanAddOperator()
    }

    var expressionHaveResult: Bool {
        calculator.checkCalculDoneFor(textView.text)
    }

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.text = ""
        updateShortenButtonDisplay()

    }

    /// Show an alert to the user
    /// - Parameters:
    ///   - title: title of the alert, "Zéro !" by default
    ///   - message: The message to show to the user in the alert
    func showAlert(title: String = "Zéro !", message: String) {
        let alertVC = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

    /// Reset textView and calculator to start new calcul
    func reset() {
        self.textView.text = ""
        self.calculator.reset()
    }
}

// MARK: - tappedNumbers

extension ViewController {

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }

        calculator.addNumber(Float(numberText)!)
        textView.text.append(numberText)
    }
}

// MARK: - Actions

extension ViewController {

    @IBAction func tappedShortenButton(_ sender: UIButton) {
        textView.text = calculator.getShortenText()
        updateShortenButtonDisplay()
    }

    @IBAction func tappedResetButton(_ sender: UIButton) {
        self.reset()
        self.updateShortenButtonDisplay()
    }
}

// MARK: - tappedButton for operand

extension ViewController {
    // View actions

    /// Get the addition button tapped event
    /// - Parameter sender: Addition button
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        do {
            try tappedButton(.plus)
        } catch CalculationErrors.operandNotFound {
            return self.showAlert(message: "Opérateur introuvable !")
        } catch {
            return self.showAlert(message: "Erreur inconnue.")
        }
    }

    /// Get the substraction button tapped event
    /// - Parameter sender: Substraction button
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        do {
            try tappedButton(.minus)
        } catch CalculationErrors.operandNotFound {
            return self.showAlert(message: "Opérateur introuvable !")
        } catch {
            return self.showAlert(message: "Erreur inconnue.")
        }
    }

    /// Get the division button tapped event
    /// - Parameter sender: Division button
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        do {
            try tappedButton(.divide)
        } catch CalculationErrors.operandNotFound {
            return self.showAlert(message: "Opérateur introuvable !")
        } catch {
            return self.showAlert(message: "Erreur inconnue.")
        }
    }

    /// Get the multiplication button tapped event
    /// - Parameter sender: Multiplication button
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        do {
            try tappedButton(.multiply)
        } catch CalculationErrors.operandNotFound {
            return self.showAlert(message: "Opérateur introuvable !")
        } catch {
            return self.showAlert(message: "Erreur inconnue.")
        }
    }

    func tappedButton(_ operand: Operator) throws {
        if canAddOperator {
            calculator.addOperand(operand)
            textView.text.append(" \(operand.rawValue) ")
        } else {
            if calculator.operands.isEmpty {
                return self.showAlert(message: "Un opérateur de ce type ne peux pas être placé au début du calcul")
            }

            return self.showAlert(message: "Un operateur est déja mis !")
        }
    }
}

// MARK: - Main calculs
extension ViewController {

    /// Get the event of equal button tapped and ask the model for the result
    /// - Parameter sender: the equal button cliecked
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionHaveEnoughElement else {
            return self.showAlert(message: "Démarrez un nouveau calcul !")
        }

        guard expressionIsCorrect else {
            return self.showAlert(message: "Entrez une expression correcte !")
        }

        do {
            var operationsToReduce = elements
            let result = try calculator.doCalcul()

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
            textView.text.append(" = \(operationsToReduce.first!)")
            updateShortenButtonDisplay()

        } catch CalculationErrors.divideByZero {
            textView.text.append(" = NaN")
            return self.showAlert(message: "Division par zéro, non autorisée !")
        } catch CalculationErrors.notFound {
            textView.text.append(" = NaN")
            return self.showAlert(message: "Opération non trouvée, veuillez recommencer !")
        } catch CalculationErrors.operandFirstPosition {
            return self.showAlert(message: "Vous ne pouvez pas placer un opérateur en première position !")
        } catch CalculationErrors.calculationError {
            textView.text.append(" = NaN")
            reset()
            return self.showAlert(message: "Erreur inconnue rencontrée lors du calcul, veuillez recommencer le calcul")
        } catch {
            textView.text.append(" = NaN")
            return self.showAlert(message: "Erreur inconnue rencontrée, veuillez recommencer le calcul")
        }
    }
}

// MARK: - Update display

extension ViewController {

    func updateShortenButtonDisplay() {
        if expressionHaveResult && textView.text != calculator.getShortenText() {

            shortenButton.backgroundColor = UIColor.systemBlue
            shortenButton.tintColor = .white

            if #available(iOS 13.0, *) {
                shortenButton.setImage(UIImage(systemName: "text.badge.minus"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        } else {

            shortenButton.backgroundColor = UIColor(named: "Default")

            if #available(iOS 13.0, *) {
                shortenButton.setImage(UIImage(systemName: ""), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

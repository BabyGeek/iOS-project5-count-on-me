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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    let calculator: CalculatorModel = CalculatorModel()
    
    var elements: [String] {
        textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        calculator.checkLastElementFor(elements)
    }
    
    var expressionHaveEnoughElement: Bool {
        calculator.checkCountElementsFor(elements)
    }
    
    var canAddOperator: Bool {
        calculator.checkLastElementFor(elements)
    }
    
    var expressionHaveResult: Bool {
        calculator.checkCalculDoneFor(textView.text)
//        textView.text.firstIndex(of: "=") != nil
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            textView.text = ""
        }
        
        textView.text.append(numberText)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" + ")
        } else {
            return self.showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" - ")
        } else {
            return self.showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" ÷ ")
        } else {
            return self.showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if canAddOperator {
            textView.text.append(" × ")
        } else {
            return self.showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard expressionHaveEnoughElement else {
            return self.showAlert(message: "Démarrez un nouveau calcul !")
        }
        
        guard expressionIsCorrect else {
            return self.showAlert(message: "Entrez une expression correcte !")
        }
        
        do {
            var operationsToReduce = elements
            let result = try calculator.doCalculationForElements(operationsToReduce)
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
            textView.text.append(" = \(operationsToReduce.first!)")
            
        } catch CalculationErrors.divideByZero {
            textView.text.append(" = NaN")
            return self.showAlert(message: "Division par zéro, non autorisée !")
        } catch CalculationErrors.notFound {
            textView.text.append(" = NaN")
            return self.showAlert(message: "Opération non trouvée, veuillez recommencer !")
        } catch {
            textView.text.append(" = NaN")
            return self.showAlert(message: "Erreur inconnue rencontrée, veuillez recommencer le calcul")
        }
    }
    
    func showAlert(title: String = "Zéro!", message: String) {
        let alertVC = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}


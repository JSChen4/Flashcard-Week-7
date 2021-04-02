//
//  ViewController.swift
//  Flashcards
//
//  Created by Jackie Chen on 2/20/21.
//
import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    var flashcards = [Flashcard]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readSavedFlashcards()
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the capital of Brazil", answer: "Brasilia")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
      flipFlashcard()
    }
   func flipFlashcard() {
      UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
         self.frontLabel.isHidden = true
      })
    if backLabel.isHidden == false {
       backLabel.isHidden = true
       frontLabel.isHidden = false
    } else if backLabel.isHidden == true {
       backLabel.isHidden = false
       frontLabel.isHidden = true
    }
   }
   
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        flashcards.append(flashcard)
        
        print("🤠 Added new flashcard")
        print("🤠 We now have \(flashcards.count) flashcards")
        currentIndex = flashcards.count - 1
        print("🤠 Our current index is \(currentIndex)")
        
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
    }
    
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        //updateLabels()
        updateNextPrevButtons()
        animateCardOut1()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateLabels()
        updateNextPrevButtons()
        animateCardOut2()
    }
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var prevButton: UIButton!
    
    func updateNextPrevButtons() {
      //if currentIndex == 0 {
     //    prevButton.isEnabled = false
      //   prevButton.isHidden = true
     // } else {
      //   prevButton.isEnabled = true
      //   prevButton.isHidden = false
     // }
              
      //if currentIndex == flashcards.count - 1 {
      //   nextButton.isEnabled = false
      //   nextButton.isHidden = true
      //} else {
      //   nextButton.isEnabled = true
      //   nextButton.isHidden = false
      //}
      
      if(currentIndex == 0){
            prevButton.isEnabled = false
          } else {
            prevButton.isEnabled = true
          }
      if(currentIndex == flashcards.count - 1){
            nextButton.isEnabled = false
          } else {
            nextButton.isEnabled = true
          }
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
   }
    
   func saveAllFlashcardsToDisk() {
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question": card.question, "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("🎉 Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
         let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
   
   func animateCardOut1() {
      UIView.animate(withDuration: 0.3, animations: {
         self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
      }, completion: { finished in
         self.updateLabels()
         self.animateCardIn1()
      })
   }
   
   func animateCardIn1() {
      card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
      UIView.animate(withDuration: 0.3) {
         self.card.transform = CGAffineTransform.identity
      }
   }
   
   func animateCardOut2() {
      UIView.animate(withDuration: 0.3, animations: {
         self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
      }, completion: { finished in
         self.updateLabels()
         self.animateCardIn2()
      })
   }
   
   func animateCardIn2() {
      card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
      UIView.animate(withDuration: 0.3) {
         self.card.transform = CGAffineTransform.identity
      }
   }
    
}

//
//  ViewController.swift
//  project5
//
//  Created by Waterflow Technology on 07/04/2025.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL,encoding: .utf8) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
       
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word",for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row];
        return cell;
    }
    //It needs to be called from a UIBarButtonItem action, so we must mark it @objc.
    //Hopefully you’re starting to sense when this is needed.
    
    //As UIBarButtonItem is from Core which is writted in Objective-C rather than Swift
    //To expose it to UIBarButtonItem, @objc was added to Swift function
    
    //But don’t worry if you forget – Xcode will always complain loudly if @objc is required and not present!
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            //Both ViewController and AlertController are referenced inside our closure.
            //So, weak reference should be indicated.
        
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return } // AlertController referenced (ac)
            self?.submit(answer) // ViewController referenced (self)
            
            //So, question marks (?.) are there due to weak references established.
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
           let errorMessage: String

            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        usedWords.insert(answer, at: 0)
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        return
                    }else {
                        errorTitle = "Word not recognised"
                        errorMessage = "You can't just make them up, you know!"
                    }
                }else {
                    errorTitle = "Word used already"
                    errorMessage = "Be more original!"
                }
            }else {
                guard let title = title?.lowercased() else { return }
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from \(title)"
            }
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
    }
    
    //check with the given word in title
    //so that entered word only contains the letter that are included in the title.
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

            for letter in word {
                if let position = tempWord.firstIndex(of: letter) {
                    tempWord.remove(at: position)
                } else {
                    return false
                }
            }

            return true
    }
    
    //already entered before check
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    //check for word validity in dictionary
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
            //Emoji are actually just special character combinations behind the scenes, and they are measured differently with Swift strings and UTF-16 strings: Swift strings count them as 1-letter strings, but UTF-16 considers them to be 2-letter strings. This means if you use count with UIKit methods, you run the risk of miscounting the string length.
            //I realize this seems like pointless additional complexity, so let me try to give you a simple rule: when you’re working with UIKit, SpriteKit, or any other Apple framework, use utf16.count for the character count. If it’s just your own code - i.e. looping over characters and processing each one individually – then use count instead.
            let range = NSRange(location: 0, length: word.utf16.count) //***IMP concept**//
            //UIkit is originally written in objective C
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            // NSNotFound is telling us the word is spelled correctly – i.e., it's a valid word.
            // No mis-spellings found
            return misspelledRange.location == NSNotFound
    }
    

}


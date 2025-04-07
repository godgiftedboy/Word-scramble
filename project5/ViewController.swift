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

            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        usedWords.insert(answer, at: 0)
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                }
            }
    }
    
    
    func isPossible(word: String) -> Bool {
        return true
    }

    func isOriginal(word: String) -> Bool {
        return true
    }

    func isReal(word: String) -> Bool {
        return true
    }
    

}


//
//  EditingNoteViewController.swift
//  YNotes
//
//  Created by Dzhek on 20/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

class EditingNoteViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var destroyDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var destroySwitch: UISwitch!
    @IBOutlet weak var pickerStackView: UIStackView!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var squareStackView: UIStackView!
    

    // MARK: - IBActions
    @IBAction func useDestroyDate(_ sender: UISwitch) {
        if sender.isOn {
            self.showDatePicker()
        } else {
            self.hideDatePicker()
            self.dateLabel.text = "not selected"
            self.destroyDate = nil
            self.destroyDatePicker.setDate(Date(), animated: true)
        }
    }
    @IBAction func setDesroyDate(_ sender: UIDatePicker) {
        self.setupPickerLabels(with: sender)
    }
    @IBAction func setDate(_ sender: UIButton) {
        self.hideDatePicker()
    }
    @IBAction func willTapSquare(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.view != nil else { return }

        if let touched = recognizer.view?.frame {
            self.checkSquare(touched)
        }
    }
    @IBAction func showAlert(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(
            title: "😰 Oh!",
            message:"I haven't finished developing\n the ColorPicker yet...\nYou can choose from default colors",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "close", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func tapCancelButtonItem(_ sender: UIBarButtonItem) {
        delegate?.editingDidCancel(self)
    }
    @IBAction func tapSaveButoonItem(_ sender: UIBarButtonItem) {
        let uid = self.note?.uid == nil ? nil : self.note!.uid
        self.saveNote(uid: uid)
        guard let newNote = self.note else { return }
        delegate?.editingDidSave(self, didSave: newNote, isEdited: self.isEdited)
    }
    
    // MARK: - Properties
    weak var delegate: EditingNoteViewControllerDelegate?
    var note: Note?
    var isEdited: Bool = false
    static var pickedColor = UIColor.white
    private var checkedSquare: UIView?
    private var colorIndex: Int?
    private let check = Check(frame: CGRect(x: 27.0, y: -7.0, width: 24.0, height: 24.0))
    private let colorsNote: [UIColor] = [.white, UIColor(hex: "ffc71c"), UIColor(hex: "17d0bc"), UIColor(hex: "4066ea")]
    private var destroyDate: Date?
    private var keyboardDismissTapGesture: UIGestureRecognizer?
    private let placeholderBackground = UIColor(hex: "f8")
    

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.style()
        self.setColorForSquare()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        if let note = self.note {
            self.acceptEditingNote(note)
        } else {
            self.setupPlaceholder(self.titleTextView)
            self.setupPlaceholder(self.contentTextView)
            self.setDateButton.isEnabled = false
            self.pickerStackView.isHidden = true
            self.destroySwitch.isOn = false
            self.saveBarButtonItem.isEnabled = self.chekEmptyTextView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        launchObserverKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    private func acceptEditingNote(_ note: Note) {
        self.isEdited = true
        self.titleTextView.text = note.title
        self.contentTextView.text = note.content
        
        let squares = self.squareStackView.subviews
        switch note.color.hexValue {
            case colorsNote[1].hexValue:
                self.checkSquare(squares[1].frame)
                self.colorIndex = 1  //squares[1].addSubview(check)
            case colorsNote[2].hexValue: self.checkSquare(squares[2].frame) //squares[2].addSubview(check)
            case colorsNote[3].hexValue: self.checkSquare(squares[3].frame) //squares[3].addSubview(check)
            default: self.checkSquare(squares[0].frame) //squares[0].addSubview(check)
        }
        
        
        if let date = note.selfDestructionDate {
            self.dateLabel.text = date.asString()
            self.destroyDate = date
            self.destroySwitch.isOn = true
        } else {
            self.destroySwitch.isOn = false
        }
        
    }
    
    private func saveNote(uid: String?) {
        guard let title = self.titleTextView.text,
            let content = self.contentTextView.text
            else { return }
        let color = self.colorsNote[self.colorIndex!]
        let importance: Note.Importance = .medium
        let date = self.destroyDate
        
        if uid == nil {
            self.note = Note(title: title,
                             content: content,
                             color: color,
                             importance: importance,
                             selfDestructionDate: date)
        } else {
            self.note = Note(uid: uid!,
                             title: title,
                             content: content,
                             color: color,
                             importance: importance,
                             selfDestructionDate: date)
        }
    }
    
    private func setupPlaceholder(_ textView: UITextView) {
        if textView.text.isEmpty {
            UIView.animate(withDuration: 0.1,
                           animations: { textView.backgroundColor = self.placeholderBackground },
                           completion: nil )
        }
    }
    
    private func chekEmptyTextView() -> Bool {
        if self.titleTextView.text.isEmpty || self.contentTextView.text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    private func setColorForSquare() {
        let squares = self.squareStackView.subviews
        guard let firstSquare = self.squareStackView.subviews.first as? SquareView,
            let lastSquare = self.squareStackView.subviews.last as? SquareView
            else { return }
        
        for index in 0 ..< (squares.count - 1) {
            squares[index].backgroundColor = colorsNote[index]
        }
        
        if EditingNoteViewController.pickedColor.hexValue == self.colorsNote.first?.hexValue  {
            lastSquare.setGradientBackground()
            checkSquare(firstSquare.frame)
        } else {
            let squareSublayers = lastSquare.layer.sublayers
            if squareSublayers?.count != nil, squareSublayers!.count >= 2 {
                lastSquare.layer.sublayers!.removeFirst(2)
            }
            lastSquare.backgroundColor = EditingNoteViewController.pickedColor
            checkSquare(lastSquare.frame)
        }
    }
    
    private func checkSquare(_ touchedFrame: CGRect) {
        let squares = self.squareStackView.subviews
        for square in squares {
            if square.frame == touchedFrame {
                square.addSubview(check)
                self.checkedSquare = square
                self.colorIndex = squares.firstIndex(of: square)
                return
            }
        }
    }
    
    private func hideDatePicker() {
        UIView.animate(withDuration: 0.2,
                       animations: { self.pickerStackView.frame.size.height = 0 },
                       completion: {_ in  self.pickerStackView.isHidden = true })
    }
    
    private func showDatePicker() {
        UIView.animate(withDuration: 0.2,
                       animations: { self.pickerStackView.frame.size.height = 268 },
                       completion: { _ in self.pickerStackView.isHidden = false })
    }
    
    private func setupPickerLabels(with sender: UIDatePicker) {
        if !self.pickerStackView.isHidden {
            let now = Date()
            if sender.date < now {
                self.setDateButton.isEnabled = false
                self.dateLabel.text = "not selected"
                self.setDateButton.setTitle("Past Date", for: .disabled)
            } else {
                self.setDateButton.isEnabled = true
                self.setDateButton.setTitle("Done", for: .normal)
                self.destroyDate = sender.date
                self.dateLabel.text = sender.date.asString()
            }
        }
    }
    
    private func launchObserverKeyboard() {
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(keyboardWillShow),
                       name: UIResponder.keyboardWillShowNotification,
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(keyboardWillHide),
                       name: UIResponder.keyboardWillHideNotification,
                       object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let frameValue = notification.userInfo?[key] as? NSValue
            else { return }
        
        let frame = frameValue.cgRectValue
        self.scrollView.contentInset.bottom = frame.size.height
        self.scrollView.scrollIndicatorInsets.bottom = frame.size.height
        
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(hideKeyboard))
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    @objc func keyboardWillHide() {
        self.scrollView.contentInset.bottom = 0
        self.scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    @objc func hideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.backgroundColor!.hexValue == self.placeholderBackground.hexValue {
            UIView.animate(withDuration: 0.1,
                           animations: { textView.backgroundColor = UIColor(hex: "FA") },
                           completion: {_ in textView.textColor = .black})
        }
    }
    
    private func style() {

       self.titleLabel.setInfoStyle()
       self.contentLabel.setInfoStyle()
       self.destroyDateLabel.setInfoStyle()
       self.dateLabel.setDestroyDateStyle()
       self.setDateButton.setStyle()

    }

}

extension EditingNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.saveBarButtonItem.isEnabled = self.chekEmptyTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty { self.setupPlaceholder(textView) }
        self.saveBarButtonItem.isEnabled = self.chekEmptyTextView()
    }
    
}

protocol EditingNoteViewControllerDelegate: class {
    func editingDidCancel(_ controller: EditingNoteViewController)
    func editingDidSave(_ controller: EditingNoteViewController, didSave note: Note, isEdited: Bool)
}


// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Contract-driven conjugation view that replaces hardcoded language-specific conjugation views.
 *
 * Navigation:
 * - Type Selection: Shows conjugation types (e.g., "Pr. Simple", "Pr. Perfect")
 * - Form Selection: Shows individual forms (e.g., "I/you/plural: have looked")
 * - Auto-skips type selection when tense has only one type (e.g., German Präsens)
 */

import UIKit

/// The dynamic conjugation view controller for displaying verb conjugations based on contract data.
class DynamicConjugationViewController: UIViewController {

  // MARK: UI Components

  private var leftArrowButton: UIButton!
  private var rightArrowButton: UIButton!
  private var buttonContainerView: UIView!

  // MARK: Data

  private var conjugationData: [(String, [(String, [(String, String)])])]?
  private var currentTenseIndex: Int = 0
  private struct ConjugationType {
    let title: String
    let displayForm: String
    let forms: [(String, String)]
  }

  // MARK: Navigation State

  /// Two-level navigation: type selection → form selection.
  private enum ViewLevel {
    case typeSelection
    case formSelection
  }

  private var currentLevel: ViewLevel = .typeSelection
  private var selectedTypeTitle: String?
  private var selectedTypeForms: [(String, String)]?

  private let verb: String
  private let language: String
  private weak var commandBar: CommandBar?

  // MARK: Initialization

  init(verb: String, language: String, commandBar: CommandBar) {
    self.verb = verb
    self.language = language
    self.commandBar = commandBar
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override UIViewController Functions

  /// Includes setting up UI and loading conjugation data.
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = keyboardBgColor

    setupUI()
    loadConjugationData()
  }

  /// Includes waiting for layout completion before displaying buttons.
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if buttonContainerView.subviews.isEmpty {
      displayCurrentView()
    }
  }

  // MARK: Setup Functions

  /// Sets up arrow buttons and button container.
  private func setupUI() {
    buttonContainerView = UIView()
    buttonContainerView.backgroundColor = .clear
    buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(buttonContainerView)

    leftArrowButton = UIButton(type: .system)
    leftArrowButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    leftArrowButton.tintColor = keyCharColor
    leftArrowButton.backgroundColor = keyColor
    leftArrowButton.layer.cornerRadius = keyCornerRadius
    leftArrowButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
    leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
    leftArrowButton.alpha = 1.0
    view.addSubview(leftArrowButton)

    rightArrowButton = UIButton(type: .system)
    rightArrowButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    rightArrowButton.tintColor = keyCharColor
    rightArrowButton.backgroundColor = keyColor
    rightArrowButton.layer.cornerRadius = keyCornerRadius
    rightArrowButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
    rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
    rightArrowButton.alpha = 1.0
    view.addSubview(rightArrowButton)

    NSLayoutConstraint.activate([
      leftArrowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      leftArrowButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      leftArrowButton.widthAnchor.constraint(equalToConstant: 40),
      leftArrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),

      rightArrowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
      rightArrowButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      rightArrowButton.widthAnchor.constraint(equalToConstant: 40),
      rightArrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),

      buttonContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      buttonContainerView.leadingAnchor.constraint(equalTo: leftArrowButton.trailingAnchor, constant: 4),
      buttonContainerView.trailingAnchor.constraint(equalTo: rightArrowButton.leadingAnchor, constant: -4),
      buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
    ])
  }

  /// Loads conjugation data from contract system via ConjugationManager.
  private func loadConjugationData() {
    conjugationData = ConjugationManager.shared.getConjugations(
      verb: verb,
      language: language
    )
  }

  // MARK: Display Functions

  /// Routes to appropriate display function based on navigation level.
  private func displayCurrentView() {
    if currentLevel == .typeSelection {
      displayTypeSelection()
    } else {
      displayFormSelection()
    }
  }

  /// Displays conjugation types or auto-skips to forms if only one type exists.
  private func displayTypeSelection() {
    buttonContainerView.subviews.forEach { $0.removeFromSuperview() }

    guard let data = conjugationData,
          !data.isEmpty,
          currentTenseIndex < data.count else {
      commandBar?.text = commandPromptSpacing + "No conjugations found"
      return
    }

    let (tenseTitle, conjugationTypes) = data[currentTenseIndex]

    // Auto-skip to forms if only one type (e.g., German Präsens).
    if conjugationTypes.count == 1 {
      selectedTypeTitle = conjugationTypes[0].0
      selectedTypeForms = conjugationTypes[0].1
      currentLevel = .formSelection
      displayFormSelection()
      return
    }

    commandBar?.text = commandPromptSpacing + "\(tenseTitle): \(verb)"

    // Build type buttons with combined forms displayed.
    var typeButtons: [ConjugationType] = []
    for (typeTitle, forms) in conjugationTypes {
      let displayForms = forms.map { $0.1 }.joined(separator: "/")
      typeButtons.append(ConjugationType(title: typeTitle, displayForm: displayForms, forms: forms))
    }

    // Create button grid.
    createButtonGrid(
      items: typeButtons.map { ($0.title, $0.displayForm) },
      action: #selector(typeButtonTapped(_:))
    )

    updateArrowButtons()
  }

  /// Displays individual conjugated forms for the selected type.
  private func displayFormSelection() {
    buttonContainerView.subviews.forEach { $0.removeFromSuperview() }

    guard let forms = selectedTypeForms,
          let typeTitle = selectedTypeTitle else {
      return
    }

    commandBar?.text = commandPromptSpacing + "\(typeTitle): \(verb)"

    // Create button grid.
    createButtonGrid(
      items: forms,
      action: #selector(formButtonTapped(_:))
    )

    // Arrow behavior: left always enabled (back button), right depends on auto-skip.
    guard let data = conjugationData, currentTenseIndex < data.count else { return }
    let (_, conjugationTypes) = data[currentTenseIndex]

    // Left arrow: always enabled as back button
    leftArrowButton.isEnabled = true

    // Right arrow: enabled if auto-skipped, disabled if manually drilled
    if conjugationTypes.count == 1 {
      rightArrowButton.isEnabled = currentTenseIndex < data.count - 1
    } else {
      rightArrowButton.isEnabled = false
    }
  }

  /// Creates a grid of conjugation buttons.
  ///
  /// - Parameters
  ///   - items: array of (label, text) tuples for buttons.
  ///   - action: selector to call when button is tapped.
  private func createButtonGrid(items: [(String, String)], action: Selector) {
    let count = items.count
    let (rows, cols) = getGridLayout(forCount: count)

    let containerWidth = buttonContainerView.bounds.width
    let containerHeight = buttonContainerView.bounds.height
    let spacing: CGFloat = 4

    let buttonWidth = (containerWidth - CGFloat(cols + 1) * spacing) / CGFloat(cols)
    let buttonHeight = (containerHeight - CGFloat(rows + 1) * spacing) / CGFloat(rows)

    for (index, item) in items.enumerated() {
      let row = index / cols
      let col = index % cols

      let button = createStyledButton(
        frame: CGRect(
          x: CGFloat(col) * (buttonWidth + spacing) + spacing,
          y: CGFloat(row) * (buttonHeight + spacing) + spacing,
          width: buttonWidth,
          height: buttonHeight
        ),
        labelText: item.0,
        mainText: item.1,
        tag: index,
        action: action
      )

      buttonContainerView.addSubview(button)
    }
  }

  /// Creates a styled button with label and text.
  ///
  /// - Parameters
  ///   - frame: button frame.
  ///   - labelText: text for top-left label.
  ///   - mainText: text for button center.
  ///   - tag: button tag.
  ///   - action: selector to call when tapped.
  private func createStyledButton(
    frame: CGRect,
    labelText: String,
    mainText: String,
    tag: Int,
    action: Selector
  ) -> UIButton {
    let button = UIButton(type: .custom)
    button.frame = frame
    button.setTitleColor(keyCharColor, for: .normal)
    button.backgroundColor = keyColor
    button.titleLabel?.font = .systemFont(ofSize: 16)
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.minimumScaleFactor = 0.6
    button.titleLabel?.textAlignment = .center
    button.contentVerticalAlignment = .center
    button.layer.cornerRadius = keyCornerRadius
    button.layer.shadowColor = keyShadowColor
    button.layer.shadowOffset = CGSize(width: 0, height: 1)
    button.layer.shadowOpacity = 1.0
    button.layer.shadowRadius = 0
    button.tag = tag
    button.addTarget(self, action: action, for: .touchUpInside)

    let label = UILabel()
    label.text = "  " + labelText
    label.font = .systemFont(ofSize: 11)
    label.textColor = commandBarPlaceholderColor
    label.translatesAutoresizingMaskIntoConstraints = false
    button.addSubview(label)

    button.setTitle(mainText, for: .normal)

    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: button.topAnchor, constant: 2),
      label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 2)
    ])

    return button
  }

  // MARK: Button Actions

  /// Handles type button tap: insert if single form, drill down if multiple.
  ///
  /// - Parameters
  ///   - sender: the button that was tapped.
  @objc private func typeButtonTapped(_ sender: UIButton) {
    guard let data = conjugationData,
          !data.isEmpty,
          currentTenseIndex < data.count else { return }

    let (_, conjugationTypes) = data[currentTenseIndex]
    let selectedType = conjugationTypes[sender.tag]

    // Quick insert for single-form types.
    if selectedType.1.count == 1 {
      let form = selectedType.1[0].1
      if form != invalidCommandMsg {
        proxy.insertText(form + " ")
        closeTapped()
      }
      return
    }

    // Drill down for multi-form types.
    selectedTypeTitle = selectedType.0
    selectedTypeForms = selectedType.1
    currentLevel = .formSelection
    displayFormSelection()
  }

  /// Handles form button tap: insert the conjugated form and close.
  ///
  /// - Parameters
  ///   - sender: the button that was tapped.
  @objc private func formButtonTapped(_ sender: UIButton) {
    guard let forms = selectedTypeForms else { return }

    let selectedForm = forms[sender.tag].1

    if selectedForm != invalidCommandMsg {
      proxy.insertText(selectedForm + " ")
      closeTapped()
    }
  }

  /// Closes the conjugation view and returns to normal keyboard.
  @objc private func closeTapped() {
    commandState = .idle
    autoActionState = .suggest

    let kvc = parent as? KeyboardViewController

    removeFromParent()
    view.removeFromSuperview()

    kvc?.loadKeys()
    kvc?.conditionallySetAutoActionBtns()
  }

  // MARK: Navigation Functions

  /// Handles left arrow: navigate to previous tense or back to type selection.
  @objc private func leftArrowTapped() {
    if currentLevel == .typeSelection {
      currentTenseIndex = max(0, currentTenseIndex - 1)
      displayTypeSelection()
    } else {
      guard let data = conjugationData, currentTenseIndex < data.count else { return }
      let (_, conjugationTypes) = data[currentTenseIndex]

      if conjugationTypes.count == 1 {
        // Auto-skipped: navigate tenses.
        currentTenseIndex = max(0, currentTenseIndex - 1)
        displayTypeSelection()
      } else {
        // Manually drilled: back to type selection.
        currentLevel = .typeSelection
        selectedTypeTitle = nil
        selectedTypeForms = nil
        displayTypeSelection()
      }
    }
  }

  /// Handles right arrow: navigate to next tense.
  @objc private func rightArrowTapped() {
    guard let data = conjugationData else { return }

    if currentLevel == .typeSelection {
      currentTenseIndex = min(data.count - 1, currentTenseIndex + 1)
      displayTypeSelection()
    } else {
      let (_, conjugationTypes) = data[currentTenseIndex]

      if conjugationTypes.count == 1 {
        // Auto-skipped: navigate tenses.
        currentTenseIndex = min(data.count - 1, currentTenseIndex + 1)
        displayTypeSelection()
      }
    }
  }

  /// Updates arrow button states based on current tense position.
  private func updateArrowButtons() {
    guard let data = conjugationData else { return }

    leftArrowButton.isEnabled = currentTenseIndex > 0

    rightArrowButton.isEnabled = currentTenseIndex < data.count - 1
  }

  // MARK: Utility Functions

  /// Returns optimal grid layout (rows, cols) for given button count.
  ///
  /// - Parameters
  ///   - count: number of buttons to display.
  private func getGridLayout(forCount count: Int) -> (rows: Int, cols: Int) {
    switch count {
    case 1: return (1, 1)
    case 2: return (1, 2)
    case 3: return (3, 1)
    case 4: return (2, 2)
    case 6: return (3, 2)
    case 8: return (4, 2)
    default: return (3, 2)
    }
  }
}

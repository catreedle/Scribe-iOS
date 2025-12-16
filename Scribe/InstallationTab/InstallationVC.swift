// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * The ViewController for the Installation screen of the Scribe app.
 */

import UIKit
import SwiftUI

/// A UIViewController that provides instructions on how to install Keyboards as well as information about Scribe.
class InstallationVC: UIViewController {
  // Variables linked to elements in AppScreen.storyboard.
  @IBOutlet var appTextViewPhone: UITextView!
  @IBOutlet var appTextViewPad: UITextView!
  var appTextView: UITextView!

  @IBOutlet var appTextBackgroundPhone: UIView!
  @IBOutlet var appTextBackgroundPad: UIView!
  var appTextBackground: UIView!

  @IBOutlet var topIconPhone: UIImageView!
  @IBOutlet var topIconPad: UIImageView!
  var topIcon: UIImageView!

  @IBOutlet var settingsBtnPhone: UIButton!
  @IBOutlet var settingsBtnPad: UIButton!
  var settingsBtn: UIButton!

  @IBOutlet var settingsCornerPhone: UIImageView!
  @IBOutlet var settingsCornerPad: UIImageView!
  var settingsCorner: UIImageView!

  @IBOutlet var settingCornerWidthConstraintPhone: NSLayoutConstraint!
  @IBOutlet var settingCornerWidthConstraintPad: NSLayoutConstraint!
  var settingCornerWidthConstraint: NSLayoutConstraint!

  // Spacing views to size app screen proportionally.
  @IBOutlet var topSpace: UIView!
  @IBOutlet var logoSpace: UIView!

  @IBOutlet var installationHeaderLabel: UILabel!

  // Table view for language data section
  private var languageDataTableView: UITableView!
  private var languageDataLabel: UILabel!
  private let dataSet = InstallationTableData.installationTableData

  private let installationTipCardState: Bool = {
    let userDefault = UserDefaults.standard
    let state = userDefault.object(forKey: "installationTipCardState") as? Bool ?? true
    return state
  }()

  func setAppTextView() {
    if DeviceType.isPad {
      appTextView = appTextViewPad
      appTextBackground = appTextBackgroundPad
      topIcon = topIconPad
      settingsBtn = settingsBtnPad
      settingsCorner = settingsCornerPad
      settingCornerWidthConstraint = settingCornerWidthConstraintPad

      appTextViewPhone.removeFromSuperview()
      appTextBackgroundPhone.removeFromSuperview()
      topIconPhone.removeFromSuperview()
      settingsBtnPhone.removeFromSuperview()
      settingsCornerPhone.removeFromSuperview()
    } else {
      appTextView = appTextViewPhone
      appTextBackground = appTextBackgroundPhone
      topIcon = topIconPhone
      settingsBtn = settingsBtnPhone
      settingsCorner = settingsCornerPhone
      settingCornerWidthConstraint = settingCornerWidthConstraintPhone

      appTextViewPad.removeFromSuperview()
      appTextBackgroundPad.removeFromSuperview()
      topIconPad.removeFromSuperview()
      settingsBtnPad.removeFromSuperview()
      settingsCornerPad.removeFromSuperview()
    }
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func viewDidLoad() {
    super.viewDidLoad()

    self.tabBarController?.viewControllers?[0].title = NSLocalizedString(
      "app.installation.title", value: "Installation", comment: ""
    )
    self.tabBarController?.viewControllers?[1].title = NSLocalizedString(
      "app.settings.title", value: "Settings", comment: ""
    )
    self.tabBarController?.viewControllers?[2].title = NSLocalizedString(
      "app.about.title", value: "About", comment: ""
    )

    setCurrentUI()
    showTipCardView()
    setupLanguageDataSection()
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    setCurrentUI()
  }

  // Lock the device into portrait mode to avoid resizing issues.
  var orientations = UIInterfaceOrientationMask.portrait
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    get { return orientations }
    set { orientations = newValue }
  }

/// Sets up the "Language data" section with table view
func setupLanguageDataSection() {
  guard appTextBackground != nil, dataSet.count > 0 else { return }

  if languageDataTableView != nil { return }

  // Add "Language data" label
  languageDataLabel = UILabel()
  languageDataLabel.translatesAutoresizingMaskIntoConstraints = false
  languageDataLabel.text = dataSet[0].headingTitle
  languageDataLabel.font = UIFont.boldSystemFont(ofSize: fontSize * 1.1)
  languageDataLabel.textColor = keyCharColor

  // Insert AT POSITION 0
  view.insertSubview(languageDataLabel, at: 0)

  // Add table view
  languageDataTableView = UITableView(frame: .zero, style: .plain)
  languageDataTableView.translatesAutoresizingMaskIntoConstraints = false
  languageDataTableView.backgroundColor = .clear
  languageDataTableView.separatorStyle = .none
  languageDataTableView.isScrollEnabled = false
  languageDataTableView.delegate = self
  languageDataTableView.dataSource = self

  languageDataTableView.register(
    UINib(nibName: "InfoChildTableViewCell", bundle: nil),
    forCellReuseIdentifier: InfoChildTableViewCell.reuseIdentifier
  )

  // Insert AT POSITION 0
  view.insertSubview(languageDataTableView, at: 0)

  // Layout constraints
  NSLayoutConstraint.activate([
    // Language data label
    languageDataLabel.topAnchor.constraint(equalTo: appTextBackground.bottomAnchor, constant: 30),
    languageDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
    languageDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),

    // Table view
    languageDataTableView.topAnchor.constraint(equalTo: languageDataLabel.bottomAnchor, constant: 10),
    languageDataTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
    languageDataTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
    languageDataTableView.heightAnchor.constraint(equalToConstant: 100)
  ])
}

  /// Sets the top icon for the app screen given the device to assure that it's oriented correctly to its background.
  func setTopIcon() {
    if DeviceType.isPad {
      topIconPhone.isHidden = true
      topIconPad.isHidden = false
      for constraint in settingsCorner.constraints where constraint.identifier == "settingsCorner" {
          constraint.constant = 125
      }
    } else {
      topIconPhone.isHidden = false
      topIconPad.isHidden = true
      for constraint in settingsCorner.constraints where constraint.identifier == "settingsCorner" {
          constraint.constant = 70
      }
    }
  }

  /// Sets the functionality of the button over the keyboard installation guide that opens Settings.
  func setSettingsBtn() {
    settingsBtn.addTarget(self, action: #selector(openSettingsApp), for: .touchUpInside)
    settingsBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

  /// Sets constant properties for the app screen.
  func setUIConstantProperties() {
    // Set the scroll bar so that it appears on a white background regardless of light or dark mode.
    let scrollbarAppearance = UINavigationBarAppearance()
    scrollbarAppearance.configureWithOpaqueBackground()

    // Disable spacing views.
    let allSpacingViews: [UIView] = [topSpace, logoSpace]
    for view in allSpacingViews {
      view.isUserInteractionEnabled = false
      view.backgroundColor = .clear
    }
  }

  /// Sets properties for the app screen given the current device.
  func setUIDeviceProperties() {
    // Flips coloured corner with settings icon based on orientation of text.
    settingsCorner.image = settingsCorner.image?.imageFlippedForRightToLeftLayoutDirection()
    if UIView.userInterfaceLayoutDirection(for: appTextView.semanticContentAttribute) == .rightToLeft {
      settingsCorner.layer.maskedCorners = .layerMinXMinYCorner // "top-left"
    } else {
      settingsCorner.layer.maskedCorners = .layerMaxXMinYCorner // "top-right"
    }
    settingsCorner.layer.cornerRadius = DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05

    settingsBtn.setTitle("", for: .normal)
    settingsBtn.clipsToBounds = true
    settingsBtn.layer.masksToBounds = false
    settingsBtn.layer.cornerRadius = DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05

    let allTextViews: [UITextView] = [appTextView]

    // Disable text views.
    for textView in allTextViews {
      textView.isUserInteractionEnabled = false
      textView.backgroundColor = .clear
      textView.isEditable = false
    }

    // Set backgrounds and corner radii.
    appTextBackground.isUserInteractionEnabled = true
    appTextBackground.clipsToBounds = true
    applyCornerRadius(
      elem: appTextBackground,
      radius: DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05
    )

    // Set link attributes for all textViews.
    for textView in allTextViews {
      textView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: linkBlueColor,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    }
  }

  /// Sets the necessary properties for the installation UI including calling text generation functions.
  func setInstallationUI() {
    let settingsSymbol: UIImage = getSettingsSymbol(fontSize: fontSize * 0.9)
    topIconPhone.image = settingsSymbol
    topIconPad.image = settingsSymbol
    topIconPhone.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? scribeCTAColor : keyCharColor
    topIconPad.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? scribeCTAColor : keyCharColor

    // Enable installation directions and GitHub notice elements.
    settingsBtn.isUserInteractionEnabled = true
    appTextBackground.backgroundColor = lightWhiteDarkBlackColor

    // Set the texts for the fields.
    appTextView.attributedText = setInstallation(fontSize: fontSize)
    appTextView.textColor = keyCharColor
  }

  /// Creates the current app UI by applying constraints and calling child UI functions.
  func setCurrentUI() {
    // Sets the font size for the text in the app screen and corresponding UIImage icons.
    if DeviceType.isPhone {
      if UIScreen.main.bounds.width > 413 || UIScreen.main.bounds.width <= 375 {
        fontSize = UIScreen.main.bounds.height / 59
      } else if UIScreen.main.bounds.width <= 413 && UIScreen.main.bounds.width > 375 {
        fontSize = UIScreen.main.bounds.height / 50
      }

    } else if DeviceType.isPad {
      fontSize = UIScreen.main.bounds.height / 50
    }

    installationHeaderLabel.text = NSLocalizedString(
      "app.installation.keyboard.title", value: "Keyboard installation", comment: ""
    )
    installationHeaderLabel.font = UIFont.boldSystemFont(ofSize: fontSize * 1.1)

    setAppTextView()
    setTopIcon()
    setSettingsBtn()
    setUIConstantProperties()
    setUIDeviceProperties()
    setInstallationUI()
  }

  /// Function to open the settings app that is targeted by settingsBtn.
  @objc func openSettingsApp() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
      fatalError("Failed to create settings URL.")
    }
    UIApplication.shared.open(settingsURL)
  }

  /// Function to change the key coloration given a touch down.
  ///
  /// - Parameters
  ///  - sender: the button that has been pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
    sender.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
    sender.alpha = 0.2
    topIcon.alpha = 0.2

    // Bring sender's opacity back up to fully opaque and replace the background color.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
      sender.backgroundColor = .clear
      sender.alpha = 1.0
      self?.topIcon.alpha = 1.0
    }
  }
}

// MARK: UITableViewDataSource

extension InstallationVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSet.count > 0 ? dataSet[0].section.count : 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: InfoChildTableViewCell.reuseIdentifier,
      for: indexPath
    ) as? InfoChildTableViewCell else {
      fatalError("Failed to dequeue InfoChildTableViewCell.")
    }

    cell.configureCell(for: dataSet[0].section[indexPath.row])
    cell.backgroundColor = lightWhiteDarkBlackColor

    // Add corner radius to both cell and contentView
    cell.contentView.layer.cornerRadius = 12
    cell.contentView.layer.masksToBounds = true
    cell.layer.cornerRadius = 12
    cell.layer.masksToBounds = true

    return cell
  }
}

// MARK: UITableViewDelegate

extension InstallationVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = dataSet[indexPath.section].section[indexPath.row]

    switch section.sectionState {
    case .downloadData:
        let viewController = DownloadDataViewController()
        viewController.configureTable(for: DownloadDataTable.downloadDataTable)
        navigationController?.pushViewController(viewController, animated: true)

    default:
      break
    }

    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: TipHintView

extension InstallationVC {
  private func showTipCardView() {
    let overlayView = InstallationTipCardView(
      installationTipCardState: installationTipCardState
    )

    let hostingController = UIHostingController(rootView: overlayView)
    hostingController.view.backgroundColor = .clear

    if !UIDevice.hasNotch {
      startGlowingEffect(on: hostingController.view)
      addChild(hostingController)
      view.addSubview(hostingController.view)
      hostingController.view.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        hostingController.view.heightAnchor.constraint(equalToConstant: 178)
      ])

    } else {
      // DEVICE WITH NOTCH
      startGlowingEffect(on: hostingController.view)
      addChild(hostingController)
      view.addSubview(hostingController.view)
      hostingController.view.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        hostingController.view.heightAnchor.constraint(equalToConstant: 178)
      ])
    }
    hostingController.didMove(toParent: self)
  }

  func startGlowingEffect(on view: UIView, duration: TimeInterval = 1.0) {
    view.layer.shadowColor = UIColor.scribeCTA.cgColor
    view.layer.shadowRadius = 8
    view.layer.shadowOpacity = 0.0
    view.layer.shadowOffset = CGSize(width: 0, height: 0)

    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: [.curveEaseOut, .autoreverse],
      animations: {
        view.layer.shadowOpacity = 0.6
      }, completion: nil
    )
  }
}

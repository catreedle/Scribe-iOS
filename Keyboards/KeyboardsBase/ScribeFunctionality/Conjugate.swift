// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Functions and elements that control the conjugation command.
 */

import UIKit

/// Returns a declension once a user presses a key in the conjugateView.
///
/// - Parameters
///   - keyPressed: the button pressed as sender.
///   - requestedForm: the form that is triggered by the given key.
func returnDeclension(keyPressed: UIButton) {
  let wordPressed = keyPressed.titleLabel?.text ?? ""

  var keyName = ""
  if let originalKeyValue = keyPressed.layer.value(forKey: "original") as? String {
    keyName = originalKeyValue
  }

  if !(wordPressed.contains("/") || wordPressed.contains("∗")) {
    proxy.insertText(wordPressed + getOptionalSpace())
    deCaseVariantDeclensionState = .disabled
    autoActionState = .suggest
    commandState = .idle
  } else if controllerLanguage == "Russian" { // pronoun selection paths not implemented for Russian
    proxy.insertText(wordPressed + getOptionalSpace())
    deCaseVariantDeclensionState = .disabled
    autoActionState = .suggest
    commandState = .idle
  } else {
    // Change to a new form selection display.
    if deCaseVariantDeclensionState == .disabled {
      if deCaseDeclensionState == .accusativePersonal {
        if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .accusativePersonalSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .accusativePersonalTPS
        }
      } else if deCaseDeclensionState == .dativePersonal {
        if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .dativePersonalSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .dativePersonalTPS
        }
      } else if deCaseDeclensionState == .genitivePersonal {
        if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .genitivePersonalSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .genitivePersonalTPS
        }
      } else if deCaseDeclensionState == .accusativePossessive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossessiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossessiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossessiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossessiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossessiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossessiveTPP
        }
      } else if deCaseDeclensionState == .dativePossessive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .dativePossessiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .dativePossessiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .dativePossessiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .dativePossessiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .dativePossessiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .dativePossessiveTPP
        }
      } else if deCaseDeclensionState == .genitivePossessive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossessiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossessiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossessiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossessiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossessiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossessiveTPP
        }
      }
    } else {
      if deCaseVariantDeclensionState == .accusativePossessiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .accusativePossessiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .accusativePossessiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .accusativePossessiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .accusativePossessiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .accusativePossessiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .accusativePossessiveTPSNeutral
        }
      } else if deCaseVariantDeclensionState == .dativePossessiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .dativePossessiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .dativePossessiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .dativePossessiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .dativePossessiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .dativePossessiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .dativePossessiveTPSNeutral
        }
      } else if deCaseVariantDeclensionState == .genitivePossessiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .genitivePossessiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .genitivePossessiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .genitivePossessiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .genitivePossessiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .genitivePossessiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .genitivePossessiveTPSNeutral
        }
      }
    }
    commandState = .selectCaseDeclension
  }
}

/// Triggers the display of the conjugation view for a valid verb in the command bar.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func triggerVerbConjugation(commandBar: UILabel) -> Bool {
  // Cancel via a return press.
  if let commandBarText = commandBar.text,
     commandBarText == conjugatePromptAndCursor || commandBarText == conjugatePromptAndCursor {
    return false
  }

  if let commandBarText = commandBar.text {
    let startIndex = commandBarText.index(commandBarText.startIndex, offsetBy: conjugatePrompt.count)
    let endIndex = commandBarText.index(commandBarText.endIndex, offsetBy: -1)
    verbToConjugate = String(commandBarText[startIndex ..< endIndex])
  }

  return isVerbInConjugationTable(queriedVerbToConjugate: verbToConjugate)
}

func isVerbInConjugationTable(queriedVerbToConjugate: String) -> Bool {
  verbToConjugate = String(queriedVerbToConjugate.trailingSpacesTrimmed)

  let firstLetter = verbToConjugate.substring(toIdx: 1)
  inputWordIsCapitalized = firstLetter.isUppercase
  verbToConjugate = verbToConjugate.lowercased()

  // Try to query any conjugation form to verify verb exists
  let columnName = (controllerLanguage == "Swedish") ? "verb" : "infinitive"
  let results = LanguageDBManager.shared.queryVerb(of: verbToConjugate, with: [columnName])

  return !results.isEmpty && !results[0].isEmpty
}

/// Returns the conjugation state to its initial conjugation based on the keyboard language.
func resetCaseDeclensionState() {
  // The case conjugation display starts on the left most case.
  if controllerLanguage == "German" {
    if prepAnnotationForm.contains("Acc") {
      conjViewShiftButtonsState = .leftInactive
      deCaseDeclensionState = .accusativeDefinite
    } else if prepAnnotationForm.contains("Dat") {
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativeDefinite
    } else {
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitiveDefinite
    }
  } else if controllerLanguage == "Russian" {
    if prepAnnotationForm.contains("Acc") {
      conjViewShiftButtonsState = .leftInactive
      ruCaseDeclensionState = .accusative
    } else if prepAnnotationForm.contains("Dat") {
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .dative
    } else if prepAnnotationForm.contains("Gen") {
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .genitive
    } else if prepAnnotationForm.contains("Pre") {
      conjViewShiftButtonsState = .rightInactive
      ruCaseDeclensionState = .prepositional
    } else {
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .instrumental
    }
  }
}

/// Runs an action associated with the left view switch button of the conjugation state based on the keyboard language.
func conjugationStateLeft() {
  if controllerLanguage == "German" {
    deConjugationStateLeft()
  } else if controllerLanguage == "Russian" {
    ruConjugationStateLeft()
  }
}

/// Runs an action associated with the right view switch button of the conjugation state based on the keyboard language.
func conjugationStateRight() {
  if controllerLanguage == "German" {
    deConjugationStateRight()
  } else if controllerLanguage == "Russian" {
    ruConjugationStateRight()
  }
}

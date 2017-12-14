# FormKit

[![Version](https://img.shields.io/cocoapods/v/FormKit.svg?style=flat)](http://cocoapods.org/pods/FormKit)
[![License](https://img.shields.io/cocoapods/l/FormKit.svg?style=flat)](http://cocoapods.org/pods/FormKit)
[![Platform](https://img.shields.io/cocoapods/p/FormKit.svg?style=flat)](http://cocoapods.org/pods/FormKit)

## Installation

FormKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FormKit'
```

## Author

Cyrille Legrand, c.legrand@useradgents.com

## License

FormKit is available under the GPLv3 license. See the LICENSE file for more info.

## Description

FormKit is my attempt at a pure-Swift library to handling forms. After ten years of developing on iOS, I still haven't found a universal way of setting up and handling forms, so here's my current universal-ish solution.

### Basic assumptions

- The form is handled by a `FKController` which becomes the datasource and delegate of the table view you set it up on.
- You first setup the form by adding sections and rows for each form field you will need to edit, then you tell the controller to edit an instance of a struct or an object (the latter must conform to `NSCopying`, as a copy of the object will be edited so that you can compute differences).
- Cells are all visible by default, but can be hidden at first, then rendered visible based on your external logic. Cells and even whole sections can even be inserted or removed at any time.
- Versatile default cells are provided for most kind of inputs, but you can always provide your own cells, which must have some requirements depending on what kind of field they will edit.
- The controller will trigger events upon :
  - entering an interactive field (usually text fields or lists)
  - typing characters in an interactive field
  - setting the value of a non-interactive field
  - leaving a field
- There's support for displaying errors, and choosing when to display or hide them, but the task of performing the actual error detection/handling is your duty.
- All interactive fields are linked to each other, and their keyboard (or other input view) have a toolbar attached, like in Safari, with "Previous / Next / Done" buttons. Navigating between those fields is automatically handled by the controller, and you don't have to link the fields manually.

On some more personal notes:

- I try to avoid `UIPickerView` like the plague. Seriously, picker view UX is awful, it's really hard to pick the right date on the first time with a minimum number of taps. I prefer to present lists as full-fledged table views. Even date pickers will be replaced by full-fledged calendars in next versions.

### Supported field types

Fields that are *interactive* have a keyboard or some other input method, can "have the focus" (become the first responder) and trigger continuous callbacks when editing. Typically, text and numeric fields and pickers (list / date) are interactive. Switches, segmented controls, steppers are not interactive.

| Name | Description | Interactive | Handles optionals | Appearance |
|------|-------------|------------|----------------|-------|
| `FKTextField` | A standard text field for handling names, e-mails, addresses, … | Yes | Yes | A `UITextField` with optional placeholder and "delete" button |
| `FKPasswordField` | A secure-input text field for handling passwords | Yes | Yes | A secure `UITextField` with optional placeholder and "delete" button, and an optional "eye" button to reveal the password in plain text |
| `FKNumberField` | A numeric text field that handles integer, fixed-point float, or floating-point float numbers | Yes | Yes | A `UITextField` with optional placeholder and "delete" button, and a numeric or decimal keyboard |
| `FKStepperField` | A numeric label with `+`/`–` buttons | No | Yes | A `UILabel` with two `+`/`–` `UIButton`s and an optional "delete" button |
| `FKSwitchField` | A switch for handling on/off states | No | No | A `UISwitch` |
| `FKSegmentField` | A segmented control for selecting values in a small list of items | No | Yes | A non-momentary `UISegmentedControl`. Nil values have either their own segment (start or end), or map to no selected segment. |
| `FKListField` | A field for selecting one or many values in a large list of items | Yes | Yes | Presents a table with all items (no, it's not a `UIPickerView`, and it never will) |
| `FKDateField` | A field to input dates and/or times | Yes | Yes | A `UITextField` with a `UIDatePicker` as its input view |
| `FKDurationField` | A field to define a duration | Yes | Yes | A `UITextField` with a `UIDatePicker` as its input view |
| `FKImageField` | An image picker | Yes | Yes | |
| `FKColorField` | A color picker | Yes | Yes | |

### Delegate messages

The `FKController` passes back events to its delegate, a `FKControllerDelegate`, which would usually be the view controller owning the table view.




## Examples

### Static form

With default FKFormRow cells

```swift

// Model objects

enum Gender {
	case .male
	case .female
	case .other
}

struct Person {
	var firstName: String
	var lastName: String
	var nickname: String?
	var dateOfBirth: Date?
	var gender: Gender?
}

// This enum will hold the tags to each section/row of the form
// It's more convenient than storing references to each of them

enum Tags: Int {
	case secName
	case rowFirstName
	case rowLastName
	case rowNickname
	case secOther
	case rowDateOfBirth
	case rowGender
}

// Usually call setupForm() in viewDidLoad()

func setupForm() {
    // Create the form controller and hook to the table view
    // The controller will then become the table view's delegate and data source
    var form = FKFormController<Person>(tableView: self.tableView)
    
    // Prepare the form: create its structure
    form.prepare { f in
        f.addSection(Tags.secName) { s in
            s.title = "Name"
            s.addRow(Tags.rowFirstName) { r in
                r.title = "First name"
                r.input = FKTextField(keyPath: \.firstName)
            }
            s.addRow(Tags.rowLastName) { r in
                r.title = "Last name"
                r.input = FKTextField(keyPath: \.lastName)
            }
            s.addRow(Tags.rowNickame) { r in
                r.title = "Nickname"
                r.input = FKTextField(keyPath: \.nickname)
            }
        }
        
        f.addSection(Tags.secOther) { s in
            s.title = "Other"
            s.addRow(Tags.rowDateOfBirth) { r in
                r.title = "Date of birth"
                // Date field with default to today when editing
                // a nil date
                r.input = FKDateField(keyPath: \.dateOfBirth, min: nil, max: Date())
            }
            s.addRow(Tags.rowGender) { r in
                r.title = "Gender"
                // List field requires the type to be at least FKListable, see below
                r.input = FKListField(keyPath: \.gender, oneOf: Gender.self, pushedOn: navigationController)
            }
        }
    }
}

extension Gender: FKListable {
	static var allNames: [String] = ["Male", "Female", "Other"]
	static var allValues: [Gender] = [.male, .female, .other]
	static var nilMode: .noSelection // or .firstSegment or .lastSegment
}

```


### Signup form


### Dynamic form 

A la mustela


### Address form

With ZIP code lookup


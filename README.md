# custom_input_field

Build one reusable Flutter input widget for email, password, username, and phone, without repeating `TextFormField` setup on every screen.

This project demonstrates how to keep field configuration flexible per screen while sharing one consistent input UI and interaction pattern.

## What this project includes

- Reusable input widget for multiple field types
- Custom validation and clear error messages
- Shake animations when validation fails
- Password visibility toggle behavior
- Controller-based field handling
- Field-specific keyboard and autofill settings
- Form submit and reset flows

## How it works

- Each screen provides:
  - Field values/controllers
  - Validation rules
  - Labels/placeholders and field options
- The shared input widget handles:
  - Rendering and styling
  - Validation feedback presentation
  - Animation and interaction states

## Why use this pattern

- Reduces repeated form code
- Keeps behavior consistent across screens
- Makes form fields easier to maintain and extend

## Run the project

```bash
flutter pub get
flutter run
```

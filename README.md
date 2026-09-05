# Splitz
I made this app for me and my wife. It's an interface that help us keeping track on how we're spending money.
It uses [Splitwise](https://www.splitwise.com) as a backend for tracking expenses, so we can check our expenses in their app too.
So this app is basically a customizable experience for the Splitwise services, which aims to make the task of tracking expenses in a standardized way simpler and faster.
To do that, we save some information in [Firebase Realtime Database](https://firebase.google.com/docs/database).
I pretend to clarify what, how and why I have to save this information later, but only if I decide to open this app to general usage, since I made it firstly (and only) with the best experience for me and my wife in mind.

## Next steps:
- [-] Add the concept of "owner" to Splitz Config (permission to edit)
- [ ] GSheets setup flow
- [ ] Expenses List - Search and Filters:
  - [ ] By Category
  - [ ] By Date:
    - [ ] before/after some date
    - [ ] specific month
    - [ ] specific interval

## Security:

## Features
### Must
- [ ] Onboarding flow (tutorial)
  - [ ] How to configure a GSheet to export correctly
  - [ ] Which data is stored where (Splitwise vs Splitz databases)
- [ ] "Load more" button on Expenses List Screen
### Goods
- [ ] Auto order category based on usage
- [ ] Expenses suggestions (notifications)
- [ ] Edit a group of selected expenses (limited options on edition)
  - [ ] Category, date, Split config (division)
- [ ] Add other options to Splitz Login
  - [ ] Email/Password, Facebook, etc...

## Design + UX
- [ ] I18n + BR L10n
- [ ] Improve Splitz Login
  - [ ] Make a decent screen
  - [ ] Use a custom buttom to login with Google option
- [ ] Improve Splitwise Login
  - [ ] Make a decent start screen
  - [ ] Add explanations about the data usage, how the login with splitwise works, etc
- [ ] Improve Splash Screen
- [ ] Add animations

## Done
- [x] Migration to Web
- [x] Show expenses from the current month + last 2 months by default
- [x] Expenses List - Show who paid each expense
- [x] Expenses Export - Integration with GSheets - select export sheet
- [x] Expenses List - Option to add payment
- [x] Category Editor - Delete/Edit/Reorder Category
- [x] Expenses Export - Show total of the selected month
- [x] Expense Editor - Undo delete/edit
- [x] Show group balance
- [x] Expense Editor - Edit date
- [x] Export data from the bills of the month
- [x] Add logo to SplitzAppBar
- [x] Improve drawer layout (turns it into a MenuAnchor for now)
- [x] Review on model classes
  - [x] remove unused code
  - [x] create entities
- [x] Indicator to how much is left until 100% when editing percentages manually
- [x] Indicator to selected group
- [x] Smart loading of data for expenses list screen
- [x] Handle physical back button
- [x] Turn GroupConfig -> splitConfig into a map
- [x] Logout
- [x] Expense Editor - Current user pre selected as payer
- [x] Handling errors
- [x] Refactor data access strategy
- [x] Add Category
- [x] Group Config
- [x] Remove lint ignores from the code
- [x] Splitz Service (application layer)
- [x] Splitz Repository (data access)
- [x] Splitwise Repository
- [x] Add splash (check isSignedIn and redirect to the correct screen)
- [x] Custom animation for wait time on edit splitz config on group editor
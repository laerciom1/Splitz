# Splitz
I made this app for my wife and I. It's basically an interface that helps us keep track of our spending.
It uses splitwise as a backend for tracking expenses, so you can check your expenses in their app, as well as use the features that splitwise offers in conjunction with splitz.
This app is a customizable experience for the splitwise services, which aims to make the task of tracking expenses in a standardized way simpler and faster.
I made it with the best experience for me in mind, I'll add some gifs here in the future (:

### Next steps:
- [ ] Export data from the bills of the month
- [ ] Expense Editor - Undo delete/edit
- [ ] Category Editor - Delete/Edit/Reorder Category

### Refactors

### Features
- [ ] Filters:
  - [ ] Category
  - [ ] Date:
    - [ ] before/after some date
    - [ ] specific month
    - [ ] specific interval
- [ ] Edit a group of expenses (limited edition)
  - [ ] Edit the category of selected expenses
  - [ ] Edit split config of selected expenses
- [ ] Load more on Splits list
- [ ] Add other options to Splitz Login
- [ ] Permission to edit group preferences

### Design
- [ ] Improve Splitz Login
  - [ ] Make a decent screen
  - [ ] Use a custom buttom to login with Google option
- [ ] Improve Splitwise Login
  - [ ] Make a decent start screen
  - [ ] Add explanations about the data usage, how the login with splitwise works, etc
- [ ] Improve Splash Screen
- [ ] Add animations

### Done
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

### Mandatory to go live (in the long term future, maybe?)
- [ ] Onboarding flow (tutorial)
- [ ] Encrypt data on Firebase
# Expense Tracker App – CyphLab Internship Task

A clean and user-friendly Expense Tracker mobile application built using Flutter and Firebase. This project was developed as part of the CyphLab Flutter Developer Internship practical task.

The application helps users record, organize, and monitor their personal expenses. Users can manage expenses, view their monthly spending, filter their expense history, and analyze their spending using simple visual summaries.

---

## Features

### Core Features

* Add new expenses
* Edit existing expenses
* Delete expenses
* Select expense categories
* Select expense dates
* Add optional notes/descriptions
* Store expense data using Firebase Cloud Firestore
* Display total expenses for the current/selected month
* View expense history
* Filter expenses by category
* Filter expenses by date
* Search expenses
* Form validation
* Loading states
* Empty states
* Error handling

### Additional Features

* Firebase Authentication
* Monthly budget tracking
* Budget progress indicator
* Category-wise expense breakdown
* Expense chart
* Dark mode
* Search functionality
* Responsive UI
* Custom app icon and splash screen

---

## Technologies Used

* **Flutter**
* **Dart**
* **Firebase Core**
* **Firebase Authentication**
* **Cloud Firestore**
* **Riverpod**
* **fl_chart**
* **intl**

### Architecture

The application follows a **feature-first architecture** to keep the project organized, maintainable, and easier to extend.

The project separates UI components, models, providers/state management, and Firebase-related services instead of placing the complete application logic inside individual screens.

---

# AI Tools Used

AI tools were used as development assistants during the project.

The main AI tool used during development was **Google Gemini through the Continue extension in VS Code**.

AI was mainly used for:

* Understanding and planning the application
* Getting suggestions for project architecture
* Understanding Flutter and Firebase implementation approaches
* Troubleshooting development issues
* Checking possible solutions for errors
* Getting guidance for UI components
* Improving specific parts of the application
* Understanding unfamiliar Flutter/Dart concepts

The application was developed incrementally rather than asking an AI tool to generate the entire project in a single prompt. I reviewed, tested, modified, and integrated the suggestions into the project during development.

---

# AI-Assisted Development Prompts

The following are examples of the prompts used during the development process.

## 1. Understanding the Application Idea

> I am building a Flutter Expense Tracker application for a practical assessment. Help me clearly define the core purpose of the application, the problem it solves, and the target users. Do not write code. Focus only on helping me understand the application requirements.

---

## 2. Defining Requirements

> Based on the Expense Tracker idea, help me identify the essential functional requirements and useful optional features. Separate the requirements into core features and additional features. Explain the purpose of each feature without writing implementation code.

---

## 3. Planning the User Flow

> Help me plan the user flow for a simple Flutter Expense Tracker. Describe how a user should move through the application when adding, editing, deleting, viewing, searching, and filtering expenses. Keep the flow simple and suitable for a mobile application.

---

## 4. Flutter Project Architecture

> I am building an Expense Tracker using Flutter, Firebase, and Riverpod. Suggest a clean project architecture that would be suitable for a small but maintainable application. Explain how screens, models, providers, and Firebase services could be separated.

---

## 5. Expense Model Planning

> What fields should an Expense model contain for a Flutter Expense Tracker application? Please suggest appropriate Dart data types and explain why each field is required. Do not generate the complete application.

---

## 6. Firebase / Firestore Planning

> I need to store Expense Tracker data using Firebase Cloud Firestore. Explain a suitable Firestore structure for storing expenses and describe how the application could create, read, update, and delete expense documents.

---

## 7. Firebase Data Retrieval

> I have an Expense model and a Firestore collection. Explain how I can retrieve expense documents from Firestore and convert them into Dart Expense objects in a Flutter application. Focus on the logic and common mistakes to avoid.

---

## 8. Riverpod State Management

> I am using Riverpod in my Flutter Expense Tracker. Explain how Riverpod can be used to manage the expense list and Firebase data. I need to handle loading, successful data, empty data, and error states.

---

## 9. Form Validation

> Help me design proper validation for an Add Expense form in Flutter. The form contains title, amount, category, date, and an optional note. Explain what validation rules should be applied and how the user should be informed about invalid input.

---

## 10. Monthly Expense Calculation

> I need to calculate the total expenses for the current month from a list of Expense objects in Flutter. Explain a clean approach for filtering expenses by month and calculating the total amount.

---

## 11. Expense Filtering

> How can I implement category and date filtering for an Expense History screen in Flutter? Explain a clean approach that works well with a Riverpod-based application.

---

## 12. Search Functionality

> I want to add a search feature to my Expense Tracker history screen. Users should be able to search expenses by title or note. Explain how I can implement the filtering logic efficiently without changing the original Firebase data.

---

## 13. Loading, Empty and Error States

> What are good UI patterns for handling loading, empty, and error states in a Flutter Expense Tracker? Give practical examples of what the user should see in each state.

---

## 14. Budget Progress Logic

> I am adding a monthly budget feature to my Expense Tracker. Explain how to calculate the percentage of the budget already spent and how to handle cases such as zero budget, spending above the budget, and no expenses.

---

## 15. Expense Chart

> I want to display a category-wise expense chart using fl_chart. Explain how I can prepare the expense data for a pie chart and calculate the amount spent in each category.

---

## 16. Dark Mode

> I want to add a light/dark theme option to my Flutter application. Explain a clean way to manage the theme state using Riverpod and make the application update consistently when the user changes the theme.

---

## 17. Debugging and Error Investigation

> I am getting an error while running my Flutter application. I will provide the error message and relevant code. Please identify the likely cause, explain why it happens, and suggest the smallest practical fix. Do not rewrite unrelated parts of the project.

---

## 18. Code Review

> Review the following Flutter code for potential problems related to readability, state management, null safety, error handling, and maintainability. Identify the important issues and explain how I can improve them without unnecessarily changing the existing architecture.

---

## 19. UI Improvement

> Review this Expense Tracker screen from a usability perspective. Suggest improvements to spacing, hierarchy, button placement, empty states, readability, and responsiveness while keeping the design simple and professional.

---

## 20. Final Testing Checklist

> Create a testing checklist for my Flutter Expense Tracker application. Include CRUD operations, Firebase connectivity, form validation, filtering, searching, monthly calculations, loading/error/empty states, navigation, responsiveness, and edge cases.

---

# Development Approach

The application was developed incrementally with the following general approach:

1. Understand the application requirements
2. Plan the application structure
3. Set up the Flutter project
4. Configure Firebase
5. Create the required data models
6. Implement Firebase data operations
7. Set up state management
8. Build the main application screens
9. Implement expense CRUD functionality
10. Add filtering and search
11. Implement monthly calculations
12. Add optional features
13. Test different user scenarios
14. Fix issues discovered during testing
15. Improve the UI and overall usability

AI assistance was used at different stages as a supporting development tool. The generated suggestions were reviewed and adapted to the application's requirements rather than being used as an unmodified complete solution.

---

# Project Structure

The project uses a feature-oriented structure to keep related functionality organized.

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── auth/
│   ├── expenses/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── services/
│   │   └── screens/
│   │
│   ├── dashboard/
│   ├── budget/
│   └── settings/
│
├── shared/
│   ├── widgets/
│   └── components/
│
└── main.dart
```

---

# Firebase

Firebase Cloud Firestore is used to store expense information.

The application uses Firebase Authentication for user authentication and Firestore for storing user expense data.

A typical expense contains:

```text
Expense
├── title
├── amount
├── category
├── date
└── note
```

---

# Getting Started

## Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Android Studio or another Flutter-compatible IDE
* Git
* A Firebase project

## Installation

Clone the repository:

```bash
git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
```

Navigate to the project:

```bash
cd YOUR-REPOSITORY
```

Install dependencies:

```bash
flutter pub get
```

Configure Firebase for the project according to the Firebase Flutter setup requirements.

Run the application:

```bash
flutter run
```

---

# Testing

The application was tested against the main functional requirements, including:

* Creating expenses
* Updating expenses
* Deleting expenses
* Selecting categories
* Selecting dates
* Calculating monthly totals
* Filtering expenses
* Searching expenses
* Firebase data synchronization
* Form validation
* Empty states
* Loading states
* Error states
* Theme changes
* Different screen sizes

---

# Future Improvements

Possible future improvements include:

* Advanced financial reports
* Recurring expenses
* Export expenses to CSV/PDF
* Cloud backup and restore
* More advanced budgeting tools
* Spending notifications
* Additional analytics
* Multi-currency support

---

# Conclusion

This project demonstrates the use of Flutter and Dart to develop a practical mobile application with Firebase integration, state management, CRUD functionality, filtering, validation, and responsive UI design.

AI tools were used as development assistants throughout the process for planning, technical guidance, troubleshooting, and code review while maintaining an incremental development and testing approach.

# SmartPocket – Student Expense & Budget Manager

## Project Overview

SmartPocket is a mobile application designed for university students to help them manage their daily expenses and control their monthly budgets.

Many students spend money without tracking their expenses. At the end of the month, they often do not know where their money went. SmartPocket solves this problem by providing a simple and easy way to record expenses, analyze spending habits, and control budgets.

The application allows users to add expenses, categorize spending, set a monthly budget, and view reports of their financial activity.

The goal of this project is to help students reduce financial stress and improve their saving habits.

---

# Problem Statement

Many university students do not track their daily spending. They spend money on food, transport, recharge, shopping, and other activities without keeping a record.

Because of this, students often lose control of their monthly budget.

There is a need for a simple and student-friendly application that helps users track and manage their expenses efficiently.

---

# Objectives

The main objectives of this project are:

• Help students track their daily expenses
• Help students control their monthly budget
• Provide simple financial insights
• Encourage better saving habits
• Reduce unnecessary spending

---

# Target Users

This application is mainly designed for:

• University students
• College students
• Young individuals aged **18–28**

---

# System Architecture

The system is built using a simple mobile architecture.

### Frontend

Flutter is used to develop the mobile application.

### State Management

Provider is used to manage the application state such as expenses, budget information, and UI updates.

### Local Storage

SharedPreferences is used to store user data locally on the device.

This allows the application to work **offline without requiring a backend server**.

---

# Technologies Used

The following technologies are used in this project:

• Flutter – Mobile application development
• Dart – Programming language used in Flutter
• Provider – State management
• SharedPreferences – Local data storage
• Material UI – User interface components

---

# Application Features

## User Authentication

Users can create and manage their accounts.

Features include:

• User registration
• User login
• Logout

---

## Add Expense

Users can record their daily expenses.

Each expense contains:

• Expense amount
• Category
• Description
• Date

Expense categories include:

• Food
• Transport
• Recharge
• Shopping
• University
• Other

---

## Expense History

Users can view all their previous expenses.

Features include:

• View all expenses
• Filter by category
• Filter by date
• Edit expense
• Delete expense

---

## Monthly Budget Management

Users can manage their monthly budget.

Features include:

• Set monthly budget
• Update budget
• Track spent amount
• View remaining budget

---

## Reports and Analytics

The application provides simple charts to help users understand their spending habits.

Charts include:

• Daily spending chart
• Weekly spending chart
• Monthly spending chart
• Category-wise pie chart

---

## Smart Spending Warnings

The application can show alerts when the user spends too much.

Examples:

"You have used 70% of your monthly budget."

"You are close to your budget limit."

---

# Data Storage

This application uses **SharedPreferences** to store data locally.

The stored data includes:

• User profile information
• Expense records
• Monthly budget

This makes the application **lightweight and fully functional offline**.

---

# Application Screens

The mobile application includes the following screens:

• Splash Screen
• Login Screen
• Register Screen
• Dashboard Screen
• Add Expense Screen
• Expense History Screen
• Budget Screen
• Reports Screen
• Profile Screen


# Project Structure

lib
│
├── screens
│ ├── splash_screen.dart
│ ├── login_screen.dart
│ ├── register_screen.dart
│ ├── dashboard_screen.dart
│ ├── add_expense_screen.dart
│ ├── expense_history_screen.dart
│ ├── reports_screen.dart
│ └── profile_screen.dart
│
├── providers
│ └── expense_provider.dart
│
├── models
│ └── expense_model.dart
│
├── services
│ └── shared_preferences_service.dart
│
├── widgets
│ └── expense_card.dart
│
└── main.dart

# Future Improvements

Possible improvements for future versions:

• Cloud database integration
• AI-based spending prediction
• Smart saving suggestions
• Bank API integration
• Web version of the application

---

# Author

Ibad Ullah
BS Software Engineering
Abasyn University Peshawar

---

# License

This project is created for educational purposes.


# 📚 Bookia App

A modern mobile application built with **Flutter and Dart**, designed to provide users with a simple and enjoyable experience for browsing books and exploring book-related content.

The project follows a modular structure to keep the code organized, reusable, and easy to maintain.

## 📱 Screenshots

### Welcome & Splash Screen



### Authentication Screens

<p align="center">
  <img src="assets/images/splash1.png" width="300">
<img src="assets/images/welcome 2.png" width="300">



</p>

> **Note:** Make sure these image paths match the actual locations of your screenshots in the repository.

## ✨ Features

* 📱 Responsive user interface.
* 🔐 Login screen with email and password fields.
* 📝 Register screen UI.
* ✅ Form validation for email and password.
* 🌐 API requests using Dio.
* 🔄 State management using Cubit and flutter_bloc.
* ⏳ Loading indicators during login requests.
* ⚠️ Error handling for failed login attempts.
* 🧭 Named routes and centralized navigation.
* 🎨 Reusable UI components and custom styling.
* 📐 Responsive layouts using Flutter ScreenUtil.
* 🌍 Localization support using Easy Localization.

## 🛠️ Technologies Used

| Technology         | Purpose                          |
| ------------------ | -------------------------------- |
| Flutter            | Building the mobile application  |
| Dart               | Application programming language |
| flutter_bloc       | State management                 |
| Cubit              | Managing authentication states   |
| Dio                | Sending HTTP requests to the API |
| Flutter ScreenUtil | Responsive sizing and spacing    |
| Easy Localization  | Supporting multiple languages    |
| Material Design    | Building the user interface      |

## 🔐 Authentication

The authentication module is organized into separate components to improve maintainability.

### Login
<img src="assets/images/login.png" width="300">

The login flow includes:

* Email and password input fields.
* Form validation before submitting credentials.
* API requests using Dio.
* Loading state while waiting for the response.
* Success and error states managed by AuthCubit.
* Navigation to the home screen after successful login.
* <img src="assets/images/error.png" width="300">

### Register
<img src="assets/images/register 1.png" width="300">

The registration interface is designed with the following fields:

* Username
* Email
* Password
* Confirm Password

The registration screen UI is being developed separately from the login screen.

> Note: The presence of a registration interface does not necessarily mean that registration is connected to a working API endpoint.

## 🔄 State Management

The application uses **Cubit** from the `flutter_bloc` package to manage authentication states.

The login process uses the following states:

* `AuthInitial`
* `LoginLoadingState`
* `LoginSuccessState`
* `LoginErrorState`

These states help the UI respond to different stages of the login request.

## 🌐 API Integration

The application uses **Dio** to send HTTP requests to the authentication API.

The authentication repository is responsible for communicating with the API, while `AuthCubit` manages the login process and emits the appropriate states.

This separation helps keep networking logic independent from the user interface.

## 🧭 Navigation

The application uses centralized named routing through `AppRouter`.

The routes include:

* Login Screen
* Register Screen
* Welcome Screen
* Home Screen

`BlocProvider` is used to provide `AuthCubit` to the login screen and its child widgets.

## 🎨 Reusable Components

The project includes reusable components to help maintain a consistent design.

* `AppButton`: A customizable button with configurable text and colors.
* `CustomTextFromFeild`: A reusable text field component.
* `AppTextStyle`: Centralized text styling.
* `AppColors`: Centralized application colors.
* `AppValidator`: Validation helpers for user input.

## 🌍 Supported Languages

The project includes localization support using Easy Localization.

Currently documented languages:

* 🇬🇧 English
* 🇩🇪 German

## 📂 Project Structure

```text
lib/
├── core/
│   ├── networking/
│   ├── routes/
│   │   ├── app_route.dart
│   │   └── app_router.dart
│   ├── themes/
│   │   ├── app_colors.dart
│   │   └── APP_text_Style.dart
│   ├── utils/
│   │   └── app_validator.dart
│   └── widget/
│       ├── App_button.dart
│       └── custom_text_from_feild.dart
│
├── features/
│   ├── auth/
│   │   └── data/
│   │       └── repo/
│   │           └── auth_repo.dart
│   └── presentaion/
│       ├── cubit/
│       │   ├── auth_cubit.dart
│       │   └── auth_state.dart
│       └── ui/
│           ├── login_Screen.dart
│           ├── register_screen.dart
│           └── widgets/
│               └── login_form.dart
│
├── bookia_App.dart
└── main.dart
```

> The structure above reflects the files discussed during development. Adjust the tree if your actual project uses different paths or filenames.

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio or Visual Studio Code
* An Android emulator or a physical device

### Installation

1. Clone the repository:

   ```bash
   git clone YOUR_REPOSITORY_URL
   ```

2. Navigate to the project directory:

   ```bash
   cd app3
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## 📦 Dependencies

The project uses packages such as:

* `flutter_bloc`
* `dio`
* `flutter_screenutil`
* `easy_localization`

Run the following command to install the dependencies declared in `pubspec.yaml`:

```bash
flutter pub get
```

## 🎯 Project Goals

* Build a clean and responsive Flutter application.
* Practice reusable widget development.
* Implement form validation.
* Integrate REST APIs using Dio.
* Manage application state with Cubit.
* Organize navigation using named routes.
* Separate UI, state management, and networking logic.

## 👨‍💻 Author

Developed as a Flutter learning project to practice mobile application development, authentication, API integration, and state management.

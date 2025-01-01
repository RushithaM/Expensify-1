# Expensify - Expense Tracker App

**Expensify** is a comprehensive expense tracker that allows you to not only track your income and expenses but also categorize them into different groups (e.g., Food, Salary, Entertainment) for better financial management. With detailed analysis, you can easily track spending patterns on monthly bases and make informed decisions to manage your finances effectively.

---

## Features

- **Track Income and Expenses**: Easily log both your income and expenses.
- **Categorize Transactions**: Organize your transactions into custom categories (e.g., Food, Salary, Entertainment).
- **Transaction History**: View a detailed record of all your past transactions.
- **Category-Based Analysis**: Get insights into your spending habits by category, with visual breakdowns.
- **Cross-Platform**: Available on both **iOS** and **Android** for seamless access across devices.

---

## How to Download the App

If you're on **Android** and would like to install the app, you can directly download the **app-release.apk** from the repository.
- [Download the APK](https://github.com/sujannani/Expensify/blob/main/app-release.apk)

Once downloaded, make sure to **enable "Install from Unknown Sources"** in your Android settings to install the APK.

---

## How to Use

### 1. **Sign In**
   - Open the app and **sign in** with your account.

### 2. **Set Up Categories**
   - Before adding any transactions, go to the **Categories** tab.
   - Tap the **Add Icon** button.
   - Enter a **new category name** (e.g., Food, Salary, Entertainment).
   - Select an **emoji** that represents the category (e.g., 🍔 for Food, 💰 for Salary).
   - This will allow you to organize your transactions into meaningful categories with associated emojis for easy identification.

### 3. **Adding Transactions**
   - Navigate to the **Add Transaction** tab.
   - Choose the category you created (e.g., Food, Salary).
   - Enter the **amount**, **description**, and select whether it is a **Debit** or **Credit** transaction.
   - Tap **Add** to save the transaction.

### 4. **Viewing Transaction History**
   - Go to the **History** tab to see a list of all your transactions.
   - Transactions are organized by month, making it easy to view and track your spending.

### 5. **Analyzing Your Spending**
   - In the **Analysis** tab, view the **category-based breakdown** of your expenses and income for the each month.
   - For each category (e.g., Food, Salary, Entertainment), see:
     - **Number of Transactions**: The total number of transactions in that category for the month.
     - **Amount Spent or Earned**: The total amount spent (for expenses) or earned (for income) in that category.
     - **Credit Percentage**: The percentage of transactions that were credited to your account in that category.
     - **Debit Percentage**: The percentage of transactions that were debited from your account in that category.
   - This month-based breakdown helps you track your financial activity and see how your spending or earnings in each category compare throughout the month.

---

## Tips for Best Use

- **Organize Early**: Set up categories before adding transactions for better tracking.
- **Add Transactions Regularly**: Record transactions as soon as they happen to keep your records up-to-date.
- **Use Descriptions**: Add detailed descriptions to each transaction for easier identification later.
- **Review Analytics**: Regularly check the **Analysis** tab to stay on top of your spending trends.

---

## Technologies Used

### Backend:
- **Flask**: Lightweight Python web framework to handle the backend logic.
- **MongoDB**: NoSQL database to store user data and transaction records.
  - **Models**: Used to define the data structure.
  - **Controllers**: Handle requests and logic for the app's operations.

### Frontend:
- **Flutter**: A cross-platform framework for building apps for both **iOS** and **Android**.

---

## FAQs

**Q: Will deleting a category remove my past transactions?**  
A: No, deleting a category will **not** remove your past transactions. It only removes the category label for future transactions.

**Q: Can I track transactions in multiple currencies?**  
A: The app currently supports a **single currency**. Multi-currency support is planned for future updates.

---

**Get Started with Expensify** and take control of your financial future today! 🚀💸

# unittesting
## 🧪 Testing Summary

**Dana:**  
Performed white-box unit and widget testing on the `LoginPage` and `SignupPage` in my `rafeeq_app` Flutter project using:

- `flutter_test` for widget interaction  
- `firebase_auth_mocks` for mocking Firebase authentication  
- `mockito` (indirectly via `firebase_auth_mocks`) to simulate login behaviors  
- Tested `MaterialApp`, navigation, form validation, and UI interactions  

### ✅ What I Tested

**1. Widget Rendering**  
- Verified presence of key UI components:  
  - Email and password fields  
  - Login, forgot password, create account buttons  
  - Google sign-in and image widgets  

**2. Form Validation**  
- Empty fields show correct error messages  
- Invalid email formats are rejected (`test@`, `test@@example.com`)  
- Short passwords (<6 chars) are rejected  
- Valid inputs pass the form validator  

**3. Password Visibility Toggle**  
- Confirmed icon toggles between visible/hidden  
- `obscureText` is updated correctly  

**4. Navigation Logic**  
- Clicking **"Create account"** navigates to the Signup page  

**5. UI Styling**  
- Button and scaffold colors were verified  
- `MaterialButton` and `ElevatedButton` styles were checked  
- Ensured layout uses `SingleChildScrollView`, `Padding`, and `SizedBox`  

**6. Text Field Interaction**  
- Text entry works for both fields  
- Password visibility toggle updates text field behavior  

**7. Layout and Structure**  
- Verified arrangement in a `Column`  
- Confirmed use of `crossAxisAlignment`, scroll view, and padding  

---

## 🔐 Security

### How We Secured the Flutter App

- **Authentication & Verification**  
  Used Firebase Authentication with email verification to ensure only legitimate users can log in.

- **Input Validation**  
  Validated all user inputs (e.g., email and password) to prevent spoofing and injection-style attacks.

- **Generic Error Messages**  
  Used generic messages like “Login failed” to prevent user enumeration and avoid giving away account existence.

- **Rate Limiting on Login Attempts**  
  Locked login for 1 minute after 3 failed attempts to protect against brute-force attacks.

- **Obfuscation to Prevent Reverse Engineering**  
  Used `flutter build` with `--obfuscate` and `--split-debug-info` to protect the app code.

- **Encapsulation and Private Classes**  
  Applied good coding practices like private members and logic encapsulation to limit data exposure.

- **HTTPS by Default (MITM Protection)**  
  Flutter uses HTTPS by default for all network communications, helping prevent man-in-the-middle (MITM) attacks.

- **Dependency Updates**  
  Regularly updated packages to benefit from security patches and improvements.

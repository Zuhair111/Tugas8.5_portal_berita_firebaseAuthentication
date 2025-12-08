# 🔄 Authentication Flow Diagram

## 📱 Registration Flow

```
User Input (RegisterScreen)
    ↓
    [Name, Email, Password, Confirm Password]
    ↓
AuthService.register()
    ↓
Validate Input
    ↓
Firebase.createUserWithEmailAndPassword()
    ↓
    ├─→ Success
    │   ↓
    │   Update Display Name
    │   ↓
    │   Save to SharedPreferences
    │   │   - user_id (Firebase UID)
    │   │   - user_name
    │   │   - user_email
    │   ↓
    │   Return success + User object
    │   ↓
    │   Show success message
    │   ↓
    │   Navigate back to home (logged in)
    │
    └─→ Error (FirebaseAuthException)
        ↓
        Handle error codes:
        - email-already-in-use
        - weak-password
        - invalid-email
        ↓
        Show error message
        ↓
        Stay on register screen
```

## 🔑 Login Flow

```
User Input (LoginScreen)
    ↓
    [Email, Password]
    ↓
AuthService.login()
    ↓
Validate Input
    ↓
Firebase.signInWithEmailAndPassword()
    ↓
    ├─→ Success
    │   ↓
    │   Get Firebase User
    │   ↓
    │   Save to SharedPreferences
    │   │   - user_id (Firebase UID)
    │   │   - user_name (displayName)
    │   │   - user_email
    │   ↓
    │   Get ID Token
    │   ↓
    │   Return success + User object
    │   ↓
    │   Show success message
    │   ↓
    │   Navigate back to home (logged in)
    │
    └─→ Error (FirebaseAuthException)
        ↓
        Handle error codes:
        - user-not-found
        - wrong-password
        - invalid-credential
        - invalid-email
        - user-disabled
        ↓
        Show error message
        ↓
        Stay on login screen
```

## 🚪 Logout Flow

```
User taps Logout
    ↓
AuthService.logout()
    ↓
Firebase.signOut()
    ↓
Clear SharedPreferences
    │   - Remove user_id
    │   - Remove user_name
    │   - Remove user_email
    ↓
Success
    ↓
Update UI (show login button)
```

## 🔍 Session Check Flow

```
App Start (main.dart)
    ↓
Firebase.initializeApp()
    ↓
Load Home Screen
    ↓
AuthService.isLoggedIn()
    ↓
Check Firebase.currentUser
    ↓
    ├─→ User exists
    │   ↓
    │   Show user profile icon
    │   ↓
    │   Allow commenting
    │
    └─→ User null
        ↓
        Show login button
        ↓
        Require login for comments
```

## 🔐 Token Management

```
Need Token (for API calls)
    ↓
AuthService.getToken()
    ↓
Get Firebase.currentUser
    ↓
    ├─→ User exists
    │   ↓
    │   user.getIdToken()
    │   ↓
    │   Return token (JWT)
    │   ↓
    │   Use in API headers
    │
    └─→ User null
        ↓
        Return null
        ↓
        Redirect to login
```

## 📊 User Data Flow

```
Need User Data
    ↓
AuthService.getUserData()
    ↓
Get Firebase.currentUser
    ↓
    ├─→ User exists
    │   ↓
    │   Return Map:
    │   {
    │     'id': user.uid,
    │     'name': user.displayName,
    │     'email': user.email
    │   }
    │
    └─→ User null
        ↓
        Return null
```

## 🔄 Complete User Journey

### New User Journey
```
1. Open App
    ↓
2. Browse Articles (guest)
    ↓
3. Try to Comment
    ↓
4. Redirect to Login Screen
    ↓
5. Tap "Daftar"
    ↓
6. Fill Registration Form
    ↓
7. Submit → Firebase creates user
    ↓
8. Auto-login → Back to article
    ↓
9. Can now comment
```

### Returning User Journey
```
1. Open App
    ↓
2. Firebase checks session
    ↓
3. User still logged in
    ↓
4. Browse & Comment freely
```

## 🛡️ Security Flow

### Firebase Security
```
Client App
    ↓
Firebase Auth SDK
    ↓
    [Encrypted HTTPS]
    ↓
Firebase Auth Server
    ↓
Verify credentials
    ↓
Generate ID Token (JWT)
    ↓
    [Encrypted HTTPS]
    ↓
Client App receives token
    ↓
Store securely (Firebase SDK)
    ↓
Use for authenticated requests
```

### Token Validation (when calling Laravel API)
```
Client Request
    ↓
Get Firebase ID Token
    ↓
Include in Authorization header
    ↓
Laravel Backend
    ↓
Validate token with Firebase Admin SDK
    ↓
    ├─→ Valid
    │   ↓
    │   Process request
    │
    └─→ Invalid
        ↓
        Return 401 Unauthorized
```

## 📱 Screen Flow

```
Home Screen
    ↓
    ├─→ [Not Logged In]
    │   ↓
    │   Tap Profile Icon
    │   ↓
    │   Login Screen ←→ Register Screen
    │   ↓
    │   Login Success
    │   ↓
    │   Back to Home (Logged In)
    │
    └─→ [Logged In]
        ↓
        Can browse & comment
        ↓
        Tap Profile Icon
        ↓
        Show user info + Logout button
```

## 🎯 State Management

### Auth State
```
AuthService (Singleton)
    ↓
Manages:
    - FirebaseAuth instance
    - Current user
    - Login state
    ↓
Notifies:
    - UI widgets via callbacks
    - Navigation logic
    ↓
Persists:
    - User session (Firebase SDK)
    - User data (SharedPreferences)
```

---

## 💡 Tips

1. **Session Persistence**: Firebase SDK automatically maintains session
2. **Token Refresh**: ID tokens auto-refresh every hour
3. **Offline Support**: Firebase Auth works offline after first login
4. **Security**: Never store passwords, only use Firebase tokens
5. **Error Handling**: Always catch FirebaseAuthException for specific errors

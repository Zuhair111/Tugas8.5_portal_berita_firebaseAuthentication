# 🔗 Laravel Integration (Optional)

Panduan untuk mengintegrasikan Firebase Authentication dengan Laravel backend (untuk fitur seperti komentar, artikel, dll).

---

## 📋 Overview

**Scenario:**
- ✅ Firebase handles user registration & login
- ✅ Laravel handles articles, comments, and other business logic
- ✅ Firebase ID Token digunakan untuk authenticate requests ke Laravel

**Flow:**
```
Flutter App → Firebase Auth → Get ID Token
    ↓
Send request to Laravel with token
    ↓
Laravel verifies token with Firebase
    ↓
Process request & return response
```

---

## 🔧 Laravel Setup

### 1. Install Firebase Admin SDK

```bash
composer require kreait/firebase-php
```

### 2. Download Service Account Key

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click ⚙️ (Settings) → Project Settings
4. Go to "Service accounts" tab
5. Click "Generate new private key"
6. Download JSON file
7. Save as `storage/app/firebase-credentials.json`

### 3. Add to .gitignore

```gitignore
# Firebase
storage/app/firebase-credentials.json
```

### 4. Configure Firebase in Laravel

**File: `config/services.php`**
```php
return [
    // ... existing services

    'firebase' => [
        'credentials' => storage_path('app/firebase-credentials.json'),
        'database_url' => env('FIREBASE_DATABASE_URL', null),
    ],
];
```

### 5. Create Firebase Service Provider

**File: `app/Providers/FirebaseServiceProvider.php`**
```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Kreait\Firebase\Factory;

class FirebaseServiceProvider extends ServiceProvider
{
    public function register()
    {
        $this->app->singleton('firebase.auth', function ($app) {
            $factory = (new Factory)
                ->withServiceAccount(config('services.firebase.credentials'));

            return $factory->createAuth();
        });
    }

    public function boot()
    {
        //
    }
}
```

**Register provider in `config/app.php`:**
```php
'providers' => [
    // ...
    App\Providers\FirebaseServiceProvider::class,
],
```

---

## 🛡️ Create Middleware

**File: `app/Http/Middleware/FirebaseAuth.php`**
```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Kreait\Firebase\Exception\Auth\FailedToVerifyToken;

class FirebaseAuth
{
    public function handle(Request $request, Closure $next)
    {
        $token = $request->bearerToken();

        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Token tidak ditemukan'
            ], 401);
        }

        try {
            $auth = app('firebase.auth');
            $verifiedIdToken = $auth->verifyIdToken($token);
            
            // Add user info to request
            $request->attributes->add([
                'firebase_user_id' => $verifiedIdToken->claims()->get('sub'),
                'firebase_user_email' => $verifiedIdToken->claims()->get('email'),
            ]);

            return $next($request);
        } catch (FailedToVerifyToken $e) {
            return response()->json([
                'success' => false,
                'message' => 'Token tidak valid'
            ], 401);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }
}
```

**Register middleware in `app/Http/Kernel.php`:**
```php
protected $middlewareAliases = [
    // ...
    'firebase' => \App\Http\Middleware\FirebaseAuth::class,
];
```

---

## 🗄️ Update Database

### Option 1: Store Firebase UID

**Migration: `create_users_table.php`**
```php
Schema::create('users', function (Blueprint $table) {
    $table->id();
    $table->string('firebase_uid')->unique();
    $table->string('name');
    $table->string('email')->unique();
    $table->timestamps();
});
```

### Option 2: Sync Firebase Users

**Create User on First Request:**
```php
public function handle(Request $request, Closure $next)
{
    // ... verify token code ...
    
    $firebaseUid = $verifiedIdToken->claims()->get('sub');
    $email = $verifiedIdToken->claims()->get('email');
    $name = $verifiedIdToken->claims()->get('name');
    
    // Find or create user
    $user = User::firstOrCreate(
        ['firebase_uid' => $firebaseUid],
        [
            'name' => $name,
            'email' => $email,
        ]
    );
    
    $request->attributes->add(['user' => $user]);
    
    return $next($request);
}
```

---

## 📝 Update Routes

**File: `routes/api.php`**
```php
// Public routes (no auth)
Route::get('/articles', [ArticleController::class, 'index']);
Route::get('/articles/{id}', [ArticleController::class, 'show']);
Route::get('/categories', [CategoryController::class, 'index']);

// Protected routes (require Firebase auth)
Route::middleware('firebase')->group(function () {
    Route::post('/comments', [CommentController::class, 'store']);
    Route::put('/comments/{id}', [CommentController::class, 'update']);
    Route::delete('/comments/{id}', [CommentController::class, 'destroy']);
    Route::get('/user/profile', [UserController::class, 'profile']);
});
```

---

## 🎯 Update Controllers

**File: `app/Http/Controllers/CommentController.php`**
```php
public function store(Request $request)
{
    $validated = $request->validate([
        'article_id' => 'required|exists:articles,id',
        'content' => 'required|string|max:1000',
    ]);

    // Get Firebase user info from middleware
    $firebaseUid = $request->attributes->get('firebase_user_id');
    $user = $request->attributes->get('user'); // If using Option 2

    $comment = Comment::create([
        'article_id' => $validated['article_id'],
        'user_id' => $user->id, // or use firebase_uid directly
        'content' => $validated['content'],
    ]);

    return response()->json([
        'success' => true,
        'data' => [
            'comment' => $comment->load('user'),
        ],
    ], 201);
}
```

---

## 📱 Flutter App Updates

**File: `lib/services/comment_service.dart`**
```dart
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<Map<String, dynamic>> addComment(int articleId, String content) async {
    try {
      // Get Firebase ID Token
      final user = _auth.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'Belum login'};
      }
      
      final idToken = await user.getIdToken();
      
      // Send request to Laravel with token
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/comments'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $idToken', // Firebase token
        },
        body: jsonEncode({
          'article_id': articleId,
          'content': content,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
```

---

## 🧪 Testing

### Test Laravel Endpoint

```bash
# Get a Firebase ID token from your app
# Then test with curl:

curl -X POST http://localhost:8000/api/comments \
  -H "Authorization: Bearer YOUR_FIREBASE_ID_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "article_id": 1,
    "content": "Test comment from Firebase user"
  }'
```

### Test from Flutter

```dart
// In your app
final commentService = CommentService();
final result = await commentService.addComment(1, 'Test comment');
print(result);
```

---

## 🔐 Security Considerations

### 1. Token Validation
- ✅ Always verify token on server side
- ✅ Never trust client-side validation
- ✅ Token expires after 1 hour (auto-refresh by Firebase)

### 2. CORS Configuration

**File: `config/cors.php`**
```php
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'], // Change in production
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

### 3. Rate Limiting

**File: `routes/api.php`**
```php
Route::middleware(['firebase', 'throttle:60,1'])->group(function () {
    Route::post('/comments', [CommentController::class, 'store']);
});
```

---

## 📊 User Data Sync

### Keep Firebase as Source of Truth

```php
// Update user info from Firebase
public function syncUser(Request $request)
{
    $firebaseUid = $request->attributes->get('firebase_user_id');
    
    try {
        $auth = app('firebase.auth');
        $firebaseUser = $auth->getUser($firebaseUid);
        
        $user = User::updateOrCreate(
            ['firebase_uid' => $firebaseUid],
            [
                'name' => $firebaseUser->displayName,
                'email' => $firebaseUser->email,
                'email_verified_at' => $firebaseUser->emailVerified ? now() : null,
            ]
        );
        
        return response()->json([
            'success' => true,
            'data' => ['user' => $user],
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Failed to sync user: ' . $e->getMessage(),
        ], 500);
    }
}
```

---

## 🎯 Complete Example

### Laravel Comment System with Firebase

**Migration:**
```php
Schema::create('comments', function (Blueprint $table) {
    $table->id();
    $table->foreignId('article_id')->constrained()->onDelete('cascade');
    $table->string('firebase_uid'); // Store Firebase UID directly
    $table->string('user_name'); // Cache from Firebase
    $table->text('content');
    $table->timestamps();
});
```

**Controller:**
```php
public function store(Request $request)
{
    $validated = $request->validate([
        'article_id' => 'required|exists:articles,id',
        'content' => 'required|string|max:1000',
    ]);

    $firebaseUid = $request->attributes->get('firebase_user_id');
    $auth = app('firebase.auth');
    $firebaseUser = $auth->getUser($firebaseUid);

    $comment = Comment::create([
        'article_id' => $validated['article_id'],
        'firebase_uid' => $firebaseUid,
        'user_name' => $firebaseUser->displayName,
        'content' => $validated['content'],
    ]);

    return response()->json([
        'success' => true,
        'data' => ['comment' => $comment],
    ], 201);
}

public function index(Request $request)
{
    $articleId = $request->query('article_id');
    
    $comments = Comment::where('article_id', $articleId)
        ->latest()
        ->get();

    return response()->json([
        'success' => true,
        'data' => ['comments' => $comments],
    ]);
}
```

---

## 📚 Resources

- [Firebase Admin SDK for PHP](https://github.com/kreait/firebase-php)
- [Firebase Admin SDK Documentation](https://firebase-php.readthedocs.io/)
- [Laravel Middleware Documentation](https://laravel.com/docs/middleware)

---

## ✅ Checklist

- [ ] Install `kreait/firebase-php`
- [ ] Download Firebase service account key
- [ ] Create FirebaseServiceProvider
- [ ] Create FirebaseAuth middleware
- [ ] Update routes with middleware
- [ ] Update controllers to use Firebase UID
- [ ] Update Flutter app to send Firebase token
- [ ] Test authentication flow
- [ ] Test protected endpoints
- [ ] Configure CORS properly

---

**Integration Type**: Optional (only if you need Laravel backend)  
**Complexity**: Intermediate  
**Time Required**: 1-2 hours  
**Status**: Ready to implement

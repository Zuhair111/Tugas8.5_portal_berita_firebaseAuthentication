<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Article;
use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    /**
     * Get comments for an article
     */
    public function index($articleSlug)
    {
        $article = Article::where('slug', $articleSlug)->firstOrFail();
        
        $comments = Comment::where('article_id', $article->id)
            ->where('is_approved', true)
            ->with('user:id,name,email')
            ->latest()
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => $comments
        ]);
    }

    /**
     * Store a new comment (requires authentication)
     */
    public function store(Request $request, $articleSlug)
    {
        $article = Article::where('slug', $articleSlug)->firstOrFail();

        $request->validate([
            'content' => 'required|string|max:1000',
            'user_name' => 'required|string',
            'user_email' => 'required|email',
        ]);

        // Get or create user based on Firebase email
        $user = \App\Models\User::firstOrCreate(
            ['email' => $request->user_email],
            [
                'name' => $request->user_name,
                'password' => bcrypt('firebase-user-' . time()),
                'email_verified_at' => now(),
            ]
        );

        $comment = Comment::create([
            'article_id' => $article->id,
            'user_id' => $user->id,
            'content' => $request->content,
            'is_approved' => true, // Auto approve, or set to false for moderation
        ]);

        $comment->load('user:id,name,email');

        return response()->json([
            'success' => true,
            'message' => 'Comment posted successfully',
            'data' => $comment
        ], 201);
    }

    /**
     * Delete own comment
     */
    public function destroy(Request $request, $commentId)
    {
        $request->validate([
            'user_email' => 'required|email',
        ]);

        $comment = Comment::findOrFail($commentId);
        $user = \App\Models\User::where('email', $request->user_email)->first();

        // Check if user owns the comment
        if (!$user || $comment->user_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized'
            ], 403);
        }

        $comment->delete();

        return response()->json([
            'success' => true,
            'message' => 'Comment deleted successfully'
        ]);
    }
}

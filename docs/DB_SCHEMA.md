# Database Schema

## Collection: `articles`

Each document in the `articles` collection represents a journalist-uploaded article.

```
articles/ (collection)
  └── {articleId}/ (document — auto-generated ID)
        ├── id:           String   — same as the document ID
        ├── title:        String   — headline of the article
        ├── description:  String   — short summary (max ~200 chars)
        ├── content:      String   — full body of the article
        ├── author:       String   — journalist's name
        ├── category:     String   — e.g. "Technology", "Sports", "Politics"
        ├── thumbnailURL: String   — reference to Cloud Storage path: media/articles/{filename}
        ├── source:       String   — publication name or journalist's outlet
        ├── url:          String   — optional external URL (can be empty string)
        └── publishedAt:  Timestamp — date and time the article was published
```

## Cloud Storage Structure

Thumbnails for articles are stored in:
```
media/
  └── articles/
        └── {filename}.jpg   (or .png, .webp)
```

The `thumbnailURL` field in Firestore stores the full download URL returned by
Firebase Storage after upload (e.g. `https://firebasestorage.googleapis.com/...`).

## Design Decisions

- `id` is stored redundantly in the document to make client-side mapping easier
  without requiring an extra Firestore call.
- `publishedAt` uses a Firestore `Timestamp` (not a string) to allow ordering
  and range queries efficiently.
- `thumbnailURL` stores the download URL directly so the app does not need to
  resolve the Storage path on every read.
- No subcollections are needed at this stage. If comments or likes are added in
  the future, they would live in `articles/{articleId}/comments` and
  `articles/{articleId}/likes` respectively.
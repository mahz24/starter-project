# Technical Report — Journalist Article Upload Feature

## 1. Overview

This report documents the implementation of the journalist article upload feature
for the Symmetry News App. The feature allows authenticated journalists to create
and publish articles directly to the app, with optional thumbnail images stored in
Firebase Cloud Storage and article data persisted in Firebase Firestore.

---

## 2. Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Frontend framework |
| Firebase Firestore | Article data persistence |
| Firebase Cloud Storage | Thumbnail image storage |
| Flutter BLoC (Cubit) | State management |
| GetIt | Dependency injection |
| Clean Architecture | Project structure |

---

## 3. Architecture Decisions

### 3.1 Clean Architecture

The feature follows Symmetry's Clean Architecture pattern, divided into three layers:

- **Domain Layer** — Pure Dart. Contains `ArticleEntity`, `ArticleRepository` (abstract),
  `GetArticlesUseCase`, and `CreateArticleUseCase`. This layer has zero dependencies on
  Flutter or Firebase, making it fully testable in isolation.

- **Data Layer** — Contains `ArticleModel` (extends `ArticleEntity`), `ArticleFirebaseDataSource`,
  and `ArticleRepositoryImpl`. This is the only layer that communicates with Firebase directly.

- **Presentation Layer** — Contains `ArticleCubit`, `ArticleState`, `JournalistArticlesScreen`,
  `CreateArticleScreen`, and `ArticleCard`. Only communicates with the domain layer through use cases.

### 3.2 Cubit over BLoC

I chose to use a `Cubit` instead of a full `BLoC` for the articles feature because the
interactions are straightforward — load articles and create an article. There are no
complex event streams that would justify the overhead of a full BLoC. This aligns with
the principle of keeping things as simple as possible.

### 3.3 DataState wrapper

Rather than using `DioException` (which ties the domain layer to a specific HTTP client),
I refactored `DataState` to use Dart's native `Exception`. This keeps the domain layer
dependency-free and makes the codebase more flexible — today we use Firebase, tomorrow
we could swap it for any other backend without touching the domain layer.

### 3.4 Firestore Schema Design

```
articles/{articleId}
  ├── id:           String
  ├── title:        String
  ├── description:  String
  ├── content:      String
  ├── author:       String
  ├── category:     String
  ├── thumbnailURL: String  →  media/articles/{filename} in Cloud Storage
  ├── source:       String
  ├── url:          String
  └── publishedAt:  Timestamp
```

I stored `id` redundantly in the document to avoid extra Firestore reads when mapping
documents client-side. `publishedAt` uses a Firestore `Timestamp` (not a string) to
enable efficient ordering and range queries.

---

## 4. What Was Implemented

- [x] Firestore schema design and documentation (`backend/docs/DB_SCHEMA.md`)
- [x] Firestore security rules (`backend/firestore.rules`)
- [x] Domain layer: entity, repository interface, use cases
- [x] Data layer: model, Firebase data source, repository implementation
- [x] Thumbnail upload to Firebase Cloud Storage (`media/articles/`)
- [x] Presentation layer: Cubit, states, screens, widgets
- [x] Pull-to-refresh on the articles list
- [x] Empty state and error state UI
- [x] Category filtering via dropdown
- [x] Navigation integrated into existing app router
- [x] Zero analyzer warnings across the entire codebase

---

## 5. What I Would Add With More Time

- **Authentication** — Firebase Auth so that only verified journalists can publish.
  The Firestore rules are already written to enforce author-based ownership once
  auth is in place.
- **Article detail screen** — A full-screen reading view with hero image animation.
- **Search** — Filter articles by title or category from the home screen.
- **Delete article** — Allow the author to remove their own articles.
- **Offline support** — Firestore's offline persistence is already enabled by default;
  a proper offline UI indicator would improve the experience.
- **Unit tests** — The domain layer is structured to be fully testable in isolation.
  I would write tests for all use cases and the cubit following TDD principles.
- **Image compression** — Compress thumbnails before upload to reduce Storage costs.

---

## 6. Challenges & Learnings

The most valuable learning from this project was internalizing Clean Architecture not
as a set of folders, but as a set of rules about **who is allowed to talk to whom**.
The domain layer knowing nothing about Firebase forces you to think in abstractions,
which makes the code genuinely more maintainable.

The biggest practical challenge was aligning the existing `DioError`-based `DataState`
with Firebase's error model. The solution — switching to native `Exception` — turned out
to be architecturally cleaner than the original approach.

---

## 7. Feedback on the Project

The starter project is well structured and the documentation is clear. One suggestion:
the `UseCase` base class signature in `core/usecase/usecase.dart` could be more explicit
about whether it wraps the return type in `DataState` or not — the existing `daily_news`
use cases and the base class were slightly misaligned, which caused initial confusion.
Clarifying this in the architecture docs would help future contributors onboard faster.
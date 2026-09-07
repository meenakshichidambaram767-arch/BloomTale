# 🌸 BloomTale

> **Every girl deserves to understand her story.**

BloomTale is an **AI-powered educational mobile application** designed to help adolescent girls understand puberty, menstruation, emotional changes, hygiene, confidence, and personal growth in a **safe, relatable, and engaging way**.

Instead of presenting health education as long, clinical articles, BloomTale uses **interactive storytelling, relatable situations, meaningful choices, an AI companion, and personal progress** to create a learning experience that feels natural and memorable.

---

## ✨ Vision

BloomTale is built around:

**Learn • Explore • Grow**

We want to transform an often-confusing stage of life into a journey where girls can:

* Learn at their own pace
* Understand changes happening to their bodies
* Ask questions without embarrassment
* Explore real-life situations
* Build emotional awareness
* Develop confidence
* Make healthier and more informed decisions

---

# 🎯 Problem

Many girls enter puberty without access to information that is:

* Age-appropriate
* Trustworthy
* Easy to understand
* Relatable
* Free from stigma
* Emotionally supportive

Existing resources can often feel too clinical, text-heavy, or difficult to relate to.

BloomTale addresses this by turning educational content into an **interactive story-driven experience**.

---

# 💡 Solution

BloomTale combines:

```text
Interactive Stories
        +
Relatable Avatar
        +
Bloom AI
        +
Period & Cycle Tracking
        +
Progress & Achievements
        =
Personalized Learning Journey
```

---

# 👧 MVP: One Avatar

The initial version of BloomTale uses **one primary avatar**.

The avatar acts as the user's companion throughout the application.

She appears in:

* Onboarding
* Home
* Interactive stories
* Learning experiences
* Bloom AI
* Story completion
* Progress experiences

The architecture is intentionally designed to support multiple avatars later.

### Current MVP

```text
default_avatar
```

### Future

```text
default_avatar
ananya
meera
lavanya
kiara
```

Multiple-avatar selection is **not part of the initial MVP**.

---

# 🚀 Core Features

## 📖 Interactive Stories

BloomTale's main learning experience is a visual-novel-style story system.

Users experience situations through:

* Dialogue
* Character expressions
* Visual backgrounds
* Choices
* Branching scenes
* Educational explanations
* Story outcomes

Example:

```text
Something feels different today...

        ↓

What should I do?

┌─────────────────────────┐
│ Ask someone I trust     │
├─────────────────────────┤
│ Find reliable info      │
├─────────────────────────┤
│ Ignore it               │
└─────────────────────────┘
```

Choices lead to different educational experiences rather than simply marking answers as "right" or "wrong".

---

## 🤖 Bloom AI

Bloom is BloomTale's supportive AI companion.

Users can ask questions about topics such as:

* Puberty
* Menstruation
* Hygiene
* Emotions
* Body changes
* Confidence
* Everyday growing-up situations

Bloom is designed to be:

* Supportive
* Age-appropriate
* Non-judgmental
* Easy to understand
* Educational

AI requests are routed through a **secure backend layer**.

Private AI API keys must never be stored inside the Flutter application.

---

## 🩷 Period & Cycle Tracker

The tracker allows users to record:

* Period start dates
* Flow
* Mood
* Symptoms
* Cycle history

Example symptoms:

```text
Cramps
Headache
Tired
Bloating
Backache
Mood changes
```

Example moods:

```text
Happy
Okay
Sad
Irritated
Anxious
Calm
```

Cycle predictions are presented as **estimates**, not medical guarantees.

---

## 🏆 Progress & Achievements

BloomTale encourages learning through progress rather than competition.

Users can track:

* XP
* Stories completed
* Learning streaks
* Topics explored
* Achievements

Example achievements:

| Achievement       | Requirement                             |
| ----------------- | --------------------------------------- |
| 🌱 First Step     | Complete your first story               |
| 📖 Story Explorer | Complete 5 stories                      |
| 🩷 Period Pro     | Complete a menstruation learning module |
| 💬 Curious Mind   | Ask Bloom your first question           |
| 🌸 Growing Strong | Maintain a 7-day learning streak        |

---

# 🛠️ Technology Stack

| Technology                  | Purpose                           |
| --------------------------- | --------------------------------- |
| **Flutter**                 | Cross-platform mobile application |
| **Dart**                    | Application programming language  |
| **Firebase Authentication** | User authentication               |
| **Cloud Firestore**         | Application data                  |
| **Firebase Storage**        | Images and media                  |
| **Riverpod**                | State management                  |
| **GoRouter**                | Navigation                        |
| **Clean Architecture**      | Application architecture          |
| **AI API**                  | Bloom AI                          |
| **Cloud/backend layer**     | Secure AI communication           |

---

# 🏗️ Architecture

BloomTale follows a **feature-based Clean Architecture**.

```text
Presentation
     ↓
Domain
     ↓
Data
     ↓
Firebase / External Services
```

The UI should never communicate directly with Firebase.

Example:

```text
StoryScreen
     ↓
StoryProvider
     ↓
GetStoryUseCase
     ↓
StoryRepository
     ↓
StoryRepositoryImpl
     ↓
FirebaseStoryDataSource
     ↓
Firestore
```

---

# 📁 Project Structure

```text
lib/
│
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── widgets/
│
├── features/
│
│   ├── authentication/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── onboarding/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── avatar/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── stories/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── bloom_ai/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── cycle_tracker/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── progress/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── achievements/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── firebase_options.dart
```

---

# 🧭 Application Flow

The main user journey is:

```text
Splash
   ↓
Welcome
   ↓
Onboarding
   ↓
Profile Setup
   ↓
Meet Avatar
   ↓
Home
```

After onboarding:

```text
                 HOME
                   │
       ┌───────────┼───────────┐
       ↓           ↓           ↓
     LEARN       BLOOM       TRACK
       │           │           │
    Stories       AI        Periods
       │                       │
    Choices                  Mood
       │                    Symptoms
       ↓
   Progress
       │
   Achievements
```

---

# 📱 MVP Screens

The initial MVP contains approximately:

1. Splash
2. Welcome
3. Onboarding
4. Profile Setup
5. Meet Avatar
6. Home
7. Story Library
8. Story Scene
9. Story Completion
10. Bloom AI
11. Period Tracker
12. Cycle History
13. Progress
14. Achievements
15. Settings

---

# 🧭 Navigation

The main navigation uses:

```text
┌─────────────────────────────────┐
│             SCREEN              │
├─────────────────────────────────┤
│  🏠       📖       🤖       🩷  │
│ Home     Learn    Bloom    Track│
└─────────────────────────────────┘
```

Progress and achievements can initially be accessed from the Home screen.

---

# 📚 Story Engine

Stories are **data-driven**.

A story consists of:

```text
Story
 ├── Scene
 │    ├── Dialogue
 │    ├── Background
 │    ├── Character
 │    └── Choices
 │
 └── Choice
      ├── Text
      ├── Next Scene
      └── Learning Score
```

### Story

```text
id
title
description
coverImage
category
scenes
```

### Scene

```text
id
backgroundImage
characterImage
dialogue
choices
```

### Choice

```text
id
text
nextSceneId
learningScore
```

This architecture allows new stories to be added without creating new Flutter screens for every story.

---

# 🗄️ Firebase Structure

Initial Firestore structure:

```text
users/
  {userId}

stories/
  {storyId}

avatars/
  {avatarId}

cycle_logs/
  {userId}/
    {logId}

achievements/
  {achievementId}
```

AI conversations:

```text
users/
  {userId}/
    ai_conversations/
      {conversationId}/
        messages/
          {messageId}
```

Private user data must only be accessible to the relevant authenticated user.

---

# 👤 User Data

A basic user profile contains:

```json
{
  "id": "user-id",
  "name": "User",
  "avatarId": "default_avatar",
  "createdAt": "timestamp",
  "onboardingCompleted": true,
  "learningStreak": 0,
  "totalStoriesCompleted": 0,
  "totalXp": 0
}
```

---

# 🌸 Avatar System

The avatar is represented by an entity rather than hard-coded throughout the application.

```dart
class Avatar {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
}
```

The current MVP uses:

```text
default_avatar
```

Possible avatar expressions:

```text
happy
worried
embarrassed
thinking
relieved
confident
sad
surprised
```

Final illustrations can be added independently from the application logic.

---

# 🤖 Bloom AI Architecture

AI communication follows:

```text
Flutter
   ↓
Secure Backend / Cloud Function
   ↓
AI API
   ↓
Safety Validation
   ↓
Flutter
```

Never store private AI credentials in:

```text
lib/
assets/
.env committed to Git
Flutter source code
```

Environment variables and secure server-side configuration should be used.

---

# 🛡️ Safety & Privacy

BloomTale is intended for adolescent users, so privacy and safety are fundamental product requirements.

The system should support:

* Minimal data collection
* Secure authentication
* Secure API communication
* Private user data
* Secure Firestore rules
* Age-appropriate AI responses
* Appropriate consent flows
* Safe handling of sensitive questions
* Safe handling of emergencies
* Data deletion considerations

Bloom AI should not:

* Diagnose medical conditions
* Pretend to be a doctor
* Provide sexualized responses
* Encourage unsafe behavior
* Request unnecessary personal information

Where appropriate, Bloom should encourage users to speak with a trusted adult or qualified healthcare professional.

Legal/privacy requirements may vary by country and age group and must be reviewed before production launch.

---

# 🔐 Security Principles

Follow least-privilege access.

Users should only access their own private data.

Sensitive information should never be exposed through public Firestore collections.

Do not place secrets inside the mobile application.

Validate important operations on the backend where appropriate.

---

# 📊 Analytics

Useful product events include:

```text
onboarding_completed
story_started
story_completed
choice_selected
bloom_question_asked
tracker_opened
period_logged
achievement_unlocked
```

Analytics should avoid collecting unnecessary personal or health information.

---

# 🧪 Testing

The project should eventually contain:

### Unit Tests

```text
Story branching
XP calculation
Achievement conditions
Cycle calculations
Input validation
```

### Widget Tests

```text
Home
Story choices
Tracker
Bloom AI
```

### Integration Tests

```text
Login → Home
Home → Story → Completion
Home → Tracker → Save
Home → Bloom AI
```

---

# 🎨 Design Principles

BloomTale should feel:

* 🌸 Warm
* 🩷 Friendly
* 🌱 Calm
* ✨ Modern
* 👧 Relatable
* 📖 Story-driven
* 🛡️ Safe

Avoid:

* Clinical-looking interfaces
* Excessively childish design
* Large blocks of text
* Overly complicated navigation
* Judgmental language

Use:

* Rounded cards
* Friendly illustrations
* Clear typography
* Generous spacing
* Subtle animations
* Accessible contrast
* Simple navigation

---

# 📦 Assets

Recommended structure:

```text
assets/
├── images/
│   ├── avatar/
│   │   ├── default_avatar.png
│   │   ├── happy.png
│   │   ├── worried.png
│   │   ├── embarrassed.png
│   │   ├── thinking.png
│   │   ├── relieved.png
│   │   ├── confident.png
│   │   ├── sad.png
│   │   └── surprised.png
│   │
│   ├── stories/
│   └── backgrounds/
│
├── icons/
└── animations/
```

Placeholder assets can be used during development.

---

# 🚧 Development Roadmap

## Phase 1 — Foundation

* [ ] Flutter project
* [ ] Clean Architecture
* [ ] Riverpod
* [ ] GoRouter
* [ ] Firebase setup
* [ ] Theme
* [ ] Design system
* [ ] Error handling

## Phase 2 — Onboarding

* [ ] Welcome
* [ ] Onboarding
* [ ] Profile setup
* [ ] Default avatar
* [ ] Meet avatar
* [ ] Home

## Phase 3 — Story Engine

* [ ] Story entity
* [ ] Scene entity
* [ ] Choice entity
* [ ] Story repository
* [ ] Story data source
* [ ] Story library
* [ ] Story scene UI
* [ ] Branching
* [ ] Story completion
* [ ] Progress tracking

## Phase 4 — Bloom AI

* [ ] Chat UI
* [ ] AI repository
* [ ] AI use case
* [ ] Secure backend
* [ ] Safety layer
* [ ] Conversation history

## Phase 5 — Tracker

* [ ] Period logging
* [ ] Mood logging
* [ ] Symptom logging
* [ ] Cycle history
* [ ] Cycle calculations

## Phase 6 — Progress

* [ ] XP
* [ ] Streaks
* [ ] Achievements
* [ ] Progress screen

## Phase 7 — Production Hardening

* [ ] Unit tests
* [ ] Widget tests
* [ ] Integration tests
* [ ] Firestore security rules
* [ ] Accessibility
* [ ] Performance optimization
* [ ] Privacy review
* [ ] Child-safety review

---

# 🔮 Future Roadmap

The architecture is designed to support:

* Multiple avatars
* More story categories
* Advanced personalization
* Parent dashboard
* Educator dashboard
* School/NGO accounts
* Admin content management system
* Multiple languages
* Offline story packs
* Notifications
* More educational modules

These are **not part of the initial MVP**.

---

# 🚀 Getting Started

## Prerequisites

Install:

* Flutter SDK
* Dart SDK
* Android Studio or Xcode
* Git
* Firebase CLI

Verify Flutter:

```bash
flutter doctor
```

---

## Clone the Repository

```bash
git clone <REPOSITORY_URL>
cd bloomtale
```

---

## Install Dependencies

```bash
flutter pub get
```

---

## Firebase Setup

Create a Firebase project and configure:

* Firebase Authentication
* Cloud Firestore
* Firebase Storage
* Cloud Functions/backend as required

Then configure FlutterFire:

```bash
flutterfire configure
```

This generates:

```text
lib/firebase_options.dart
```

Do not commit private credentials or secrets.

---

# ▶️ Run the Application

For development:

```bash
flutter run
```

For a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

---

# 🧪 Run Tests

```bash
flutter test
```

For static analysis:

```bash
flutter analyze
```

Format code:

```bash
dart format .
```

---

# 📋 Development Principles

When contributing to BloomTale:

### 1. Keep features modular

Each major feature should remain independently maintainable.

### 2. Keep UI separate from business logic

Do not put Firebase/business logic directly inside widgets.

### 3. Keep content separate from code

Stories should be data-driven.

### 4. Design for the future

The MVP has one avatar, but don't hard-code the architecture around one avatar.

### 5. Prioritize safety

BloomTale is an educational application for adolescents. Safety and privacy are product requirements, not optional additions.

### 6. Avoid overengineering

Prefer:

```text
Simple + Clean + Extensible
```

over:

```text
Complex + Over-engineered
```

---

# 🌱 MVP Philosophy

BloomTale is intentionally starting small.

Instead of building:

```text
4 avatars
20 story systems
advanced AI
complex cycle prediction
parent dashboards
educator dashboards
```

the MVP focuses on:

```text
       ONE AVATAR
           ↓
    INTERACTIVE STORIES
           ↓
        BLOOM AI
           ↓
     PERIOD TRACKER
           ↓
       PROGRESS
```

The objective is to make the **core learning experience excellent** before expanding the product.

---

# 💖 Product Philosophy

BloomTale should never feel like a textbook.

It should feel like:

> **"I'm learning this together with someone who understands what I'm going through."**

The avatar provides familiarity.

Stories provide context.

Choices provide interaction.

Bloom provides answers.

The tracker provides self-awareness.

Progress provides encouragement.

Together they create the BloomTale experience.

---

# 🌸 BloomTale

### Learn • Explore • Grow

> **Every girl deserves to understand her story.**

Built with ❤️ for a safer, more confident generation of girls.


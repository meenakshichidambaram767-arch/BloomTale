🌸 BloomTaleAI-Powered Adolescent Health & Well-being CompanionInteractive stories. Supportive guidance. Safe, stigma-free health education.BloomTale is an AI-powered educational mobile platform designed to help adolescent girls navigate puberty, menstruation, emotional changes, and hygiene in a safe, relatable, and engaging way.The application transforms clinical and stigmatized health topics into an interactive, visual-novel learning experience powered by character-driven storytelling, an empathetic AI guide, cycle tracking, and gamified progress.1. ProblemMany adolescent girls enter puberty without access to information that is age-appropriate, stigma-free, and emotionally supportive. Existing resources are often clinical, text-heavy, or awkward to navigate, leaving girls confused or embarrassed to seek answers.BloomTale connects health education with relatable interactive media into a continuous, safe learning journey.Code snippetflowchart LR
    A[Interactive Stories & Choices]
    --> B[Reflective Learning]

    B --> C[Bloom AI Guidance]
    C --> D[Cycle & Symptom Tracking]

    D --> E[Self-Awareness & Habit Building]
    E --> F[Milestones & Growth]
2. What BloomTale ProvidesCapabilityPurposeInteractive StoriesLearn body literacy and hygiene through branching visual narrativesBloom AI CompanionSafe, age-appropriate Q&A regarding puberty, emotions, and growing upCycle & Symptom TrackerLog periods, mood patterns, and physical symptoms with private trackingAvatar Expression EngineFoster empathy and visual connection through reactive companion avatarsGrowth & AchievementsGamify learning with non-competitive streaks, XP, and topic milestonesPrivacy-First VaultProtect intimate user health data with client isolation and secure storage3. How BloomTale WorksCode snippetflowchart TD
    A[User Engagement]
    --> B[Choose Module / Story]

    B --> C[Interactive Scene]
    C --> D{Make Decision}

    D --> E[Branching Outcome]
    E --> F[Educational Takeaway]

    F --> G[Award XP & Streaks]

    H[Uncertain or Curious?]
    --> I[Ask Bloom AI]
    I --> J{Safety / Guardrail Check}
    J -->|Approved| K[Supportive Educational Answer]
    J -->|Red Flag / Medical| L[Encourage Trusted Adult / Professional Guidance]
The core principle is:Stories build context. Choices build agency. AI provides answers.4. System ArchitectureCode snippetflowchart TB
    U[Mobile App User]

    subgraph PRESENTATION[Presentation Layer - Flutter]
        UI1[Onboarding & Avatars]
        UI2[Visual Novel Story Player]
        UI3[Bloom AI Chat UI]
        UI4[Cycle & Symptom Logs]
        UI5[Progress & Achievements]
        SM[Riverpod State Management]
    end

    subgraph DOMAIN[Domain Layer - Dart Core]
        UC1[Story Progression UseCases]
        UC2[Bloom Chat UseCases]
        UC3[Cycle Calculation UseCases]
        UC4[Gamification Engine]
    end

    subgraph DATA[Data & Services Layer]
        REPO[Repository Implementations]
        LOCAL[Local Cache & Encrypted Preferences]
    end

    subgraph BACKEND[Cloud Backend & Security]
        AUTH[Firebase Auth]
        FS[(Cloud Firestore)]
        CF[Cloud Functions / Proxy Gate]
        AI[Generative AI / Guardrail Engine]
    end

    U --> PRESENTATION
    PRESENTATION --> DOMAIN
    DOMAIN --> DATA
    DATA --> BACKEND
    DATA --> LOCAL
    CF --> AI
5. Learning & Interaction PipelineStory Engine ArchitectureStories are completely data-driven rather than hard-coded into widget trees.Code snippetflowchart LR
    A[JSON / Firestore Story Spec]
    --> B[Scene Graph Loader]
    --> C[Render Dialog & Avatar Expression]
    --> D{Player Selection}

    D -->|Option A| E[Branch Scenario A]
    D -->|Option B| F[Branch Scenario B]

    E --> G[Persist XP & Completion Status]
    F --> G
Bloom AI Safety & Response FlowBloom acts as a supportive companion, never a clinical diagnostic tool. Private AI API keys are never stored on the mobile device.Code snippetflowchart TD
    A[User Prompts Bloom]
    --> B[Encrypted Transmission to Cloud Function]
    --> C[Prompt Moderation & Child-Safety Screening]
    --> D{Passes Safety Filter?}

    D -->|Violates Guidelines| E[Refusal + Safe Educational Redirect]
    D -->|Medical Diagnosis Asked| F[Disclaimer + Encourage Talking to Trusted Adult]
    D -->|Safe Educational Topic| G[Generate Empathetic, Age-Appropriate Guidance]

    E --> H[Sanitized Response to App]
    F --> H
    G --> H
6. Period & Cycle Tracking FlowThe tracker helps girls understand cyclic changes without algorithmic overreach.Code snippetflowchart LR
    A[Log Cycle Data]
    --> B[Capture Flow, Symptoms & Mood]
    --> C[Store in User-Isolated Firestore Path]
    --> D[Calculate Estimated Window]
    --> E[Render Calendar & Historical View]
Cycle dates are calculated strictly as estimates, framing natural variations as normal and healthy.7. Safety, Privacy & GuardrailsAdolescent data demands the highest standard of protection:Zero Client-Side AI Keys: All generative inference routes through authenticated Cloud Functions.Medical Boundaries: Bloom AI never provides formal medical diagnoses or prescriptions.No Behavioral Advertising: Health logs and chat interactions are strictly decoupled from commercial ad trackers.Row-Level User Isolation: Firestore Security Rules strictly prohibit cross-user document access.Human Escalation Prompts: Explicit triggers direct users to speak with parents, school counselors, or pediatricians when high-risk topics arise.8. Technology StackLayerTechnologiesClient FrontendFlutter (Dart), Google Fonts, Lucide / Cupertino IconsState ManagementRiverpodRoutingGoRouterBackend & DatabaseCloud Functions, Cloud Firestore, Firebase StorageAuthenticationFirebase Authentication (Anonymous & Email auth)AI LayerServer-side LLM Gateway with child-safety prompt orchestrationArchitectureFeature-first Clean Architecture9. Application Modules & Directory LayoutPlaintextlib/
├── app/                  # Routing, themes, root entry
├── core/                 # Shared widgets, network clients, constants
└── features/
    ├── onboarding/       # Setup flow, privacy acceptance, initial intro
    ├── avatar/           # Avatar selector, expressions, assets
    ├── stories/          # Engine, scene parser, visual novel interface
    ├── bloom_ai/         # Chat client, speech bubbles, proxy service
    ├── cycle_tracker/    # Calendar UI, symptom picker, local calculation
    └── progress/         # XP tracker, streaks, achievement badges
10. Verification & Quality StandardsBash# Verify static code quality
flutter analyze

# Execute unit and logic test suites
flutter test

# Reformat code against Dart standards
dart format .
Unit Tests: Branching evaluation logic, XP calculations, cycle estimation logic.Widget Tests: Story choices selection, chat bubble layout, date picker state.Integration Tests: Walkthrough of full story completion and achievement unlock.11. Core PrinciplesStories over lectures: Education succeeds when users relate to characters.AI guides, not prescribes: Bloom is a supportive peer, not a doctor.Privacy by default: Intimate wellness logs belong only to the user.Data-driven content: Stories exist as clean data specs, not hard-coded UI widgets.Encourage trusted real-world connections: Technology supplements, but does not replace, trusted adults and medical professionals.BloomTaleLearn • Explore • Grow

# Authentication Flow

```mermaid
flowchart TD
    %% APP START
    A[Open App] --> S[Splash Screen]
    S --> T{User Logged In?}

    %% SESSION CHECK
    T -- Yes --> U[Get Current User]
    U --> R1[Fetch user record from users table]
    R1 --> V[Check responder_profiles]

    V --> W{Is Responder?}
    W -- Yes --> X[MDRRMO Dashboard + Personal View]
    W -- No --> Y[Resident Dashboard]

    %% NOT LOGGED IN
    T -- No --> B{Has Account?}

    %% LOGIN FLOW
    B -- Yes --> C[Login Page]
    C --> D[Enter Email/Phone + Password or OTP]
    D --> E[Authenticate]
    E --> F{Success?}
    F -- No --> G[Show Error]
    G --> C
    F -- Yes --> U

    %% SIGN-UP FLOW
    B -- No --> H[Sign-Up Page]

    %% STEP 1: BASIC INFO FIRST
    H --> I[Fill Basic Info:
    First Name, Last Name,
    Gender, Address,
    Phone/Email, Password]

    I --> J[Submit Form]

    %% VALIDATION
    J --> K{Valid Input?}
    K -- No --> L[Show Errors]
    L --> H

    %% STEP 2: CREATE ACCOUNT (UNVERIFIED)
    K -- Yes --> M[Create Auth Account - Unverified]
    M --> N[Save Profile to users table]

    %% STEP 3: VERIFICATION AFTER PROFILE
    N --> O[Send OTP or Email Verification]

    O --> P{Verified?}
    P -- No --> Q[Resend]
    Q --> O

    %% STEP 4: FINALIZE
    P -- Yes --> R[Activate Account]
    R --> S1[Auto Login]
    S1 --> U
```

<!-- the system will also use SMS-based OTP for identity verification. -->
<!-- However, for development and cost constraints, only email verification is used in this project. -->
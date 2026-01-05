# 🥋 Python Katas 🥋

>  "I fear not the man who has practiced 10,000 kicks once, but I fear the man who has practiced one kick 10,000 times."
(Bruce Lee)

## What should it be?
- Python is simple to learn, but nuanced to master. The difference between "working code" and "idiomatic code" often lies in details such as async patterns, memory efficiency, and proper exception handling.

- This repository is a collection of **Daily Katas**: small, standalone coding challenges designed to drill specific Python patterns into your muscle memory.

## What should it NOT be? 

- This is not intended to teach coding, having Python as the programming mean. Not even intended to teach you Python **in general**
- The focus should be as much as possible challenging oneself to solve common software engineering problems **the Pythonic way**. 
- Several seasoned developers spent years learning and applying best-practices at prod-grade context. Once they decide to switch to Python, they would face two challenges:
  - Is there a window of knowledge transform here, so that I don't have to throw years of my career out the window and start from zero?
  - If yes, then which parts should I focus on to recognize the mismatches and use them the expected way in the Python land?

## How to Use This Repo
1.  **Pick a Kata:** Navigate to any `XX-kata-yy` folder.
2.  **Read the Challenge:** Open the `README.md` inside that folder. It defines the Goal, the Constraints, and the "Pythonic Patterns" you must use.
3.  **Solve It:** Create your solution in the folder (with virtual environment if needed).
4.  **Reflect:** Compare your solution with the provided "Reference Implementation" (if available) or the core patterns listed.

## Contribution Guidelines

### Have a favorite Python pattern?
1. Create a new folder `XX-your-topic`. (`XX` is an ordinal number)
2. Copy the [README_TEMPLATE.md](./README_TEMPLATE.md) to the new folder as `README.md`
3. Define the challenge: focus on **real-world scenarios** (e.g., handling async timeouts, generators for memory efficiency), and **idiomatic Python**, not just algorithmic puzzles.
4. **Optionally**, create example files or test stubs under the project containing blueprint of the implementation, **as long as you think it reduces confusion and keeps the implementation focused**
5. Submit a PR.

## Katas Index (Grouped)

### 01) Async and Concurrency Patterns
Real-world async/await patterns that prevent blocking, enforce proper cancellation, and handle concurrent operations gracefully.

- [01 - The Fail-Fast Data Aggregator](./01-async-concurrency/01-async-aggregator/)

---

### 02) Performance and Memory Optimization
Drills focused on memory efficiency, generators, itertools, and high-performance data processing.

---

### 03) Web Frameworks and HTTP Patterns
Idiomatic HTTP patterns with Flask/FastAPI, middleware composition, and production hygiene.

---

### 04) Error Handling and Context Managers
Modern Python error handling: custom exceptions, context managers, cleanup patterns, and edge cases.

---

### 05) File Systems and Packaging
Portable imports, testable filesystem code, and proper package structure.

---

### 06) Testing and Quality Gates
Idiomatic Python testing: pytest fixtures, parametrization, mocking, and property-based testing.

- [02 - pytest Table-Driven Tests (Parametrize, Fixtures)](./06-testing-quality/02-pytest-parametrize-fixtures/)

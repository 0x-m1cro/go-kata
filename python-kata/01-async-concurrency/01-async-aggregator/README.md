# Kata 01: The Fail-Fast Data Aggregator

**Target Idioms:** Async/Await Patterns, `asyncio.gather`, Exception Handling, Dependency Injection
**Difficulty:** 🟡 Intermediate

## 🧠 The "Why"
In other languages, you might use threads or `Promise.all` to fetch data in parallel. In Python, seasoned developers often start with threading, but quickly realize the GIL limits true parallelism. For I/O-bound tasks, **async/await is the Pythonic way**.

However, naive use of `asyncio.gather()` has a pitfall: if one task fails, should you wait for all others to complete? **Idiomatic Python fails fast** when you need it to, using proper exception handling and task cancellation.

## 🎯 The Scenario
You are building a **User Dashboard Backend**. To render the dashboard, you must fetch data from two independent, mock microservices:
1.  **Profile Service** (Returns "Name: Alice")
2.  **Order Service** (Returns "Orders: 5")

You need to fetch these in parallel to reduce latency. However, if *either* fails, or if the global timeout is reached, the entire operation must abort immediately to save resources.

## 🛠 The Challenge
Create a `UserAggregator` class and an async method `aggregate(user_id: int)` that orchestrates this fetching.

### 1. Functional Requirements
* [ ] The aggregator must be configurable (timeout, logger) using dependency injection or keyword arguments.
* [ ] Both services must be queried concurrently using `asyncio`.
* [ ] The result should combine both outputs: `"User: Alice | Orders: 5"`.
* [ ] If any service fails or times out, the operation should fail fast.

### 2. The "Pythonic" Constraints (Pass/Fail Criteria)
To pass this kata, you **must** strictly adhere to these rules:

* [ ] **Use async/await:** You must use `async def` and `await` for all I/O operations.
* [ ] **NO blocking calls:** Don't use `time.sleep()`, use `asyncio.sleep()`.
* [ ] **Proper timeout handling:** Use `asyncio.wait_for()` or `asyncio.timeout()` (Python 3.11+) for timeout control.
* [ ] **Fail-fast behavior:** Use `return_exceptions=False` in `asyncio.gather()` OR handle exceptions properly to cancel remaining tasks.
* [ ] **Type hints:** Use type hints for all function signatures (following PEP 484).
* [ ] **Structured logging:** Use Python's `logging` module with proper formatting.
* [ ] **Context manager for cleanup:** If you create custom resources, use context managers (`async with` or `with`).

## 🧪 Self-Correction (Test Yourself)
Run your code against these edge cases:

1.  **The "Slow Poke":**
    * Set your aggregator timeout to `1.0` seconds.
    * Mock one service to take `2.0` seconds.
    * **Pass Condition:** Does your function raise `asyncio.TimeoutError` after exactly ~1s?

2.  **The "Domino Effect":**
    * Mock the Profile Service to raise an exception immediately.
    * Mock the Order Service to take 10 seconds.
    * **Pass Condition:** Does your function raise the exception *immediately*? (If it waits 10s, you failed to implement fail-fast).

3.  **The "Happy Path":**
    * Both services return successfully within timeout.
    * **Pass Condition:** Result should be `"User: Alice | Orders: 5"`.

## 🧪 Example Test Structure
```python
import asyncio
import pytest

@pytest.mark.asyncio
async def test_successful_aggregation():
    # Mock services that succeed
    async def mock_profile(user_id: int) -> str:
        await asyncio.sleep(0.1)
        return f"Name: User{user_id}"
    
    async def mock_orders(user_id: int) -> str:
        await asyncio.sleep(0.1)
        return f"Orders: {user_id * 5}"
    
    # Your aggregator implementation
    aggregator = UserAggregator(
        profile_service=mock_profile,
        order_service=mock_orders,
        timeout=1.0
    )
    
    result = await aggregator.aggregate(1)
    assert "User1" in result
    assert "Orders: 5" in result

@pytest.mark.asyncio
async def test_timeout():
    async def mock_slow(user_id: int) -> str:
        await asyncio.sleep(2.0)
        return "slow"
    
    async def mock_fast(user_id: int) -> str:
        return "fast"
    
    aggregator = UserAggregator(
        profile_service=mock_slow,
        order_service=mock_fast,
        timeout=0.5
    )
    
    with pytest.raises(asyncio.TimeoutError):
        await aggregator.aggregate(1)

@pytest.mark.asyncio
async def test_fail_fast():
    async def mock_failing(user_id: int) -> str:
        raise ValueError("Service failed")
    
    async def mock_slow(user_id: int) -> str:
        await asyncio.sleep(10.0)
        return "slow"
    
    aggregator = UserAggregator(
        profile_service=mock_failing,
        order_service=mock_slow,
        timeout=15.0
    )
    
    # Should fail immediately, not wait 10 seconds
    import time
    start = time.time()
    with pytest.raises(ValueError):
        await aggregator.aggregate(1)
    elapsed = time.time() - start
    assert elapsed < 1.0, "Should fail fast, not wait for slow service"
```

## 📚 Resources
* [Python asyncio Documentation](https://docs.python.org/3/library/asyncio.html)
* [asyncio.gather()](https://docs.python.org/3/library/asyncio-task.html#asyncio.gather)
* [PEP 484 - Type Hints](https://www.python.org/dev/peps/pep-0484/)
* [Real Python: Async IO in Python](https://realpython.com/async-io-python/)

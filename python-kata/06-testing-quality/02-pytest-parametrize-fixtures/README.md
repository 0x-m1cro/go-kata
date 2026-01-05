# Kata 02: pytest Table-Driven Tests (Parametrize, Fixtures)

**Target Idioms:** pytest Parametrization, Fixtures, Type Hints, Property-Based Testing
**Difficulty:** 🟡 Intermediate

## 🧠 The "Why"
Developers often write:
- repetitive tests with copy-paste,
- unsafe test setup/teardown,
- no coverage for edge cases,
- tests that don't clearly show what failed.

Idiomatic Python testing with pytest is:
- table-driven using `@pytest.mark.parametrize`,
- DRY (Don't Repeat Yourself) with fixtures,
- readable failures with clear test names,
- comprehensive edge case coverage.

## 🎯 The Scenario
You're implementing a header name sanitizer for an HTTP library:
- `def normalize_header_key(s: str) -> str`
  
Rules:
- Only ASCII letters, digits, and hyphens allowed
- Normalize to canonical HTTP header form (e.g., `content-type` -> `Content-Type`)
- Raise `ValueError` for invalid input
- Empty strings are invalid
- Leading/trailing hyphens are invalid

## 🛠 The Challenge
Write:
1. The implementation of `normalize_header_key`, and
2. A comprehensive test suite that proves it's solid.

### 1. Functional Requirements
- [ ] Canonicalize valid inputs (e.g., `content-type` -> `Content-Type`)
- [ ] Handle single-word headers (e.g., `host` -> `Host`)
- [ ] Handle multi-word headers (e.g., `x-api-key` -> `X-Api-Key`)
- [ ] Reject invalid characters (raise `ValueError`)
- [ ] Reject empty strings (raise `ValueError`)
- [ ] Reject strings with leading/trailing hyphens (raise `ValueError`)
- [ ] Be idempotent (calling twice gives same result)

### 2. The "Pythonic" Constraints (Pass/Fail Criteria)
- [ ] Tests must be **table-driven** using `@pytest.mark.parametrize`.
- [ ] Use **pytest fixtures** for any shared setup (if applicable).
- [ ] Tests must have **descriptive names** or use `ids` parameter in parametrize.
- [ ] Include **edge cases**: empty string, special chars, unicode, very long strings.
- [ ] Use **type hints** in both implementation and tests.
- [ ] **Optional but recommended**: Add property-based tests using `hypothesis` to fuzz the function.

## 🧪 Self-Correction (Test Yourself)
- **If you copy-paste test functions:** Use `@pytest.mark.parametrize` instead.
- **If test failures are unclear:** Add `ids` parameter or better test names.
- **If you miss edge cases:** Consider property-based testing with `hypothesis`.

## 🧪 Example Test Structure

```python
import pytest
from typing import List, Tuple

def normalize_header_key(s: str) -> str:
    """
    Normalize HTTP header key to canonical form.
    
    Args:
        s: Header key to normalize
        
    Returns:
        Normalized header key
        
    Raises:
        ValueError: If input is invalid
    """
    # Your implementation here
    pass


class TestNormalizeHeaderKey:
    """Test suite for normalize_header_key function."""
    
    @pytest.mark.parametrize(
        "input_str,expected",
        [
            ("content-type", "Content-Type"),
            ("Content-Type", "Content-Type"),  # idempotent
            ("CONTENT-TYPE", "Content-Type"),
            ("host", "Host"),
            ("x-api-key", "X-Api-Key"),
            ("x-custom-header-name", "X-Custom-Header-Name"),
            ("accept", "Accept"),
        ],
        ids=[
            "lowercase_hyphenated",
            "already_canonical",
            "uppercase_hyphenated",
            "single_word",
            "three_words",
            "four_words",
            "single_word_common",
        ]
    )
    def test_valid_headers(self, input_str: str, expected: str):
        """Test normalization of valid header keys."""
        assert normalize_header_key(input_str) == expected
    
    @pytest.mark.parametrize(
        "invalid_input,error_match",
        [
            ("", "empty"),
            ("content type", "invalid character"),  # space
            ("content_type", "invalid character"),  # underscore
            ("content@type", "invalid character"),  # @
            ("-content-type", "leading hyphen"),
            ("content-type-", "trailing hyphen"),
            ("con--tent", "consecutive hyphens"),  # optional constraint
            ("123", "starts with digit"),  # optional constraint
        ],
        ids=[
            "empty_string",
            "contains_space",
            "contains_underscore",
            "contains_at_sign",
            "leading_hyphen",
            "trailing_hyphen",
            "consecutive_hyphens",
            "starts_with_digit",
        ]
    )
    def test_invalid_headers(self, invalid_input: str, error_match: str):
        """Test that invalid inputs raise ValueError."""
        with pytest.raises(ValueError, match=error_match):
            normalize_header_key(invalid_input)
    
    def test_idempotent(self):
        """Test that normalizing twice gives same result."""
        headers = ["content-type", "x-api-key", "host"]
        for header in headers:
            normalized_once = normalize_header_key(header)
            normalized_twice = normalize_header_key(normalized_once)
            assert normalized_once == normalized_twice


# Optional: Property-based testing with hypothesis
# pip install hypothesis
try:
    from hypothesis import given, strategies as st
    
    @given(st.text(alphabet=st.characters(whitelist_categories=('Lu', 'Ll')), min_size=1))
    def test_property_only_letters_never_raises(s: str):
        """Property: strings with only letters should never raise."""
        try:
            result = normalize_header_key(s)
            # Result should only contain letters and hyphens
            assert all(c.isalpha() or c == '-' for c in result)
        except ValueError:
            # If it raises, ensure it's for a good reason
            assert '-' in s or s == ""
            
except ImportError:
    pass  # hypothesis not installed
```

## 📚 Resources
* [pytest parametrize documentation](https://docs.pytest.org/en/stable/how-to/parametrize.html)
* [pytest fixtures](https://docs.pytest.org/en/stable/how-to/fixtures.html)
* [hypothesis property-based testing](https://hypothesis.readthedocs.io/)
* [PEP 484 - Type Hints](https://www.python.org/dev/peps/pep-0484/)

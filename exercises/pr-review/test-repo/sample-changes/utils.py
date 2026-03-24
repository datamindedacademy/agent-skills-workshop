import json
import re


def validate_email(email):
    """Check if an email address looks valid."""
    pattern = r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$"
    return bool(re.match(pattern, email))


def format_user(user):
    """Format a user dict for API response."""
    # BUG: Doesn't check if user is None before accessing attributes
    return {
        "id": user["id"],
        "name": user["name"].strip().title(),
        "email": user["email"].lower(),
    }


def sanitize_input(text):
    """Remove potentially dangerous characters from input."""
    return re.sub(r"[<>&\"']", "", text)

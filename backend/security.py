import base64
import hashlib
import hmac
import os

ALGORITHM = "sha256"
ITERATIONS = 310_000
SALT_BYTES = 16


def hash_password(password: str) -> str:
    salt = os.urandom(SALT_BYTES)

    derived_key = hashlib.pbkdf2_hmac(
        ALGORITHM,
        password.encode("utf-8"),
        salt,
        ITERATIONS,
    )

    return (
        f"pbkdf2_{ALGORITHM}$"
        f"{ITERATIONS}$"
        f"{base64.b64encode(salt).decode('ascii')}$"
        f"{base64.b64encode(derived_key).decode('ascii')}"
    )


def verify_password(password: str, stored_password: str) -> bool:
    try:
        algorithm, iterations, salt_b64, hash_b64 = stored_password.split("$")

        if algorithm != f"pbkdf2_{ALGORITHM}":
            return False

        salt = base64.b64decode(salt_b64)
        expected_hash = base64.b64decode(hash_b64)

        actual_hash = hashlib.pbkdf2_hmac(
            ALGORITHM,
            password.encode("utf-8"),
            salt,
            int(iterations),
        )

        return hmac.compare_digest(actual_hash, expected_hash)

    except (ValueError, TypeError):
        return False


def is_password_hash(value: str) -> bool:
    return value.startswith(f"pbkdf2_{ALGORITHM}$")
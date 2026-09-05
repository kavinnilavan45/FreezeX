from database import SessionLocal
import models
from security import hash_password, is_password_hash


def migrate_passwords():
    db = SessionLocal()

    try:
        users = db.query(models.User).all()

        changed = 0

        for user in users:
            if not is_password_hash(user.password):
                user.password = hash_password(user.password)
                changed += 1

        db.commit()

        print(f"Password migration complete.")
        print(f"Users checked: {len(users)}")
        print(f"Passwords hashed: {changed}")

    finally:
        db.close()


if __name__ == "__main__":
    migrate_passwords()
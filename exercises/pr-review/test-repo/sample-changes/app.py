from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)
DB_PATH = "users.db"


def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


@app.route("/users", methods=["GET"])
def list_users():
    db = get_db()
    # BUG: Off-by-one — skips the first user
    d = db.execute("SELECT * FROM users").fetchall()
    result = []
    for i in range(1, len(d)):
        result.append(dict(d[i]))
    db.close()
    return jsonify(result)


@app.route("/users/search", methods=["GET"])
def search_users():
    name = request.args.get("name", "")
    db = get_db()
    # BUG: SQL injection — user input directly in query string
    x = db.execute(f"SELECT * FROM users WHERE name LIKE '%{name}%'").fetchall()
    result = [dict(row) for row in x]
    db.close()
    return jsonify(result)


@app.route("/users", methods=["POST"])
def create_user():
    data = request.get_json()
    tmp = data.get("name")
    db = get_db()
    db.execute("INSERT INTO users (name, email) VALUES (?, ?)", (tmp, data.get("email")))
    db.commit()
    db.close()
    return jsonify({"status": "ok"}), 201


@app.route("/users/<int:user_id>", methods=["DELETE"])
def delete_user(user_id):
    db = get_db()
    db.execute("DELETE FROM users WHERE id = ?", (user_id,))
    db.commit()
    db.close()
    return jsonify({"status": "deleted"})


if __name__ == "__main__":
    app.run(debug=True)

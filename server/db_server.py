from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
CORS(app)  # CORS 설정: 모바일 앱이 서버와 통신할 수 있도록 허용

# SQLite 데이터베이스 사용
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///server_database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# 사용자 테이블
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String, unique=True, nullable=False)
    password = db.Column(db.String, nullable=False)  # 해싱된 비밀번호 저장
    role = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)

# 출퇴근 기록 테이블
class Attendance(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)
    date = db.Column(db.String, nullable=False)
    check_in_time = db.Column(db.String)
    check_out_time = db.Column(db.String)

# 📌 회원가입 API (비밀번호 암호화 적용)
@app.route('/auth/register', methods=['POST'])
def register():
    data = request.json
    hashed_password = generate_password_hash(data['password'])  # 비밀번호 암호화
    new_user = User(
        email=data['email'],
        password=hashed_password,
        role=data['role'],
        name=data['name']
    )
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User registered successfully!"}), 201

# 📌 로그인 API (비밀번호 검증)
@app.route('/auth/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(email=data['email']).first()
    if user and check_password_hash(user.password, data['password']):
        return jsonify({"user_id": user.id, "name": user.name})
    return jsonify({"error": "Invalid credentials"}), 401

# 📌 모든 사용자 정보 가져오기
@app.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    user_list = [
        {"id": user.id, "email": user.email, "name": user.name, "role": user.role}
        for user in users
    ]
    return jsonify(user_list)

# 📌 출퇴근 기록 업데이트
@app.route('/attendance/update', methods=['POST'])
def update_attendance():
    data = request.json
    user_id = data['user_id']
    action = data['action']

    if action == "check_in":
        new_attendance = Attendance(user_id=user_id, date="2025-02-18", check_in_time="09:00")
        db.session.add(new_attendance)
    else:
        attendance = Attendance.query.filter_by(user_id=user_id, date="2025-02-18").first()
        if attendance:
            attendance.check_out_time = "18:00"
    db.session.commit()
    return jsonify({"message": "Attendance updated"}), 200

# 서버 실행
if __name__ == "__main__":
    with app.app_context():
        db.create_all()  # 데이터베이스 테이블 생성
    app.run(host="0.0.0.0", port=5000, debug=True)

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime
import os

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///server_database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String, unique=True, nullable=False)
    password = db.Column(db.String, nullable=False)
    role = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)

class Attendance(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)
    date = db.Column(db.String, nullable=False)
    check_in_time = db.Column(db.String, default="--:--")
    check_out_time = db.Column(db.String, default="--:--")
    weekly_attendance = db.Column(db.Boolean, default=False)

class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)
    current_location = db.Column(db.String, nullable=False)
    category = db.Column(db.String, nullable=False)

#회원가입 요청하는 쿼리
@app.route('/auth/register', methods=['POST'])
def register():
    data = request.json
    new_user = User(
        email=data['email'],
        password=data['password'],
        role=data['role'],
        name=data['name']
    )
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User registered successfully!"}), 201

#로그인 요청하는 쿼리
@app.route('/auth/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(email=data['email']).first()
    if user:
        return jsonify({"user_id": user.id})
    return jsonify({"error": "Invalid credentials"}), 401

#HomeScreen의 출퇴근 버튼 동작시 데이터 저장하는 쿼리
@app.route('/attendance/update', methods=['POST'])
def update_attendance():
    data = request.json
    user_id = data['user_id']
    action = data['action']
    current_time = datetime.now().strftime("%H:%M")
    today_date = datetime.now().strftime("%Y-%m-%d")
    
    attendance = Attendance.query.filter_by(user_id=user_id, date=today_date).first()
    if action == "check_in":
        if not attendance:
            new_attendance = Attendance(
                user_id=user_id,
                date=today_date,
                check_in_time=current_time,
                weekly_attendance=True
            )
            db.session.add(new_attendance)
        else:
            attendance.check_in_time = current_time
            attendance.weekly_attendance = True
    elif action == "check_out" and attendance:
        attendance.check_out_time = current_time
    
    db.session.commit()
    return jsonify({"message": "Attendance updated", "time": current_time}), 200

@app.route('/home/<int:user_id>', methods=['GET'])
def get_home_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404  # ❌ 유저가 없을 경우

    today_date = datetime.now().strftime("%Y-%m-%d")
    attendance = Attendance.query.filter_by(user_id=user.id, date=today_date).first()

    return jsonify({
        "id": user.id,
        "name": user.name,
        "role": user.role,
        "is_checked_in": bool(attendance and attendance.check_in_time != "--:--"),
        "check_in_time": attendance.check_in_time if attendance else "--:--",
        "check_out_time": attendance.check_out_time if attendance else "--:--",
    }), 200



@app.route('/group/users', methods=['GET'])
def get_group_users():
    users = User.query.all()  # 모든 사용자 정보 가져오기
    result = []

    for user in users:
        attendance = Attendance.query.filter_by(user_id=user.id).order_by(Attendance.date.desc()).first()
        location = Location.query.filter_by(user_id=user.id).first()
        
        result.append({
            "id": user.id,
            "name": user.name,
            "role": user.role,
            "category": location.category if location else "Unknown",
            "check_in_time": attendance.check_in_time if attendance else "--:--",
            "check_out_time": attendance.check_out_time if attendance else "--:--",
        })

    return jsonify(result), 200


@app.route('/location/update', methods=['POST'])
def update_location():
    data = request.json
    user_id = data['user_id']
    current_location = data['current_location']
    category = data['category']
    
    location = Location.query.filter_by(user_id=user_id).first()
    if location:
        location.current_location = current_location
        location.category = category
    else:
        new_location = Location(user_id=user_id, current_location=current_location,category=category)
        db.session.add(new_location)
    
    db.session.commit()
    return jsonify({"message": "Location updated"}), 200

@app.route('/location/category/<int:user_id>', methods=['GET'])
def get_location_category(user_id):
    location = Location.query.filter_by(user_id=user_id).first()
    if location:
        return jsonify({"category": location.category}), 200
    else:
        return jsonify({"error": "Location not found"}), 404

@app.route('/attendance/weekly/<int:user_id>', methods=['GET'])
def get_weekly_attendance(user_id):
    weekly_attendance_records = Attendance.query.filter_by(user_id=user_id).all()
    
    weekly_timeline = [
        {
            "date": record.date,
            "weekly_attendance": record.weekly_attendance
        } for record in weekly_attendance_records
    ]
    return jsonify(weekly_timeline), 200

@app.route('/users', methods=['GET'])
def get_all_users():
    users = User.query.all()
    result = []

    for user in users:
        result.append({
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role
        })

    return jsonify(result), 200
# 📌 그룹 스크린: 모든 유저의 출석 정보를 가져옴
@app.route('/group/attendance', methods=['GET'])
def get_group_attendance():
    """모든 유저의 출석 정보를 가져오는 API"""
    users = User.query.all()
    today_date = datetime.now().strftime("%Y-%m-%d")
    result = []

    for user in users:
        attendance = Attendance.query.filter_by(user_id=user.id, date=today_date).first()
        result.append({
            "id": user.id,
            "name": user.name,
            "role": user.role,
            "check_in_time": attendance.check_in_time if attendance else "--:--",
            "check_out_time": attendance.check_out_time if attendance else "--:--"
        })

    return jsonify(result), 200
@app.route('/locations', methods=['GET'])
def get_all_locations():
    """모든 유저들의 위치 정보를 가져오는 API"""
    locations = Location.query.all()
    result = []

    for location in locations:
        user = User.query.get(location.user_id)
        result.append({
            "user_id": location.user_id,
            "name": user.name if user else "Unknown",
            "current_location": location.current_location,
            "category": location.category
        })

    return jsonify(result), 200
@app.route('/location/<int:user_id>', methods=['GET'])
def get_user_location(user_id):
    """특정 유저의 위치 정보를 가져오는 API"""
    location = Location.query.filter_by(user_id=user_id).first()
    
    if location:
        return jsonify({
            "user_id": location.user_id,
            "current_location": location.current_location,
            "category": location.category
        }), 200
    else:
        return jsonify({"error": "Location not found"}), 404

# 🔥 기존 데이터베이스 파일 삭제 후 다시 생성
db_path = "server_database.db"
if os.path.exists(db_path):
    os.remove(db_path)
    print("🔥 기존 데이터베이스 삭제 완료!")

with app.app_context():
    db.create_all()  # 새 데이터베이스 생성
    print("✅ 새 데이터베이스 생성 완료!")
    
if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=5000, debug=True)

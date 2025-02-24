from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime
import os

# ✅ SQLAlchemy 인스턴스 생성 (앱 미등록 상태)
db = SQLAlchemy()

# ✅ Flask 앱 생성
app = Flask(__name__)
CORS(app)

# ✅ DB 설정
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///server_database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JSON_AS_ASCII'] = False

# ✅ 앱과 SQLAlchemy 연결
db.init_app(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String, unique=True, nullable=False)
    password = db.Column(db.String, nullable=False)
    role = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)

class Attendance(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)
    location_id = db.Column(db.Integer, db.ForeignKey('location.id', ondelete="SET NULL"), nullable=True)  # ✅ 근무지 추가
    date = db.Column(db.String, nullable=False)
    check_in_time = db.Column(db.String, default="--:--")
    check_out_time = db.Column(db.String, default="--:--")
    weekly_attendance = db.Column(db.Boolean, default=False)


class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)
    current_location = db.Column(db.String, nullable=False)
    category = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)  # 🔥 위치 추가 시간 저장


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
    user_id = data.get('user_id')
    action = data.get('action')
    location_id = data.get('location_id')  # ✅ 추가된 location_id 필드

    current_time = datetime.now().strftime("%H:%M")
    today_date = datetime.now().strftime("%Y-%m-%d")

    attendance = Attendance.query.filter_by(user_id=user_id, date=today_date).first()

    if action == "check_in":
        if not attendance:
            new_attendance = Attendance(
                user_id=user_id,
                date=today_date,
                check_in_time=current_time,
                weekly_attendance=True,
                location_id=location_id  # ✅ 출근한 근무지 저장
            )
            db.session.add(new_attendance)
        else:
            attendance.check_in_time = current_time
            attendance.weekly_attendance = True
            attendance.location_id = location_id  # ✅ 기존 출근 기록 수정

    elif action == "check_out" and attendance:
        attendance.check_out_time = current_time

    db.session.commit()
    return jsonify({"message": "Attendance updated"}), 200




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
    print(f"📡 서버에서 받은 데이터: {data}")  # 🔥 디버깅용 출력

    user_id = data.get('user_id')
    current_location = data.get('current_location')
    category = data.get('category')

    if not user_id or not current_location or not category:
        return jsonify({"error": "Missing data"}), 400

    # ✅ 같은 user_id + 같은 category의 데이터가 있는지 확인
    existing_location = Location.query.filter_by(user_id=user_id, category=category).first()

    if existing_location:
        # ✅ 같은 카테고리가 있으면 기존 데이터를 덮어쓰기
        existing_location.current_location = current_location
        existing_location.created_at = datetime.utcnow()
        print(f"🔄 기존 위치 덮어쓰기 완료: user_id={user_id}, category={category}, location={current_location}")
    else:
        # ✅ 같은 카테고리가 없으면 새로 추가
        new_location = Location(
            user_id=user_id,
            current_location=current_location,
            category=category
        )
        db.session.add(new_location)
        print(f"✅ 새로운 위치 추가: user_id={user_id}, category={category}, location={current_location}")

    db.session.commit()
    return jsonify({"message": "Location updated successfully!"}), 200


@app.route('/location/category/<int:user_id>', methods=['GET'])
def get_location_category(user_id):
    location = Location.query.filter_by(user_id=user_id).first()
    
    if location:
        return jsonify({"category": location.category}), 200
    else:
        # ✅ 기본 카테고리 제공 (데이터가 없을 경우)
        return jsonify({"category": "Unknown"}), 200

#승민아 여기야 섹스
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



#그룹 스크린에서 모든 사용자의 workplace뿌려줄떄 사용
@app.route('/locations', methods=['GET'])
def get_all_locations():
    """모든 유저들의 위치 정보를 가져오는 API"""
    locations = Location.query.all()
    result = [
        {
            "user_id": location.user_id,
            "name": User.query.get(location.user_id).name if User.query.get(location.user_id) else "Unknown",
            "current_location": location.current_location,  # ✅ 유니코드로 저장되더라도 상관없음
            "category": location.category
        }
        for location in locations
    ]

    return jsonify(result), 200  # ✅ Flask 기본 설정을 활용해 UTF-8 유지

#홈스크린에서 workplace뿌려줄떄 사용
@app.route('/location/<int:user_id>', methods=['GET'])
def get_location(user_id):
    locations = Location.query.filter_by(user_id=user_id).all()

    if not locations:
        return jsonify({"user_id": user_id, "locations": []}), 200

    result = [
        {
            "location_id": loc.id,
            "current_location": loc.current_location,
            "category": loc.category,
            "created_at": loc.created_at.strftime('%Y-%m-%d %H:%M:%S')  # ✅ 추가된 시간 포함
        } for loc in locations
    ]

    return jsonify({"user_id": user_id, "locations": result}), 200



# ✅ 특정 위치 삭제 API 추가
@app.route('/location/delete', methods=['POST'])
def delete_location():
    data = request.json
    user_id = data.get('user_id')
    location_id = data.get('location_id')

    if not user_id or not location_id:
        return jsonify({"error": "Missing data"}), 400

    location = Location.query.filter_by(id=location_id, user_id=user_id).first()
    if not location:
        return jsonify({"error": "Location not found"}), 404

    db.session.delete(location)
    db.session.commit()
    
    return jsonify({"message": "Location deleted"}), 200

import requests

@app.route('/group/attendance', methods=['GET'])
def get_group_attendance():
    """모든 유저의 출석 정보를 가져오는 API (users/all 기반)"""
    users_all_url = "http://220.69.203.99:5000/users/all"  # ✅ users/all 가져오기
    response = requests.get(users_all_url)

    if response.status_code == 200:
        users_data = response.json()
        
        # 🔥 디버깅: users/all 데이터 확인
        print("🔥 users/all 데이터:", users_data)

        result = []
        for user in users_data:
            attendance = user.get("attendance", {})
            category = attendance.get("workplace", "Unknown")  # ✅ 강제 업데이트

            result.append({
                "id": user["user_id"],
                "name": user["name"],
                "role": user["role"],
                "category": category,  # ✅ users/all에서 가져온 workplace 값 사용
                "check_in_time": attendance.get("check_in_time", "--:--"),
                "check_out_time": attendance.get("check_out_time", "--:--")
            })

        return jsonify(result), 200
    else:
        return jsonify({"error": "Failed to fetch users/all"}), 500




#진작 이거로 할걸 ㅋㅋ
@app.route('/users/all', methods=['GET'])
def get_all_users_info():
    """모든 유저의 상세 정보를 가져오는 API"""
    users = User.query.all()
    result = []

    for user in users:
        # 유저 출석 정보 가져오기 (가장 최근 출석 데이터)
        attendance = Attendance.query.filter_by(user_id=user.id).order_by(Attendance.date.desc()).first()
        
        # ✅ 유저의 출석 근무지 정보 가져오기 (출근 기록이 있으면 가져옴)
        workplace_name = None
        if attendance and attendance.location_id:
            workplace = Location.query.get(attendance.location_id)
            workplace_name = workplace.category if workplace else "Unknown"

        # 유저의 모든 Workplace 가져오기
        workplaces = Location.query.filter_by(user_id=user.id).all()
        workplace_list = [
            {
                "location_id": loc.id,
                "current_location": loc.current_location,
                "category": loc.category,
                "created_at": loc.created_at.strftime('%Y-%m-%d %H:%M:%S')
            }
            for loc in workplaces
        ]

        user_data = {
            "user_id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role,
            "attendance": {
                "date": attendance.date if attendance else "N/A",
                "check_in_time": attendance.check_in_time if attendance else "--:--",
                "check_out_time": attendance.check_out_time if attendance else "--:--",
                "workplace": workplace_name  # ✅ 출석한 근무지 추가
            },
            "workplaces": workplace_list
        }

        # 🔥 디버깅 로그 추가
        print(f"🔥 users/all - {user.name} 출근지: {user_data['attendance']['workplace']}")

        result.append(user_data)

    return jsonify(result), 200




if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=5000, debug=True)

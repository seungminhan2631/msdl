from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash

from datetime import datetime
import os
import base64

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

# ✅ 이미지 저장 폴더 설정
UPLOAD_FOLDER = "static/profile_image"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String, unique=True, nullable=False)
    password = db.Column(db.String, nullable=False)
    role = db.Column(db.String, nullable=False)
    name = db.Column(db.String, nullable=False)
    profile_image = db.Column(db.String, nullable=True)

class Attendance(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)
    location_id = db.Column(db.Integer, db.ForeignKey('location.id', ondelete="SET NULL"), nullable=True) 
    date = db.Column(db.String, nullable=False)
    check_in_time = db.Column(db.String, default="--:--")
    check_out_time = db.Column(db.String, default="--:--")
    weekly_attendance = db.Column(db.Boolean, default=False)
    workplace_category = db.Column(db.String, nullable=True)

class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)
    current_location = db.Column(db.String, nullable=False)
    category = db.Column(db.String, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)  

@app.route('/auth/register', methods=['POST'])
def register():
    data = request.json
    existing_user = User.query.filter_by(email=data['email']).first()
    
    if existing_user:
        return jsonify({"error": "Email already registered"}), 400  

# 비밀번호 해싱( 보안 )
    hashed_password = generate_password_hash(data['password'])  

    new_user = User(
        email=data['email'],
        password=hashed_password, 
        role=data['role'],
        name=data['name']
    )
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User registered successfully!"}), 201

@app.route('/auth/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(email=data['email']).first()
     # 해싱 비밀번호 검증
    if user and check_password_hash(user.password, data['password']):  
        return jsonify({
            "user_id": user.id,
            "role": user.role if user.role else "Unknown", 
            "name": user.name if user.name else "Unknown"
        }), 200

    return jsonify({"error": "Invalid email or password"}), 401  

# ✅ 비밀번호 변경 API
@app.route('/auth/update_password', methods=['POST'])
def update_password():
    data = request.json
    user_id = data.get('user_id')
    new_password = data.get('new_password')

    if not user_id or not new_password:
        return jsonify({"error": "Missing required fields"}), 400

    user = User.query.get(user_id)

    if not user:
        return jsonify({"error": "User not found"}), 404

    # 🔹 기존 비밀번호 확인 후 변경
    if not check_password_hash(user.password_hash):
        return jsonify({"error": "Incorrect old password"}), 401

    user.password_hash = generate_password_hash(new_password)  # 새 비밀번호 암호화 후 저장
    db.session.commit()

    return jsonify({"message": "Password updated successfully"}), 200

#HomeScreen의 출퇴근 버튼 동작시 데이터 저장하는 쿼리
@app.route('/attendance/update', methods=['POST'])
def update_attendance():
    data = request.json
    user_id = data.get('user_id')
    action = data.get('action')
    workplace = data.get('workplace') 
    if not user_id or not action:
        return jsonify({"error": "Missing required fields"}), 400

    current_time = datetime.now().strftime("%H:%M")
    today_date = datetime.now().strftime("%Y-%m-%d")
    attendance = Attendance.query.filter_by(user_id=user_id, date=today_date).first()
    try:
        if action == "check_in":
            if not attendance:
                new_attendance = Attendance(
                    user_id=user_id,
                    date=today_date,
                    check_in_time=current_time,
                    weekly_attendance=True,
                    workplace_category=workplace  
                )
                db.session.add(new_attendance)
            else:
                attendance.check_in_time = current_time
                attendance.weekly_attendance = True
                attendance.workplace_category = workplace

        elif action == "check_out" and attendance:
            attendance.check_out_time = current_time
        db.session.commit()
        return jsonify({"message": "Attendance updated", "time": current_time, "workplace": workplace}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500



#is_checked_in의 true / false로  출퇴근을 관리
@app.route('/home/<int:user_id>', methods=['GET'])
def get_home_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404  
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
    user_id = data.get('user_id')
    current_location = data.get('current_location')
    category = data.get('category')

    if not user_id or not current_location or not category:
        return jsonify({"error": "Missing data"}), 400

    # user_id에 같은 카테고리가 있는지 체크
    existing_location = Location.query.filter_by(user_id=user_id, category=category).first()

    if existing_location:
        # 같은 카테고리가 있으면 덮어쓰기
        existing_location.current_location = current_location
        existing_location.created_at = datetime.utcnow()
    else:
        # 같은 카테고리가 없으면 새로 추가
        new_location = Location(
            user_id=user_id,
            current_location=current_location,
            category=category
        )
        db.session.add(new_location)

    db.session.commit()
    return jsonify({"message": "Location updated successfully!"}), 200


@app.route('/location/category/<int:user_id>', methods=['GET'])
def get_location_category(user_id):
    location = Location.query.filter_by(user_id=user_id).first()
    
    if location:
        return jsonify({"category": location.category}), 200
    else:
        return jsonify({"category": "Unknown"}), 200
    

@app.route('/attendance/weekly/<int:user_id>', methods=['GET'])
def get_weekly_attendance(user_id):
    weekly_attendance_records = Attendance.query.filter_by(user_id=user_id).all()

    weekly_timeline = [
        {
            "id":user_id,
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



# # ✅ 특정 위치 삭제 API 추가
# @app.route('/location/delete', methods=['POST'])
# def delete_location():
#     data = request.json
#     user_id = data.get('user_id')
#     location_id = data.get('location_id')

#     if not user_id or not location_id:
#         return jsonify({"error": "Missing data"}), 400

#     location = Location.query.filter_by(id=location_id, user_id=user_id).first()
#     if not location:
#         return jsonify({"error": "Location not found"}), 404

#     db.session.delete(location)
#     db.session.commit()
    
#     return jsonify({"message": "Location deleted"}), 200

# import requests

# @app.route('/group/attendance', methods=['GET'])
# def get_group_attendance():
#     """모든 유저의 출석 정보를 가져오는 API (users/all 기반)"""
#     users_all_url = "http://220.69.203.99:5000/users/all"  # ✅ users/all 가져오기
#     response = requests.get(users_all_url)

#     if response.status_code == 200:
#         users_data = response.json()
        
#         # 🔥 디버깅: users/all 데이터 확인
#         print("🔥 users/all 데이터:", users_data)

#         result = [
#             {
#                 "id": user["user_id"],
#                 "name": user["name"],
#                 "role": user["role"],
#                 "category": user["attendance"].get("workplace", "Unknown"),  # ✅ users/all에서 가져옴
#                 "check_in_time": user["attendance"].get("check_in_time", "--:--"),
#                 "check_out_time": user["attendance"].get("check_out_time", "--:--")
#             }
#             for user in users_data
#         ]

#         return jsonify(result), 200
#     else:
#         return jsonify({"error": "Failed to fetch users/all"}), 500
    

@app.route('/upload_profile_image', methods=['POST'])
def upload_profile_image():
    data = request.json
    user_id = data.get("user_id")
    image_data = data.get("image")

    if not user_id or not image_data:
        return jsonify({"error": "Missing user_id or image"}), 400

    try:
        # 사용자별 폴더 생성
        user_folder = f"{UPLOAD_FOLDER}/{user_id}"
        os.makedirs(user_folder, exist_ok=True)

        # 이미지 파일 확장자 감지
        image_format = image_data.split(";")[0].split("/")[1]  
        if image_format not in ["jpeg", "png", "jpg"]:
            return jsonify({"error": "Unsupported image format"}), 400
        # 유저id별로 folder에 이미지 저장
        image_path = f"{user_folder}/profile.{image_format}"
        with open(image_path, "wb") as f:
            f.write(base64.b64decode(image_data.split(",")[1]))
        user = User.query.get(user_id)
        if user:
            user.profile_image = f"/{image_path}"  
            db.session.commit()
        return jsonify({"message": "Image uploaded successfully", "image_url": user.profile_image}), 200

    except Exception as e:
        return jsonify({"error": f"Failed to upload image: {str(e)}"}), 500

@app.route('/get_profile_image/<int:user_id>', methods=['GET'])
def get_profile_image(user_id):
    user_folder = f"{UPLOAD_FOLDER}/{user_id}"
    
    for ext in ["jpg", "png", "jpeg"]:
        image_path = f"{user_folder}/profile.{ext}"
        if os.path.exists(image_path):
            return jsonify({"image_url": f"/{image_path}"}), 200
    return jsonify({"error": "No image found"}), 404

@app.route('/static/profile_images/<filename>')
def serve_profile_image(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)



@app.route('/users/all', methods=['GET'])
def get_all_users_info():
    #모든 유저 정보
    users = User.query.all()
    result = []
    for user in users:
        # 유저 출석 정보 가져오기 (가장 최근 출석 데이터)
        attendance = Attendance.query.filter_by(user_id=user.id).order_by(Attendance.date.desc()).first()
        
        # 출석 테이블의 workplace 가져오기
        workplace_name = attendance.workplace_category if attendance and attendance.workplace_category else "Unknown"

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

        result.append({
            "user_id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role,
            "password_hash": user.password, #해싱된 비밀번호 체크
            "attendance": {
                "date": attendance.date if attendance else "N/A",
                "check_in_time": attendance.check_in_time if attendance else "--:--",
                "check_out_time": attendance.check_out_time if attendance else "--:--",
                "workplace": workplace_name  
            },
            "workplaces": workplace_list
        })
    return jsonify(result), 200





if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=5000, debug=True)

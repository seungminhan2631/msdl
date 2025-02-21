from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

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
    check_in_time = db.Column(db.String)
    check_out_time = db.Column(db.String)
    
class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete="CASCADE"), nullable=False)
    location_name = db.Column(db.String, nullable=False)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    work_category = db.Column(
        db.Enum('Lab', 'Home', 'Out Of Office', 'Other', name="work_category_enum"),
        nullable=False
    )


@app.route('/auth/register', methods=['POST'])
def register():
    data = request.json
    new_user = User(
        email=data['email'],
        password=data['password'],  # 암호화 적용 필요
        role=data['role'],
        name=data['name']
    )
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User registered successfully!"}), 201

@app.route('/auth/login', methods=['POST'])
def login():
    data = request.json
    print(f"📌 로그인 요청: {data}")  # ✅ 요청 데이터 확인

    user = User.query.filter_by(email=data['email']).first()
    if user:
        print(f"✅ 사용자 찾음: {user.email}")  # ✅ 사용자 확인
        return jsonify({"user_id": user.id})
    
    print("❌ 로그인 실패")
    return jsonify({"error": "Invalid credentials"}), 401


@app.route('/home/<int:user_id>', methods=['GET'])
def home(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404
    return jsonify({
        "name": user.name,
        "role": user.role
    })

from datetime import datetime

@app.route('/attendance/update', methods=['POST'])
@app.route('/attendance/update', methods=['POST'])
def update_attendance():
    data = request.json
    user_id = data['user_id']
    action = data['action']

<<<<<<< HEAD
=======
    # 현재 시간 기록
>>>>>>> 7d1f08c7d24ea87cc48efb82b88ef878e4714f0e
    current_time = datetime.now().strftime("%H:%M")

    if action == "check_in":
        new_attendance = Attendance(
            user_id=user_id, 
<<<<<<< HEAD
            date=datetime.now().strftime("%Y-%m-%d"), 
            check_in_time=current_time  
=======
            date=datetime.now().strftime("%Y-%m"),
            check_in_time=current_time  # ✅ 출근 시간 기록
>>>>>>> 7d1f08c7d24ea87cc48efb82b88ef878e4714f0e
        )
        db.session.add(new_attendance)
    else:
        attendance = Attendance.query.filter_by(
            user_id=user_id, 
            date=datetime.now().strftime("%Y-%m")
        ).first()

        if attendance:
            attendance.check_out_time = current_time  

    db.session.commit()
    return jsonify({"message": "Attendance updated", "time": current_time}), 200


@app.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    user_list = [
        {
            "id": user.id,
            "email": user.email,
            "name": user.name,
            "role": user.role
        }
        for user in users
    ]
    return jsonify(user_list)


@app.route('/group/users', methods=['GET'])
def get_group_users():
    users = User.query.all()  # 모든 사용자 정보 가져오기
    result = []
    for user in users:
        attendance = Attendance.query.filter_by(user_id=user.id).order_by(Attendance.date.desc()).first()

        result.append({
            "id": user.id,
            "name": user.name,
            "role": user.role,
            "check_in_time": attendance.check_in_time if attendance else "--:--",
            "check_out_time": attendance.check_out_time if attendance else "--:--",
            "category": "My WorkPlace",  # ✅ 카테고리 기본값 설정 (필요하면 DB 필드 추가)
        })

    return jsonify(result)

@app.route('/home/<int:user_id>', methods=['GET'])
def get_home_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404

    attendance = Attendance.query.filter_by(user_id=user_id).order_by(Attendance.date.desc()).first()
    weekly_attendance = Attendance.query.filter_by(user_id=user_id).all()

    weekly_timeline = [
        {
            "date": record.date,
            "check_in_time": record.check_in_time if record.check_in_time else "--:--",
            "check_out_time": record.check_out_time if record.check_out_time else "--:--"
        } for record in weekly_attendance
    ]

    return jsonify({
        "id": user.id,
        "name": user.name,
        "role": user.role,
        "is_checked_in": 1 if attendance and attendance.check_in_time else 0,
        "work_category": "Lab",  # 기본값 (DB에 저장 가능)
        "work_location": "Main Office",  # 기본값 (DB에 저장 가능)
        "check_in_time": attendance.check_in_time if attendance else "--:--",
        "check_out_time": attendance.check_out_time if attendance else "--:--",
        "weeklyTimeline": weekly_timeline
    }), 200



if __name__ == "__main__":
    with app.app_context():
        db.create_all() 
app.run(host="0.0.0.0", port=5000, debug=True)


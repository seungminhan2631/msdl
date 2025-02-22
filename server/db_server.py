from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from datetime import datetime

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
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)
    category = db.Column(db.String, nullable=False)

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

@app.route('/auth/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(email=data['email']).first()
    if user:
        return jsonify({"user_id": user.id})
    return jsonify({"error": "Invalid credentials"}), 401

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
        return jsonify({"error": "User not found"}), 404
    
    return jsonify({
        "id": user.id,
        "name": user.name,
        "role": user.role,
    }), 200

@app.route('/location/update', methods=['POST'])
def update_location():
    data = request.json
    user_id = data['user_id']
    latitude = data['latitude']
    longitude = data['longitude']
    category = data['category']
    
    location = Location.query.filter_by(user_id=user_id).first()
    if location:
        location.latitude = latitude
        location.longitude = longitude
        location.category = category
    else:
        new_location = Location(user_id=user_id, latitude=latitude, longitude=longitude, category=category)
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

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=5000, debug=True)

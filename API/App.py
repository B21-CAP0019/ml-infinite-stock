from flask import Flask, jsonify, make_response, request
from flask_mysqldb import MySQL
import yaml
from flask_restful import abort
from werkzeug.security import generate_password_hash, check_password_hash
import uuid
from flask_expects_json import expects_json
import jwt
import datetime

app = Flask(__name__)
db = yaml.safe_load(open('db.yaml'))
app.config['MYSQL_HOST'] = db['mysql_host']
app.config['MYSQL_USER'] = db['mysql_user']
app.config['MYSQL_PASSWORD'] = db['mysql_password']
app.config['MYSQL_DB'] = db['mysql_db']
app.config['SECRET_KEY'] = 'bangkitCapstone'

mysql = MySQL(app)


# Check data dari client
auth = {
    "type":"object",
    "properties":{
        "email":{
            "type":"string",
            "minLength":10
        },
        "password":{
            "type":"string",
            "minLength":8,
            "maxLength":15
        }
    },
    "required":["email","password"]
}


@app.route('/auth/sign_up',methods=['POST'])
@expects_json(auth)
def sign_up():
    data = request.json
    email = data['email']
    password = generate_password_hash(data['password'], method='sha256')
    public_id = str(uuid.uuid4())
    cursor = mysql.connection.cursor()
    try:
        cursor.execute('INSERT INTO User(public_id,email,password) VALUES (%s, %s, %s);', (public_id, email, password))
        mysql.connection.commit()
    except:
        return make_response(jsonify({"message":"Could not create a new user, DB Error!"}), 500)
    cursor.close()
    token = jwt.encode({'public_id':public_id,'exp':datetime.datetime.utcnow() + datetime.timedelta(days=30)},app.config['SECRET_KEY'],algorithm='HS256')
    return make_response(jsonify({'data':{'token':token},'message':"User created"}),201)

@app.route('/auth/sign_in',methods=['GET'])
@expects_json(auth)
def sign_in():
    data = request.json
    email = data['email']
    print(email)
    password = data['password']
    print(password)
    cursor = mysql.connection.cursor()
    try:
        user_data = cursor.execute('SELECT public_id, email, password, full_name, shop_name FROM User WHERE email = %s LIMIT 1;', [email])
    except:
        return make_response("Querying error!", 500)
    if user_data > 0:
        detail_user = cursor.fetchall()
    else:
        return make_response('Sign in denied, could not find specific user!', 401)
    if check_password_hash(detail_user[0][2],password):
        token = jwt.encode({'public_id':detail_user[0], 'exp':datetime.datetime.utcnow() + datetime.timedelta(days=30)}, app.config['SECRET_KEY'], algorithm='HS256')
        return make_response(jsonify({'data': {'token': token,'full_name':detail_user[0][3],'shop_name':detail_user[0][4]}, 'message': 'Sign in accepted'}),200)
    return make_response('Sign in denied, password and email did not match!',401)


if __name__ == '__main__':
    app.run(debug=True)

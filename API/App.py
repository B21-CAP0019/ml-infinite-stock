from flask import Flask, jsonify, make_response, request
from flask_mysqldb import MySQL
import yaml
from flask_restful import abort
from werkzeug.security import generate_password_hash, check_password_hash
import uuid
from flask_expects_json import expects_json
import jwt
import datetime
from functools import wraps
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler
from sklearn.ensemble import RandomForestRegressor
import pandas as pd
import numpy as np
from sklearn.model_selection import GridSearchCV


app = Flask(__name__)
db = yaml.safe_load(open('db.yaml'))
app.config['MYSQL_HOST'] = db['mysql_host']
app.config['MYSQL_USER'] = db['mysql_user']
app.config['MYSQL_PASSWORD'] = db['mysql_password']
app.config['MYSQL_DB'] = db['mysql_db']
app.config['SECRET_KEY'] = 'bangkitCapstone'

mysql = MySQL(app)

@app.route('/', methods=['GET'])
def success():
    return make_response(jsonify({"message": "Success"}), 200)


@app.route('/auth/signup', methods=['POST'])
def sign_up():
    data = request.form
    email = data['email']
    password = data['password']
    password = generate_password_hash(password, method='sha256')
    public_id = str(uuid.uuid4())
    try:
        cursor = mysql.connection.cursor()
        query = 'INSERT INTO user(public_id,email,password) VALUES (%s, %s, %s);'
        params = (public_id, email, password)
        cursor.execute(query, params)
        mysql.connection.commit()
    except Exception as err:
        return make_response(jsonify({'status': 0, "message": "Could not create a new user, Querying error!", "error": err}), 500)
    finally:
        cursor.close()
    return make_response(jsonify({'data': {'public_id': public_id}, 'status': 1, 'message': 'Sign up success'}), 201)


@app.route('/auth/signin', methods=['GET'])
def sign_in():
    email = request.args.get("email")
    password = request.args.get("password")
    try:
        cursor = mysql.connection.cursor()
        query = 'SELECT public_id, email, password, full_name, shop_name FROM user WHERE email = %s LIMIT 1;'
        params = [email]
        user_data = cursor.execute(query, params)
    except Exception as err:
        return make_response(jsonify({'status': 0, 'message': "Querying error!", 'error': err}), 500)
    if user_data > 0:
        detail_user = cursor.fetchall()
    else:
        return make_response(jsonify({'status': 0, 'message': 'Sign in denied, could not find a specific user!'}), 401)
    if check_password_hash(detail_user[0][2], password):
        return make_response(jsonify({'data': {'public_id': detail_user[0][0], 'full_name': detail_user[0][3], 'shop_name': detail_user[0][4]}, 'status': 1, 'message': 'Sign in success'}), 200)
    cursor.close()
    return make_response(jsonify({'status': 0, 'message': 'Sign in denied, password and email did not match!'}), 401)


def public_id_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        public_id = None
        if 'x-access-publicid' in request.headers:
            public_id = request.headers['x-access-publicid']
        if not public_id:
            return make_response(jsonify({'message': 'Public Id is Missing!'}), 401)
        try:
            cursor = mysql.connection.cursor()
            cursor.execute('SELECT user_id FROM user WHERE public_id = %s LIMIT 1;', [public_id])
        except:
            return make_response(jsonify({'message': 'Public Id is Invalid!'}), 401)
        current_user = cursor.fetchall()
        cursor.close()
        return f(current_user, *args, **kwargs)
    return decorated


@app.route('/warehouse/create/goods', methods=['POST'])
@public_id_required
def create_goods(current_user):
    data = request.form
    goods_name = data['goods_name']
    goods_quantity = data['goods_quantity']
    goods_unit = data['goods_unit']
    goods_price = data['goods_price']
    user_id = current_user[0][0]
    try:
        cursor = mysql.connection.cursor()
        query = 'INSERT INTO goods(goods_name, goods_quantity, goods_unit, goods_price, user_id) VALUES(%s, %s, %s, %s, %s);'
        params = (goods_name, float(goods_quantity),goods_unit, int(goods_price), int(user_id))
        cursor.execute(query, params)
        mysql.connection.commit()
    except:
        return make_response(jsonify({'status': 0, "message": "Could not store a new goods, DB Error!"}), 500)
    finally:
        cursor.close()
    return make_response(jsonify({'status': 1, 'message': 'Success storing a new Goods'}), 201)


@app.route('/warehouse/get/goods/all', methods=['GET'])
@public_id_required
def get_all_goods(current_user):
    current_user = current_user[0][0]
    try:
        cursor = mysql.connection.cursor()
        query = 'SELECT goods_id, goods_name, goods_quantity, goods_unit, goods_price FROM user JOIN goods ON user.user_id = goods.user_id WHERE user.user_id = %s;'
        params = [current_user]
        cursor.execute(query, params)
    except:
        return make_response(jsonify({'status': 0, 'message': "Querying error!"}), 500)
    data = cursor.fetchall()
    if len(data) == 0:
        return make_response(jsonify({'data': {'detail_data': 0, 'total_data': 0}, 'status': 0, 'message': "User have not insert any goods!"}), 200)
    total_data = len(data)
    inner_data = len(data[0])
    detail_data = []
    for goods in data:
        unit = []
        for x in range(0, inner_data):
            unit.append(goods[x])
        detail_data.append(unit)
    response = {
        'data': {
            'detail_data': detail_data,
            'total_data': total_data
        },
        'status': 1,
        'message': 'success getting all goods'
    }
    return make_response(jsonify(response), 200)


@app.route('/warehouse/update/goods', methods=['PUT'])
@public_id_required
def goods_out(current_user):
    data = request.form
    goods_id = data['goods_id']
    goods_name_update = data['goods_name']
    goods_qty_update = data['goods_quantity']
    goods_unit_update = data['goods_unit']
    goods_price_update = data['goods_price']
    # Querying warehouse data
    current_user = current_user[0][0]
    try:
        cursor = mysql.connection.cursor()
        query = "SELECT goods_id, goods_quantity FROM user join goods ON user.user_id = goods.user_id WHERE user.user_id=%s;"
        params = [current_user]
        cursor.execute(query, params)
    except:
        return make_response(jsonify({'status': 0, 'message': "Querying error!"}), 500)
    data = cursor.fetchall()
    cursor.close()
    # finding specific goods
    for x in data:
        if x[0] == goods_id:
            goods = x
    # calculate differences between updated data and warehouse data, to make demand transaction for forecasting
    if goods[1] > goods_qty_update:
        demand = goods[1] - goods_qty_update
        timeseries = datetime.datetime.now()
        try:
            cursor = mysql.connection.cursor()
            query = "INSERT INTO warehousedemand(goods_id, qty, timeseries) VALUES(%s, %s, %s);"
            params = (int(goods_id), float(demand), timeseries)
            cursor.execute(query, params)
            mysql.connection.commit()
        except:
            return make_response(jsonify({'status': 0, "message": "Could not create history transaction, Querying error!"}), 500)
        cursor.close()
    try:
        cursor = mysql.connection.cursor()
        query = "UPDATE goods SET goods_name = %s, goods_quantity = %s, goods_unit = %s, goods_price = %s WHERE goods_id = %s;"
        params = (goods_name_update, float(goods_qty_update),
                  goods_unit_update, int(goods_price_update), int(goods_id))
        cursor.execute(query, params)
        mysql.connection.commit()
    except:
        return make_response(jsonify({'status': 0, "message": "Could not update data warehouse, Querying error!"}), 500)
    cursor.close()
    response = {
        'updated_data': {
            'goods_id': goods_id,
            'goods_name': goods_name_update,
            'goods_quantity': goods_qty_update,
            'goods_unit': goods_unit_update,
            'goods_price': goods_price_update
        },
        'status': 1,
        'message': 'Update data success'
    }
    return make_response(jsonify(response), 200)


@app.route('/warehouse/delete/goods/<goods_id>', methods=['DELETE'])
@public_id_required
def delete_goods(current_user, goods_id):
    try:
        cursor = mysql.connection.cursor()
        query = 'DELETE FROM goods WHERE goods_id = %s'
        params = [goods_id]
        cursor.execute(query, params)
        mysql.connection.commit()
    except:
        return make_response(jsonify({'status': 0, 'message': "Querying error!"}), 500)
    cursor.close()
    return make_response(jsonify({'status': 1, 'message': 'Delete data success'}), 200)


@app.route('/warehouse/demand/predict/<goods_id>', methods=['GET'])
@public_id_required
def predict_demand(current_user, goods_id):
    # retrieves last 150 data from 'WarehouseDemand' table in a database
    try:
        cursor = mysql.connection.cursor()
        query = 'SELECT qty  FROM warehousedemand WHERE goods_id=%s;'
        params = [int(goods_id)]
        data = cursor.execute(query, params)
    except:
        return make_response(jsonify({'status': 0, 'message': "Querying error!"}), 500)
    if data < 120:
        return make_response(jsonify({'status': 0, 'message': 'Not enough data to make predictions'}), 500)
    data = cursor.fetchall()
    if len(data) > 120:
        data = data[-120:]
    tmp_data = []
    for x in data:
        tmp_data.append(x)
    df = pd.DataFrame.from_records(tmp_data, columns=['qty'])
    train = df['qty'].values.astype(np.float32).reshape(-1, 1)
    # ==== Preprocessing ====
    #Nomalize Data
    scaler = MinMaxScaler(feature_range=(0, 1))
    scaler = scaler.fit(train)
    train = scaler.transform(train)
    # Make a DataFrame
    train = pd.DataFrame(train, columns=['qty'])
    # Creating Windowed Dataset
    def windowed_data(dataframe, size, start):
        container = []
        max_data = (len(dataframe) - 1)
        index = start
        iterate = True
        while(iterate):
            list_n = []
            if (index + size) <= max_data:
                list_n.append(dataframe[index: (index+size+1)])
                container.append(list_n[0])
                index += 1
            else:
                iterate = False
        return container
    x_train = windowed_data(train.values.tolist(), 13, 0)
    y_train = windowed_data(train.values.tolist(), 6, 14)
    # Convert into 2D
    def convert_2d(data):
        dim1 = []
        for x in data:
            n = []
            for inner in x:
                n.append(inner[0])
            dim1.append(n)
        dim1 = np.array(dim1, dtype=np.float32)
        return dim1
    x_train = convert_2d(x_train)
    y_train = convert_2d(y_train)
    # Selecting last value for predicting future value
    to_predict = np.array(x_train[-1], dtype=np.float32).reshape(1, -1)
    # Makes shape of x and y tobe equal
    x_train = x_train[:len(y_train)]
    # ====== Modeling ======
    model = RandomForestRegressor(
        n_estimators=200, min_samples_leaf=2, min_samples_split=10, bootstrap=False, criterion='mae')
    model.fit(x_train, y_train)
    prediction = model.predict(to_predict)
    prediction = scaler.inverse_transform(prediction)
    timenow = datetime.datetime.now()
    timenow = timenow.timetuple()
    year = timenow[0]
    month = timenow[1]
    date = timenow[2]
    date_list = []
    for x in range(0, 7):
        dmy = ""
        date += 1
        dmy += f"{date}/{month}/{year}"
        date_list.append(dmy)
    print(date_list)
    response = {
        "data": {
            "day1": {
                "date": date_list[0],
                "prediction": int(round(prediction[0][0]))
            },
            "day2": {
                "date": date_list[1],
                "prediction": int(round(prediction[0][1]))
            },
            "day3": {
                "date": date_list[2],
                "prediction": int(round(prediction[0][2]))
            },
            "day4": {
                "date": date_list[3],
                "prediction": int(round(prediction[0][3]))
            },
            "day5": {
                "date": date_list[4],
                "prediction": int(round(prediction[0][4]))
            },
            "day6": {
                "date": date_list[5],
                "prediction": int(round(prediction[0][5]))
            },
            "day7": {
                "date": date_list[6],
                "prediction": int(round(prediction[0][6]))
            }
        },
        "message": "Success Predicting Data",
        "status": 1
    }
    cursor.close()
    return make_response(jsonify(response), 200)


@app.route('/user/search', methods=['GET'])
def search_publicid():
    public_id = request.args.get('public_id')
    try:
        cursor = mysql.connection.cursor()
        query = "SELECT email, full_name, shop_name  FROM user WHERE public_id = %s;"
        params = [public_id]
        data = cursor.execute(query, params)
    except Exception as err:
        return make_response(jsonify({'data':None,'message':"Could not find a requested public_id! Querying error.",'error':err}), 500)
    found = 0
    message = "User not found!"
    detail_data = {
        "found": found,
        "public_id": None,
        "full_name": None,
        "shop_name": None
    }
    if data == 1:
        data = cursor.fetchall()
        data = data[0]
        found = 1
        message = "User found"
        detail_data = {
            "found": found,
            "public_id": public_id,
            "full_name": data[1],
            "shop_name": data[2]
        }
    response = {
        "data": detail_data,
        "message": message
    }
    return make_response(jsonify(response), 200)


if __name__ == '__main__':
    app.run(debug=True)

# InfiniteStock API Documentation
## Introduction
### Overview of InfiniteStock APIs:

| Methods   | Endpoint API                              | Usage                                         |
|-----------|-------------------------------------------|-----------------------------------------------|
| POST      | /auth/signup                              | Create a new user account                     |
| GET       | /auth/signin                              | Verify a user based on email and password     |
| GET       | /user/search                              | Searching 'public_id' in the DB if exist, to verify whether user should sign in first or not|
| POST      | /warehouse/goods/create                   | Create a new raw material to store in the database|
| GET       | /warehouse/goods/search/name              | Searching particular raw material based on some keyword|
| GET       | /warehouse/goods/get/all                  | Get all raw material data based on 'public_id' user|
| GET       | /warehouse/goods/get                      | Get particular raw material based on 'goods_id'|
| PUT       | /warehouse/goods/update                   | Update raw material data in the database      |
| DELETE    | /warehouse/goods/delete/<goods_id>        | Delete raw material data in the database      |
| GET       | /warehouse/goods/demand/predict/<goods_id>| Get prediction of future demand from particular goods/raw material based on past data|
| GET       | /warehouse/goods/report/goodsout          | Get report data for item data out             |
| GET       | /warehouse/goods/report/goodsin           | Get report data for item data in              |

## Request
### Authentication

| Endpoint API          | Request Body (form-data) |
|-----------------------|--------------------------|
|/auth/signup           | email, password          |

| Endpoint API          | Query Parameter / URL Parameter |
|-----------------------|---------------------------------|
|/auth/signin           | email, password                 |

### Services
| Endpoint API           | Request Body (form-data)                                                |
|------------------------|-------------------------------------------------------------------------|
| /warehouse/goods/create| public_id, goods_name, goods_quantity, goods_unit, goods_price          |
| /warehouse/goods/update| public_id, goods_id, goods_name, goods_quantity, goods_unit, goods_price|

| Endpoint API                      | Query Parameter / URL Parameter   |
|-----------------------------------|-----------------------------------|
| /warehouse/goods/search/name      | public_id, keyword                |
| /warehouse/goods/get              | public_id, goods_id               |
| /warehouse/goods/get/all          | public_id                         |
| /user/search                      | public_id                         |
| /warehouse/goods/report/goodsout  | public_id                         |
| /warehouse/goods/report/goodsin   | public_id                         |

| Endpoint API                              | Relative URL                      |
|-------------------------------------------|-----------------------------------|
|/warehouse/goods/delete/<goods_id>         | goods_id                          |
|/warehouse/goods/demand/predict/<goods_id> | goods_id                          |

## Response

| Endpoint API                      | Response Body                                         | Status Code       |
|-----------------------------------|-------------------------------------------------------|-------------------|
|/auth/signup                       | {"status":Int, "message":String, "error":String}            | 201               |
|/auth/signin                       | {data:{public_id:String, full_name:String, shop_name:String}, status:Int, message:String}| 200|
|/warehouse/goods/create            | {status:Int, message:String}                          | 201               |
|/warehouse/goods/search/name       | {data:{goods_name:String, goods_quantity:Float, goods_unit:String, goods_price:Int}, status:Int, message:String} | 200 |
|/warehouse/goods/get               | {data:{goods_name:String, goods_quantity:Float, goods_unit:String, goods_price:Int}, status:Int, message:String} | 200 |
|/warehouse/goods/get/all           | {data:{detail_data:[{goods_id:Int, goods_name:String, goods_quantity:Float, goods_unit:String, goods_price:Int},{goods_id:Int, goods_name:String, goods_quantity:Float, goods_unit:String, goods_price:Int},...], total_data:Int}, status:Int, message:String} | 200 |
|/warehouse/goods/update            | {updated_data:{goods_id:Int, goods_name:String, goods_quantity:Float, goods_unit:String, goods_price:Int}, status:Int, message:String} | 200 |
|/warehouse/goods/delete/<goods_id> | {status:Int, message:String}                          | 200               |
|/warehouse/godos/demand/predict/<goods_id> | {data:[{date:String, prediction:String},{date:String, prediction:String},...], status:Int, message:String} | 200 |
|/user/search                       | {data:{found:Int, public_id:String, full_name:String, shop_name:String}, message:String} | 200 |
|/warehouse/goods/report/goodsout   | {data:[{datetime:String, goods_name:String, goods_quantity:Float, goods_unit:String},{datetime:String, goods_name:String, goods_quantity:Float, goods_unit:String},...], message:String, status:Int} | 200 |
|/warehouse/goods/report/goodsin    | {data:[{datetime:String, goods_name:String, goods_quantity:Float, goods_unit:String},{datetime:String, goods_name:String, goods_quantity:Float, goods_unit:String},...], message:String, status:Int} | 200 |
# ml-infinite-stock
## InfiniteStock API Documentation
### Introduction
#### Overview of InfiniteStock APIs:

| Methods   | Endpoint API                              | Usage                                         |
|:---------:|:-----------------------------------------:|:---------------------------------------------:|
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
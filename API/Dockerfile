FROM python:3
RUN mkdir /infinite_stock_api
WORKDIR /infinite_stock_api
COPY requirements.txt /infinite_stock_api
RUN pip install --no-cache-dir -r requirements.txt
COPY . /infinite_stock_api
EXPOSE 5000
CMD [ "python", "app.py" ]
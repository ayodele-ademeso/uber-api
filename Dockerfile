FROM python:latest

WORKDIR /app

COPY app/requirements.txt /app
RUN pip install -r requirements.txt

COPY app /app

EXPOSE 5000

CMD ["python", "app.py"]
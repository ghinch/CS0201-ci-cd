FROM python:3.9.5-alpine

COPY requirements.txt /requirements.txt

RUN pip install --upgrade pip
RUN pip install -r /requirements.txt

COPY app.py /app.py

ENTRYPOINT ["python", "-m", "flask", "run", "--host=0.0.0.0"]
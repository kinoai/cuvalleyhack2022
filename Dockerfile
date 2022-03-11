FROM python:3.9-slim-buster


WORKDIR /app/

COPY requirements.txt requirements.txt
COPY setup.py setup.py

RUN python -m pip install --upgrade pip wheel && \
    python -m pip install -r requirements.txt && \
    python -m pip install -e .

COPY src/app.py app.py
COPY src/prediction_data.py prediction_data.py

EXPOSE 8888


ENTRYPOINT ["bash", "start_api.sh"]
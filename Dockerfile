FROM python:latest

WORKDIR /app

# copy source code to working directory
COPY . flask_app/hello.py /app/

RUN python -m pip install --upgrade setuptools pip wheel &&\
    pip install --trusted-host pypi.python.org -r requirements.txt

# exposed host port
EXPOSE 80

# run web.py at container launch
CMD ["python", "hello.py"]
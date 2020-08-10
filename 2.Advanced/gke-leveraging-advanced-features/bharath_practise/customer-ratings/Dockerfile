FROM python
COPY . /src
RUN pip install pandas
RUN pip install gcsfs
RUN pip install google-cloud-storage
CMD ["python", "/src/python.py"]
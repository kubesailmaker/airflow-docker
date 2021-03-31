FROM apache/airflow:2.0.0-python3.8
USER root
RUN mkdir -p /opt/app/ && mkdir -p /opt/work
COPY --chown=airflow:airflow entrypoint.sh /opt/app/entrypoint.sh
COPY --chown=airflow:airflow airflow.cfg /opt/airflow/airflow.cfg
COPY --chown=airflow:airflow webserver_config.py /opt/airflow/webserver_config.py
COPY --chown=airflow:airflow airflow_local_settings.py /opt/airflow/airflow_local_settings.py
VOLUME [ "/opt/work" ]
RUN chmod a+x /opt/app/entrypoint.sh && chown -R airflow /opt/app /opt/work

USER airflow
RUN /usr/local/bin/python -m pip install --upgrade pip && \
    pip3 install "apache-airflow[jdbc]" && \
    pip3 install "apache-airflow[ldap]" && \
    pip3 install "apache-airflow[password]" && \
    pip3 install "apache-airflow[postgres]" && \
    pip3 install "apache-airflow[kubernetes]" && \
    pip3 install oauth2client authlib
WORKDIR "/opt/work"
ENTRYPOINT ["/opt/app/entrypoint.sh"]

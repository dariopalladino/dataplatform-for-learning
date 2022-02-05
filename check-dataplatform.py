import subprocess

#VOLUMES = ['airflow_data', 'airflow_sk_data', 'airflow_w_data', 'elasticsearch_data', 'kafka_1_data', 'kafka_2_data', 'kafka_3_data', 'kibana_data', 'logstash_data', 'logstash_data2', 'postgresql_data', 'pyutils_data', 'redis_fs_data', 'spark_m_data', 'spark_w_data', 'zk_1_data', 'zk_2_data', 'zk_3_data']
VOLUMES = ['test_data2']
for vol in VOLUMES:
    # output = subprocess.run("docker volume inspect -f '{{ .Mountpoint }}' VOLUME", shell=True, capture_output=True)
    # print("this is the output: ", output.stdout.decode('utf8'))
    output = subprocess.check_output(["docker", "volume", "inspect", "-f", "'{{ .Mountpoint }}'", vol, "2>/dev/null"])
    
    print("this is the output: ", output.decode('utf8'))

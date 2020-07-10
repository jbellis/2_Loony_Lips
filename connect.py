from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider

cloud_config= {
        'secure_connect_bundle': 'secure-connect-astra-demo.zip'
}
auth_provider = PlainTextAuthProvider(username, password)
cluster = Cluster(cloud=cloud_config, auth_provider=auth_provider)
session = cluster.connect()
session.set_keyspace('demo')

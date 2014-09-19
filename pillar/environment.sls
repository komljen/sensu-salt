nodes:
  master:
    roles:
      - sensu-server
      - sensu-client
  node01:
    roles:
      - sensu-client
  node02:
    roles:
      - sensu-client

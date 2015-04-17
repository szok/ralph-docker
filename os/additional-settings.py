# Settings for quickscan test
SSH_USER = 'test'
SSH_PASSWORD = 'pass'


# Scrooge settings
VIRTUAL_SERVICES = {
    'XEN': ['10001']
}

OPENSTACK_TENANTS_MODELS = ['OpenStack Juno Tenant']
VIP_TYPES = ['F5']
DATABASE_TYPES = ['Oracle']

UNKNOWN_SERVICES_ENVIRONMENTS = {
    'tenant': {'OpenStack Juno Tenant': ('10004', 'prod')},
    'database': {'Oracle': ('10004', 'prod')},
    'vip': {'F5': ('10004', 'prod')},
}

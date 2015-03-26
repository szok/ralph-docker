import os
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "ralph.settings")

from ralph.discovery.models import Device, DeviceType, Network
from ralph.discovery.tests.util import (
    DeviceFactory,
    DeprecatedDataCenterFactory,
    DeprecatedRackFactory,
)
from ralph_assets.models_assets import (
    AssetCategory,
    ModelVisualizationLayout,
)
from ralph_assets.models_dc_assets import Accessory, Orientation
from ralph_assets.tests.utils.assets import (
    AssetModelFactory,
    DCAssetFactory,
    DataCenterFactory,
    RackAccessoryFactory,
    RackFactory,
    ServerRoomFactory,
)
from ralph.cmdb.tests.utils import (
    CIRelationFactory,
    DeviceEnvironmentFactory,
    ServiceCatalogFactory,
)
from ralph.discovery.models import DiscoveryQueue, Environment, DataCenter

dc, _ = DataCenter.objects.get_or_create(name='dc')
dc.save()

d, _ = DiscoveryQueue.objects.get_or_create(name='default')
d.save()

e, _ = Environment.objects.get_or_create(name='default', data_center=dc)
e.queue = d
e.hosts_naming_template = 'h<200,299>.dc'
e.save()

Device.create(
    model_type=DeviceType.rack, model_name='Default Rack', sn='defaultrack',
)

n, _ = Network.objects.get_or_create(
    name='Default network', address='0.0.0.0/0',
)
n.racks.add(Device.objects.filter(model__type=DeviceType.rack.id)[0])
n.environment = e
n.save()

# core-side stuff
ci_relation = CIRelationFactory(
    parent=ServiceCatalogFactory(name='Default service'),
    child=DeviceEnvironmentFactory(name='Default environment'),
)
default_service = ci_relation.parent
default_env = ci_relation.child

deprecated_ralph_dc = DeprecatedDataCenterFactory(
    service=default_service, device_environment=default_env,
)
deprecated_ralph_rack = DeprecatedRackFactory(
    parent=deprecated_ralph_dc, dc=deprecated_ralph_dc.name,
    service=default_service, device_environment=default_env,
)
device = DeviceFactory(
    parent=deprecated_ralph_rack,
    dc=deprecated_ralph_dc.name,
    rack=deprecated_ralph_rack.name,
    service=default_service, device_environment=default_env,
)

# asset-side stuff
data_center = DataCenterFactory(
    name=deprecated_ralph_dc.name,
    deprecated_ralph_dc=deprecated_ralph_dc,
)
server_room = ServerRoomFactory(
    data_center=data_center,
)
rack = RackFactory(
    name=deprecated_ralph_rack.name,
    data_center=data_center,
    server_room=server_room,
    deprecated_ralph_rack=deprecated_ralph_rack,
    visualization_row=1,
    visualization_col=1,
)
for idx, accessory in enumerate(Accessory.objects.all()):
    RackAccessoryFactory(
        accessory=accessory, rack=rack, position=rack.max_u_height - idx,
    )

rack_server_category = AssetCategory.objects.get(
    slug='2-2-2-data-center-device-server-rack',
)
blade_chassis_category = AssetCategory.objects.get(
    slug='2-2-2-data-center-device-chassis-blade',
)
blade_server_category = AssetCategory.objects.get(
    slug='2-2-2-data-center-device-server-blade',
)
pdu_category = AssetCategory.objects.get(
    slug='2-2-2-data-center-device-pdu',
)


rack_server_model = AssetModelFactory(
    name='rack-server', category=rack_server_category,
)
blade_chassis_model = AssetModelFactory(
    name='blade-chassis', category=blade_chassis_category, height_of_device=10,
    visualization_layout=ModelVisualizationLayout.layout_2x8,
)
blade_chassis_ab_model = AssetModelFactory(
    name='blade-chassis-ab', category=blade_chassis_category,
    height_of_device=10,
    visualization_layout=ModelVisualizationLayout.layout_2x8AB,
)
blade_server_model = AssetModelFactory(
    name='blade-server', category=blade_server_category,
)
pdu_model = AssetModelFactory(
    name='PDU', category=pdu_category,
)

rack_server_asset = DCAssetFactory(
    model=rack_server_model,
    device_info__ralph_device_id=device.id,
    device_info__data_center=data_center,
    device_info__orientation=Orientation.front,
    device_info__position=1,
    device_info__rack=rack,
    device_info__server_room=server_room,
    device_info__slot_no='',
    service=default_service, device_environment=default_env,
)

BLADE_LOCATION = 3
blade_chassis_asset = DCAssetFactory(
    model=blade_chassis_model,
    device_info__data_center=data_center,
    device_info__position=BLADE_LOCATION,
    device_info__rack=rack,
    device_info__server_room=server_room,
    device_info__slot_no='',
    service=default_service, device_environment=default_env,
)
blade_server_assets = [
    DCAssetFactory(
        model=blade_server_model,
        device_info__data_center=data_center,
        device_info__position=BLADE_LOCATION,
        device_info__rack=rack,
        device_info__server_room=server_room,
        device_info__slot_no=slot_no,
        service=default_service, device_environment=default_env,
    ) for slot_no in xrange(1, 17)
]

BLADE_LOCATION2 = BLADE_LOCATION + blade_chassis_model.height_of_device + 1
blade_chassis_asset = DCAssetFactory(
    model=blade_chassis_ab_model,
    device_info__data_center=data_center,
    device_info__position=BLADE_LOCATION2,
    device_info__rack=rack,
    device_info__server_room=server_room,
    device_info__slot_no='',
    service=default_service, device_environment=default_env,
)
blade_server_assets = [
    DCAssetFactory(
        model=blade_server_model,
        device_info__data_center=data_center,
        device_info__position=BLADE_LOCATION2,
        device_info__rack=rack,
        device_info__server_room=server_room,
        device_info__slot_no='{}{}'.format(number, letter),
        service=default_service, device_environment=default_env,
    ) for number in xrange(1, 17) for letter in 'AB'
]

pdu_asset = DCAssetFactory(
    model=pdu_model,
    device_info__data_center=data_center,
    device_info__orientation=Orientation.left.id,
    device_info__position=0,
    device_info__rack=rack,
    device_info__server_room=server_room,
    service=default_service, device_environment=default_env,
)

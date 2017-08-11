from swift.common.utils import Timestamp
from swift.container.backend import ContainerBroker
import time

broker_path='/mnt/sdb1/1/node/sdb3/containers/155/28b/9bd49503214e557dec94935a26de428b/9bd49503214e557dec94935a26de428b.db'
t = Timestamp(time.time()).internal
item = dict(name='zzzzzzzz', created_at=t, size=0,
            content_type='application/octet-stream',
            etag='d41d8cd98f00b204e9800998ecf8427e', deleted=0,
            storage_policy_index=0, record_type=0)
items = [item]

broker = ContainerBroker(broker_path)
broker.merge_items(items)

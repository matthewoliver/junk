from swift.container import sharder
from swift.common.utils import parse_options, readconf

conf, options = parse_options(once=True)
conf = readconf(conf, section_name="container-sharder")

shard = sharder.ContainerSharder(conf, **options)
shard.run_once()
